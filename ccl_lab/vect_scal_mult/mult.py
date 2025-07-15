
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
        CTile = tile(3, 3)

        # AIE-array data movement with object fifos
        buffA = buffer(CTile, name="A", datatype=size)
        buffB = buffer(CTile, name="B", datatype=size)

        lkTile = lock(CTile, lock_id=1)


        # Compute tile 2
        @core(CTile, "vect_scale_mult.o")
        def core_body():  
            use_lock(lkTile, 0)
            vector_scalar_mul_aie_scalar(buffA, buffB, 20, 64)
            use_lock(lkTile, 1)
            

with mlir_mod_ctx() as ctx:
    vector_scal()
    res = ctx.module.operation.verify()
    if res == True:
        print(ctx.module)
    else:
        print(res)