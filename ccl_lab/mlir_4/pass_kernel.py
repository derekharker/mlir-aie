
import numpy as np
import argparse
import sys

from aie.dialects.aie import *
from aie.dialects.aiex import *
from aie.extras.context import mlir_mod_ctx
from aie.helpers.dialects.ext.scf import _for as range_
from aie.helpers.dialects.ext.func import func

import aie.utils.trace as trace_utils


def my_kernel():
    @device(AIEDevice.xcvc1902)
    def device_body():
        # define types
        line_ty = np.ndarray[(256,), np.dtype[np.int32]]

        # Tile declarations
        tile14 = tile(1, 4)
        tile34 = tile(3, 4)

        lock34_8 = lock(tile34, lock_id=1, sym_name = "lock_a34_8")

        # AIE-array data movement with object fifos
        of = object_fifo("of", tile14, tile34, 1, line_ty)


        @core(tile14)
        def core14_body():
            elemProduce = of.acquire(ObjectFifoPort.Produce, 1)
            elemProduce[3] = 14
            of.release(ObjectFifoPort.Produce, 1)

        @core(tile34)
        def core34_body():
            use_lock(lock34_8, 0)
            elemIn = of.acquire(ObjectFifoPort.Consume, 1)
            elemIn[5] = elemIn[3] + 100
            of.release(ObjectFifoPort.Consume, 1)
            use_lock(lock34_8, 1)

with mlir_mod_ctx() as ctx:
    my_kernel()
    res = ctx.module.operation.verify()
    if res == True:
        print(ctx.module)
    else:
        print(res)