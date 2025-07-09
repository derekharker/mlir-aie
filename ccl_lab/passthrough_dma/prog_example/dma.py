# passthrough_dmas/passthrough_dmas_placed.py -*- Python -*-
#
# This file is licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
# (c) Copyright 2024 Advanced Micro Devices, Inc. or its affiliates
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
        of_out = object_fifo("out", ComputeTile, ComputeTile2, 1, np.ndarray[(10,), np.dtype[np.int32]])
        of_back = object_fifo("back", ComputeTile2, ComputeTile3, 1, np.ndarray[(10,), np.dtype[np.int32]])

        # Compute tile 2
        @core(ComputeTile)
        def core_body():
            elem = of_out.acquire(ObjectFifoPort.Produce, 1)
            # elem_back = of_back.acquire(ObjectFifoPort.Consume, 1)
            elem[2] = 5
            # elem_back[5] = 9
            of_out.release(ObjectFifoPort.Produce, 1)
            # of_back.release(ObjectFifoPort.Consume, 1)


        @core(ComputeTile2)
        def core_body():
            elem_out = of_out.acquire(ObjectFifoPort.Consume, 1)
            elem_back = of_back.acquire(ObjectFifoPort.Produce, 1)
            elem_out[1] = 4
            for i in range_(10):
                elem_back[i] = elem_out[i]
            elem_back[6] = 3
            of_out.release(ObjectFifoPort.Consume, 1)
            of_back.release(ObjectFifoPort.Produce, 1)

        @core(ComputeTile3)
        def core_body():
            elem_rec = of_back.acquire(ObjectFifoPort.Consume, 1)
            elem_rec[5] = 9
            of_back.release(ObjectFifoPort.Consume, 1)

with mlir_mod_ctx() as ctx:
    my_passthrough()
    res = ctx.module.operation.verify()
    if res == True:
        print(ctx.module)
    else:
        print(res)