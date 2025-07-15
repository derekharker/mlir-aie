import numpy as np
from aie.dialects.aie import *
from aie.extras.context import mlir_mod_ctx
from aie.extras.dialects.ext import func

def passthr():
    @device(AIEDevice.xcvc1902)
    def device_body():
        # Define tile
        t = tile(1, 4)
        r = tile(1, 5)

        input_type = np.ndarray[(1024,), np.dtype[np.int32]]

        # Buffer declarations (no symbol names)
        A = buffer(t, name="A", datatype=input_type)
        B = buffer(r, name="B", datatype=input_type)

        # Lock declaration
        lk = lock(t, lock_id=1)

        # External kernel declaration
        passThrough = external_func(
            "passThroughLine",
            inputs=[input_type, input_type, np.int32, np.int32]
        )

        # Core definition
        @core(t, "passThrough.o")
        def core_t():
            use_lock(lk, 0)
            passThrough(A, B, 1, 1024)
            use_lock(lk, 1)

# Generate and print MLIR
with mlir_mod_ctx() as ctx:
    passthr()
    if ctx.module.operation.verify():
        print(ctx.module)
    else:
        print("Module verification failed.")
