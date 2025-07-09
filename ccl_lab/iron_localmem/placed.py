
import numpy as np
import sys

from aie.dialects.aie import *
from aie.dialects.aiex import *
from aie.extras.context import mlir_mod_ctx
from aie.helpers.dialects.ext.scf import _for as range_


def local_mem():
    @device(AIEDevice.xcvc1902)
    def device_body():
        size = np.ndarray[(32,), np.dtype[np.int32]]

        # Tile declarations
        ComputeTile = tile(1, 4)
        ComputeTile2 = tile(2, 4)

        lock1 = lock(ComputeTile2)
        lock2 = lock(ComputeTile2)

        buf = buffer(ComputeTile2, size)

        # Compute tile 1
        @core(ComputeTile)
        def core_body_tile1():
            aie.UseLockOp(lock1, LockAction.Acquire)
            buf[3] = 14
            aie.UseLockOp(lock1, LockAction.Release)

        # Compute tile 2
        @core(ComputeTile2)
        def core_body_tile2():
            aie.UseLockOp(lock2, LockAction.Acquire)
            aie.UseLockOp(lock1, LockAction.Acquire)
            val = buf[3]
            buf[5] = val + 100
            aie.UseLockOp(lock2, LockAction.Release)
            


# Declares that subsequent code is in mlir-aie context
with mlir_mod_ctx() as ctx:
    local_mem()
    res = ctx.module.operation.verify()
    if res == True:
        print(ctx.module)
    else:
        print(res)