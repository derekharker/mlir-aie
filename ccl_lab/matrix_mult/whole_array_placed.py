import numpy as np
from ml_dtypes import bfloat16

from aie.extras.context import mlir_mod_ctx
from aie.dialects.aie import *
from aie.dialects.aiex import *
from aie.helpers.dialects.ext.scf import _for as range_
from aie.helpers.taplib import TensorTiler2D, TensorAccessSequence

dtype_in = np.int16
dtype_out = np.int32

def main():
    with mlir_mod_ctx() as ctx:
        my_matmul()
        print(ctx.module)

def ceildiv(a, b):
    return (a + b - 1) // b

def my_matmul():
    M, K, N = 512, 512, 512
    m, k, n = 64, 64, 32
    n_aie_cols = 4
    n_aie_rows = 4
    r, s, t = 4, 4, 4
    fifo_depth = 2

    @device(AIEDevice.xcvc1902)
    def device_body():
        a_ty = np.ndarray[(m, k), np.dtype[dtype_in]]
        b_ty = np.ndarray[(k, n), np.dtype[dtype_in]]
        c_ty = np.ndarray[(m, n), np.dtype[dtype_out]]

        zero = external_func("zero_i32", inputs=[c_ty])
        matmul = external_func("matmul_i16_i32", inputs=[a_ty, b_ty, c_ty])

        shim_tiles = [tile(col, 0) for col in range(n_aie_cols)]
        mem_tiles = [tile(col, 1) for col in range(n_aie_cols)]
        core_tiles = [[tile(col, row + 2) for col in range(n_aie_cols)] for row in range(n_aie_rows)]

        A_l3l2_fifos = [object_fifo(f"inA_{i}", shim_tiles[i], mem_tiles[i], fifo_depth, a_ty) for i in range(n_aie_cols)]
        B_l3l2_fifos = [object_fifo(f"inB_{i}", shim_tiles[i], mem_tiles[i], fifo_depth, b_ty) for i in range(n_aie_cols)]
        C_merge_fifos = [object_fifo(f"mergeC_{i}", mem_tiles[i], mem_tiles[i], fifo_depth, c_ty) for i in range(n_aie_cols)]
        C_l2l3_fifos = [
            object_fifo(f"outC_{i}", mem_tiles[i], shim_tiles[i], fifo_depth, c_ty, [
                (m // r, r * n), (r, t), (n // t, r * t), (t, 1)
            ]) for i in range(n_aie_cols)
        ]

        A_l2l1_fifos = [
            object_fifo(f"memA_{i}", mem_tiles[i], [core_tiles[row][i] for row in range(n_aie_rows)], fifo_depth, a_ty, [
                (m // r, r * k), (k // s, s), (r, k), (s, 1)
            ]) for i in range(n_aie_cols)
        ]
        B_l2l1_fifos = [
            object_fifo(f"memB_{i}", mem_tiles[i], [core_tiles[row][i] for row in range(n_aie_rows)], fifo_depth, b_ty, [
                (k // s, s * n), (n // t, t), (s, n), (t, 1)
            ]) for i in range(n_aie_cols)
        ]
        C_l1l2_fifos = [
            [object_fifo(f"memC_{row}_{col}", core_tiles[row][col], mem_tiles[col], fifo_depth, c_ty) for col in range(n_aie_cols)]
            for row in range(n_aie_rows)
        ]

        for i in range(n_aie_cols):
            object_fifo_link(A_l3l2_fifos[i], A_l2l1_fifos[i])
            object_fifo_link(B_l3l2_fifos[i], B_l2l1_fifos[i])
            object_fifo_link(
                [C_l1l2_fifos[row][i] for row in range(n_aie_rows)],
                C_merge_fifos[i]
            )
            object_fifo_link(C_merge_fifos[i], C_l2l3_fifos[i])

        for row in range(n_aie_rows):
            for col in range(n_aie_cols):

                @core(core_tiles[row][col], f"mm_{m}x{k}x{n}.o")
                def core_body():
                    for _ in range_(0xFFFFFFFF):
                        elem_out = C_l1l2_fifos[row][col].acquire(ObjectFifoPort.Produce, 1)
                        zero(elem_out)
                        for _ in range_(K // k):
                            elem_in_a = A_l2l1_fifos[col].acquire(ObjectFifoPort.Consume, 1)
                            elem_in_b = B_l2l1_fifos[col].acquire(ObjectFifoPort.Consume, 1)
                            matmul(elem_in_a, elem_in_b, elem_out)
                            A_l2l1_fifos[col].release(ObjectFifoPort.Consume, 1)
                            B_l2l1_fifos[col].release(ObjectFifoPort.Consume, 1)
                        C_l1l2_fifos[row][col].release(ObjectFifoPort.Produce, 1)

        @runtime_sequence(
            np.ndarray[(M * K,), np.dtype[dtype_in]],
            np.ndarray[(K * N,), np.dtype[dtype_in]],
            np.ndarray[(M * N,), np.dtype[dtype_out]]
        )
        def sequence(A, B, C):
            for i in range(n_aie_cols):
                dma_start_task(shim_dma_single_bd_task(A_l3l2_fifos[i], A))
                dma_start_task(shim_dma_single_bd_task(B_l3l2_fifos[i], B))
                dma_start_task(shim_dma_single_bd_task(C_l2l3_fifos[i], C, issue_token=True))

if __name__ == "__main__":
    main()
