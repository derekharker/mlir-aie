import numpy as np
import argparse
import sys

from aie.dialects.aie import *
from aie.dialects.aiex import *
from aie.extras.context import mlir_mod_ctx
from aie.helpers.dialects.ext.scf import _for as range_
from aie.helpers.dialects.ext.func import func

import aie.utils.trace as trace_utils


def copy():
    @device(AIEDevice.xcvc1902)
    def device_body():
        # define types

        Tile1_4 = tile(1, 4)

        a14 = buffer(Tile1_4, name="a14", datatype=np.ndarray[(256,), np.dtype[np.int32]])

        lock14_0 = lock(Tile1_4, lock_id=1)

        kernel_func = external_func(
            "extern_kernel", inputs=[np.ndarray[(256,), np.dtype[np.int32]]]
        )

        # Compute tile 2
        @core(Tile1_4, "kernel.o")
        def core_body():
            use_lock(lock14_0, 0)
            kernel_func(a14)
            use_lock(lock14_0, 1)
            

with mlir_mod_ctx() as ctx:
    copy()
    res = ctx.module.operation.verify()
    if res == True:
        print(ctx.module)
    else:
        print(res)