
import numpy as np
import argparse
import sys

from aie.dialects.aie import *
from aie.dialects.aiex import *
from aie.extras.context import mlir_mod_ctx
from aie.helpers.dialects.ext.scf import _for as range_

import aie.utils.trace as trace_utils


def vector_mult():
    @device(AIEDevice.xcvc1902)
    def device_body():
        # define types
        size = np.ndarray[(64,), np.dtype[np.int32]]

        # Tile declarations
        ShimTile = tile(3, 0)
        ComputeTile2 = tile(0, 2)

        # AIE-array data movement with object fifos
        of_in1 = object_fifo("in1", ShimTile, ComputeTile2, 2, size)
        of_in2 = object_fifo("in2", ShimTile, ComputeTile2, 2, size)
        of_out = object_fifo("out", ComputeTile2, ShimTile, 2, size)


        # Compute tile 2
        @core(ComputeTile2)
        def core_body():
            for _ in range_(sys.maxsize):
                # Number of sub-vector "tile" iterations
                for _ in range_(16):
                    elem_in1 = of_in1.acquire(ObjectFifoPort.Consume, 1)
                    elem_in2 = of_in2.acquire(ObjectFifoPort.Consume, 1)
                    elem_out = of_out.acquire(ObjectFifoPort.Produce, 1)
                    for i in range_(16):
                        elem_out[i] = elem_in1[i] * elem_in2[i]
                    of_in1.release(ObjectFifoPort.Consume, 1)
                    of_in2.release(ObjectFifoPort.Consume, 1)
                    of_out.release(ObjectFifoPort.Produce, 1)

with mlir_mod_ctx() as ctx:
    vector_mult()
    res = ctx.module.operation.verify()
    if res == True:
        print(ctx.module)
    else:
        print(res)