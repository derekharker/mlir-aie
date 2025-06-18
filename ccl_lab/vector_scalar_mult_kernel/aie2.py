
import numpy as np
import sys

from aie.dialects.aie import *
from aie.extras.context import mlir_mod_ctx
from aie.helpers.dialects.ext.scf import _for as range_

tensor_size = 4096
tile_size = tensor_size // 4   #1024

# Define tensor types
tensor_ty = np.ndarray[(tensor_size,), np.dtype[np.int32]]
tile_ty = np.ndarray[(tile_size,), np.dtype[np.int32]]
scalar_ty = np.ndarray[(1,), np.dtype[np.int32]]

def mlir_aie_design():
    @device(AIEDevice.xcvc1902)
    def device_body():

        func_type = "vector" if vectorized else "scalar"
        scale = external_func(
            f"vector_scalar_mul_{func_type}",
            inputs=[tile_ty, tile_ty, scalar_ty, np.int32],
        )

        A = tile(1, 3)
        Shim = tile(0, 3)

        of_in = object_fifo("in", Shim, A, 2, tile_ty)
        of_factor = object_fifo("infactor", Shim, A, 2, scalar_ty)

        # Output data movement
        of_out = object_fifo("out", A, Shim, 2, tile_ty)


        @core(A, "scale.o")
        def core_body():
            elem_factor = of_factor.acquire(ObjectFifoPort.Produce, 1)
            for _ in range_(4):
                elem_in = of_in.acquire(ObjectFifoPort.Produce, 1)
                elem_out = of_out.acquire(ObjectFifoPort.Produce, 1)
                # elem_out[0] = elem_in[0] * elem_factor
                of_in.release(ObjectFifoPort.Produce, 1)
                of_out.release(ObjectFifoPort.Produce, 1)
            of_factor.release(ObjectFifoPort.Produce, 1)



with mlir_mod_ctx() as ctx:
    res = ctx.module.operation.verify()
    if res == True:
        print(ctx.module)
    else:
        print(res)
