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
        q = tile(3, 5)

        input_type = np.ndarray[(16,), np.dtype[np.int32]]

        lock34_8 = lock(r, lock_id=1, sym_name = "lock_a34_8")

        A = object_fifo("A", t, r, 1, input_type)
        B = object_fifo("B", r, q, 1, input_type)

        # External kernel declaration
        passThrough = external_func(
            "passThroughLine",
            inputs=[input_type, input_type, np.int32]
        )


        @core(t)
        def core_t():
            elem_prod = A.acquire(ObjectFifoPort.Produce, 1)
            elem_prod[7] = 4
            A.release(ObjectFifoPort.Produce, 1)

        # Core definition
        @core(r, "passThrough.o")
        def core_r():
            use_lock(lock34_8, 0)
            elem_out = B.acquire(ObjectFifoPort.Produce, 1)
            elem_in = A.acquire(ObjectFifoPort.Consume, 1)
            passThrough(elem_in, elem_out, 16)
            A.release(ObjectFifoPort.Consume, 1)
            B.release(ObjectFifoPort.Produce, 1)
            use_lock(lock34_8, 1)

        @core(q)
        def core_q():
            elem_prod = B.acquire(ObjectFifoPort.Consume, 1)
            elem_prod[5] = 5
            B.release(ObjectFifoPort.Consume, 1)

# Generate and print MLIR
with mlir_mod_ctx() as ctx:
    passthr()
    if ctx.module.operation.verify():
        print(ctx.module)
    else:
        print("Module verification failed.")
