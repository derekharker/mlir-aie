from aie.dialects.aie import *
from aie.extras.context import mlir_mod_ctx
from aie.helpers.dialects.ext.scf import _for as range_


# AI Engine structural design function
def mlir_aie_design():
    @device(AIEDevice.xcvc1902)
    def device_body():
        A = tile(1, 3)
        B = tile(2, 4)
        of_in = object_fifo("in", A, B, 2, np.ndarray[(256,), np.dtype[np.int32]])

        @core(A)
        def core_body():
            elem = of_in.acquire(ObjectFifoPort.Produce, 1)
            elem[11] += 5
            of_in.release(ObjectFifoPort.Produce, 1)


# Declares that subsequent code is in mlir-aie context
with mlir_mod_ctx() as ctx:
    mlir_aie_design()  # Call design function within the mlir-aie context
    print(ctx.module)  # Print the python-to-mlir conversion to stdout