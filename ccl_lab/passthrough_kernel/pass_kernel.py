
import numpy as np
import argparse
import sys

from aie.dialects.aie import *
from aie.dialects.aiex import *
from aie.extras.context import mlir_mod_ctx
from aie.helpers.dialects.ext.scf import _for as range_
from aie.helpers.dialects.ext.func import func

import aie.utils.trace as trace_utils


def my_passthrough_kernel():
    @device(AIEDevice.xcvc1902)
    def device_body():
        # define types
        line_ty = np.ndarray[(32,), np.dtype[np.int32]]

        passThroughLine = external_func(
            "passThroughLine", inputs=[line_ty, line_ty, np.int32]
        )

        # Tile declarations
        ShimTile = tile(3, 0)
        ComputeTile2 = tile(3, 3)

        lock_C = lock(ComputeTile2, lock_id=1)

        # AIE-array data movement with object fifos
        of_in = object_fifo("in", ShimTile, ComputeTile2, 2, line_ty)
        of_out = object_fifo("out", ComputeTile2, ShimTile, 2, line_ty)

        # Set up compute tiles

        # Compute tile 2
        @core(ComputeTile2, "passThrough.cc.o")
        def core_body():
            use_lock(lock_C, 0)
            elemOut = of_out.acquire(ObjectFifoPort.Produce, 1)
            elemIn = of_in.acquire(ObjectFifoPort.Consume, 1)
            passThroughLine(elemIn, elemOut, 32)
            of_in.release(ObjectFifoPort.Consume, 1)
            of_out.release(ObjectFifoPort.Produce, 1)
            use_lock(lock_C, 1)

with mlir_mod_ctx() as ctx:
    my_passthrough_kernel()
    res = ctx.module.operation.verify()
    if res == True:
        print(ctx.module)
    else:
        print(res)