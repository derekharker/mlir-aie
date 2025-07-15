import numpy as np
from aie.dialects.aie import *
from aie.extras.context import mlir_mod_ctx
from aie.extras.dialects.ext import func

def gemm_jacob():
    @device(AIEDevice.xcvc1902)
    def device_body():
        # Define tile
        t = tile(1, 4)

        input_A = np.ndarray[(4,2), np.dtype[np.int32]]
        input_B = np.ndarray[(2,4), np.dtype[np.int32]]
        output_type = np.ndarray[(4,4), np.dtype[np.int32]]

        # Buffer declarations (no symbol names)
        A = buffer(t, name="A", datatype=input_A)
        B = buffer(t, name="B", datatype=input_B)
        C = buffer(t, name="C", datatype=output_type)

        # Lock declaration
        lk = lock(t, lock_id=1)

        # External kernel declaration
        matrix_mult = external_func(
            "gemm_kernel_top",
            inputs=[input_A, input_B, output_type]
        )

        # Core definition
        @core(t, "gemm_kernel.o")
        def core_body():
            use_lock(lk, 0)
            matrix_mult(A, B, C)
            use_lock(lk, 1)

# Generate and print MLIR
with mlir_mod_ctx() as ctx:
    gemm_jacob()
    if ctx.module.operation.verify():
        print(ctx.module)
    else:
        print("Module verification failed.")
