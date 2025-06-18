
import numpy as np
import argparse
import sys

from aie.dialects.aie import *
from aie.dialects.aiex import *
from aie.extras.context import mlir_mod_ctx
from aie.helpers.dialects.ext.scf import _for as range_

import aie.utils.trace as trace_utils


def vector_scal():
    @device(AIEDevice.xcvc1902)
    def device_body():
        # define types
        size = np.ndarray[(64,), np.dtype[np.int32]]

        # Tile declarations
        ShimTile = tile(3, 0)
        ComputeTile2 = tile(0, 2)

        # AIE-array data movement with object fifos
        of_in = object_fifo("in", ShimTile, ComputeTile2, 2, size)
        of_factor = object_fifo("factor", ShimTile, ComputeTile2, 2, np.ndarray[(1,), np.dtype[np.int32]])
        of_out = object_fifo("out", ComputeTile2, ShimTile, 2, size)

        # Compute tile 2
        @core(ComputeTile2)
        def core_body():
            factor = of_factor.acquire(ObjectFifoPort.Consume, 1)
            elemOut = of_out.acquire(ObjectFifoPort.Produce, 1)
            elemIn = of_in.acquire(ObjectFifoPort.Consume, 1)

            # for i in range_(64):
            #     elemOut[i] = elemIn[i] * factor[0]
            for i in range_(64):
                elemOut[i] = 5

            of_in.release(ObjectFifoPort.Consume, 1)
            of_out.release(ObjectFifoPort.Produce, 1)
            of_factor.release(ObjectFifoPort.Consume, 1)

with mlir_mod_ctx() as ctx:
    vector_scal()
    res = ctx.module.operation.verify()
    if res == True:
        print(ctx.module)
    else:
        print(res)