import numpy as np
from aie.dialects.aie import *
from aie.extras.context import mlir_mod_ctx
from aie.extras.dialects.ext import func

def passthr():
    @device(AIEDevice.xcvc1902)
    def device_body():
        # Define tile
        t = tile(1, 4)
        r = tile(1, 7)

        input_type = np.ndarray[(16,), np.dtype[np.int32]]

        A = object_fifo("A", t, r, 2, input_type)
        B = buffer(r, name = "B", datatype = input_type)
        

        # Lock declaration
        lk = lock(r, lock_id=1, sym_name="lock")

        # External kernel declaration
        passThrough = external_func(
            "passThroughLine",
            inputs=[input_type, input_type, np.int32, np.int32]
        )

        # Core definition
        @core(r, "passThrough.o")
        def core_t():
            use_lock(lk, 0)
            elem_in = A.acquire(ObjectFifoPort.Consume, 1)
            passThrough(elem_in, B, 1, 16)
            A.release(ObjectFifoPort.Consume, 1)
            use_lock(lk, 1)

# Generate and print MLIR
with mlir_mod_ctx() as ctx:
    passthr()
    if ctx.module.operation.verify():
        print(ctx.module)
    else:
        print("Module verification failed.")
