
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

        vector_scalar_mul_aie_scalar = external_func(
            "vector_scalar_mul_aie_scalar",
            inputs=[size, size, np.int32, np.int32]
        )

        # Tile declarations
        ShimTile = tile(3, 3)
        ComputeTile2 = tile(0, 2)

        # AIE-array data movement with object fifos
        of_in = object_fifo("in", ShimTile, ComputeTile2, 2, size)
        of_out = object_fifo("out", ComputeTile2, ShimTile, 2, size)


        # Compute tile 2
        @core(ComputeTile2, "vect_scale_mult.o")
        def core_body():  
            elemIn = of_in.acquire(ObjectFifoPort.Consume, 1)
            elemOut = of_out.acquire(ObjectFifoPort.Produce, 1)
            vector_scalar_mul_aie_scalar(elemIn, elemOut, 20, 64)
            of_in.release(ObjectFifoPort.Consume, 1)
            of_out.release(ObjectFifoPort.Produce, 1)
            

with mlir_mod_ctx() as ctx:
    vector_scal()
    res = ctx.module.operation.verify()
    if res == True:
        print(ctx.module)
    else:
        print(res)