#
# This file is licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
# (c) Copyright 2024 AMD Inc.
import sys
import numpy as np
from aie.dialects.aie import *
from aie.dialects.aiex import *
from aie.helpers.dialects.ext.scf import _for as range_
from aie.extras.context import mlir_mod_ctx

if len(sys.argv) > 1:
    if sys.argv[1] == "npu":
        dev = AIEDevice.npu1_1col
    elif sys.argv[1] == "npu2":
        dev = AIEDevice.npu2_1col
    else:
        raise ValueError("[ERROR] Device name {} is unknown".format(sys.argv[1]))


def join_L2():
    with mlir_mod_ctx() as ctx:

        @device(dev)
        def device_body():
            tile24_ty = np.ndarray[(24,), np.dtype[np.int32]]
            tile8_ty = np.ndarray[(8,), np.dtype[np.int32]]

            # Tile declarations
            ShimTile = tile(0, 0)
            MemTile = tile(0, 1)
            ComputeTile0 = tile(0, 2)
            ComputeTile1 = tile(0, 3)
            ComputeTile2 = tile(0, 4)

            # AIE-array data movement with object fifos
            # Output
            of_out = object_fifo("out", MemTile, ShimTile, 2, tile24_ty)
            of_out0 = object_fifo("out0", ComputeTile0, MemTile, 2, tile8_ty)
            of_out1 = object_fifo("out1", ComputeTile1, MemTile, 2, tile8_ty)
            of_out2 = object_fifo("out2", ComputeTile2, MemTile, 2, tile8_ty)
            object_fifo_link([of_out0, of_out1, of_out2], of_out)

            # Set up compute tiles
            # Compute tile 2
            @core(ComputeTile0)
            def core_body():
                # Effective while(1)
                for _ in range_(6):
                    elem = of_out0.acquire(ObjectFifoPort.Produce, 1)
                    for i in range_(8):
                        elem[i] = 1
                    of_out0.release(ObjectFifoPort.Produce, 1)

            # Compute tile 3
            @core(ComputeTile1)
            def core_body():
                # Effective while(1)
                for _ in range_(6):
                    elem = of_out1.acquire(ObjectFifoPort.Produce, 1)
                    for i in range_(8):
                        elem[i] = 1
                    of_out1.release(ObjectFifoPort.Produce, 1)

            # Compute tile 4
            @core(ComputeTile2)
            def core_body():
                # Effective while(1)
                for _ in range_(6):
                    elem = of_out2.acquire(ObjectFifoPort.Produce, 1)
                    for i in range_(8):
                        elem[i] = 1
                    of_out2.release(ObjectFifoPort.Produce, 1)

    res = ctx.module.operation.verify()
    if res == True:
        print(ctx.module)
    else:
        print(res)


join_L2()
