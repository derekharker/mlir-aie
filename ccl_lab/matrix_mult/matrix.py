import numpy as np
from aie.dialects.aie import *
from aie.extras.context import mlir_mod_ctx
from aie.extras.dialects.ext import func

def build():
    @device(AIEDevice.xcvc1902)
    def device_body():
        # Define tile
        t = tile(1, 4)

        input_type = np.ndarray[(1024,), np.dtype[np.int32]]

        # Buffer declarations (no symbol names)
        A = buffer(t, name="A", datatype=input_type)
        B = buffer(t, name="B", datatype=input_type)
        acc = buffer(t, name="acc", datatype=input_type)
        C = buffer(t, name="C", datatype=input_type)

        # Lock declaration
        lk = lock(t, lock_id=1)

        # External kernel declaration
        extern_func = external_func(
            "extern_kernel",
            inputs=[input_type, input_type, input_type, input_type]
        )

        # Core definition
        @core(t, "kernel.o")
        def core_body():
            use_lock(lk, 0)
            extern_func(A, B, acc, C)
            use_lock(lk, 1)

# Generate and print MLIR
with mlir_mod_ctx() as ctx:
    build()
    if ctx.module.operation.verify():
        print(ctx.module)
    else:
        print("Module verification failed.")
