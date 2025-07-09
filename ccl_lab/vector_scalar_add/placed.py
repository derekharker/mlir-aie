# vector_scalar_add/vector_scalar_add_placed.py -*- Python -*-
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

PROBLEM_SIZE = 1024
AIE_TILE_WIDTH = 32


def my_vector_bias_add():
    @device(AIEDevice.xcvc1902)
    def device_body():
        aie_tile_ty = np.ndarray[(AIE_TILE_WIDTH,), np.dtype[np.int32]]
        all_data_ty = np.ndarray[(PROBLEM_SIZE,), np.dtype[np.int32]]

        # Tile declarations
        ShimTile = tile(3, 0)
        ComputeTile2 = tile(1, 1)

        # AIE-array data movement with object fifos
        # Input
        of_in0 = object_fifo("in0", ShimTile, ComputeTile2, 2, aie_tile_ty)

        # Set up compute tiles

        # Compute tile 2
        @core(ComputeTile2)
        def core_body():
            # Effective while(1)
            for _ in range_(sys.maxsize):
                elem_in = of_in0.acquire(ObjectFifoPort.Produce, 1)
                elem_out = of_in0.acquire(ObjectFifoPort.Consume, 1)
                for i in range_(AIE_TILE_WIDTH):
                    elem_out[i] = elem_in[i] + 1
                of_in0.release(ObjectFifoPort.Produce, 1)
                of_in0.release(ObjectFifoPort.Consume, 1)

        # To/from AIE-array data movement
        @runtime_sequence(all_data_ty, all_data_ty)
        def sequence(inTensor, outTensor):
            in_task = shim_dma_single_bd_task(
                of_in0, inTensor, sizes=[1, 1, 1, PROBLEM_SIZE], issue_token=True
            )


# Declares that subsequent code is in mlir-aie context
with mlir_mod_ctx() as ctx:
    my_vector_bias_add()
    res = ctx.module.operation.verify()
    if res == True:
        print(ctx.module)
    else:
        print(res)