
import numpy as np
import sys

from aie.dialects.aie import *
from aie.dialects.aiex import *
from aie.extras.context import mlir_mod_ctx
from aie.helpers.dialects.ext.scf import _for as range_


def my_passthrough():
    @device(AIEDevice.xcvc1902)
    def device_body():

        # Tile declarations
        ComputeTile = tile(1, 1)
        ComputeTile2 = tile(2, 3)
        ComputeTile3 = tile(3, 4)

        # AIE-array data movement with object fifos
        of_in1 = object_fifo("in1", ComputeTile, ComputeTile2, 1, np.ndarray[(64,), np.dtype[np.int32]])
        of_in2 = object_fifo("in2", ComputeTile, ComputeTile2, 1, np.ndarray[(64,), np.dtype[np.int32]])
        of_out = object_fifo("out", ComputeTile2, ComputeTile3, 1, np.ndarray[(64,), np.dtype[np.int32]])

        # Compute tile 2
        @core(ComputeTile)
        def core_body_tile1():
            elem = of_in1.acquire(ObjectFifoPort.Produce, 1)
            elem[2] = 5
            of_in1.release(ObjectFifoPort.Produce, 1)

        @core(ComputeTile2)
        def core_body_tile2():
            elem_out = of_in1.acquire(ObjectFifoPort.Consume, 1)
            elem_out2 = of_in2.acquire(ObjectFifoPort.Consume, 1)
            elem_pass = of_out.acquire(ObjectFifoPort.Produce, 1)
            for i in range_(10):
                elem_pass[i] = elem_out[i] * elem_out2[i]
            of_in1.release(ObjectFifoPort.Consume, 1)
            of_in2.release(ObjectFifoPort.Consume, 1)
            of_out.release(ObjectFifoPort.Produce, 1)

        @core(ComputeTile3)
        def core_body_tile3():
            elem_pass = of_out.acquire(ObjectFifoPort.Consume, 1)
            elem_pass[3] = 1
            of_out.release(ObjectFifoPort.Consume, 1)

with mlir_mod_ctx() as ctx:
    my_passthrough()
    res = ctx.module.operation.verify()
    if res == True:
        print(ctx.module)
    else:
        print(res)