
import numpy as np

from aie.dialects.aie import *  # primary mlir-aie dialect definitions
from aie.extras.context import mlir_mod_ctx  # mlir-aie context
from aie.helpers.dialects.ext.scf import _for as range_


# AI Engine structural design function
def mlir_aie_design():

    # Device declaration - aie2 device NPU
    @device(AIEDevice.xcvc1902)
    def device_body():

        size = np.ndarray[(4,4), np.dtype[np.int32]]
        size2 = np.ndarray[(2,2), np.dtype[np.int32]]
        size_out = np.ndarray[(3,3), np.dtype[np.int32]]

        Tile1 = tile(2,2)

        buff1 = buffer(Tile1, size, name = "buff1")
        buff2 = buffer(Tile1, size2, name = "buff2")
        buff_out = buffer(Tile1, size_out, name = "buff_out")

        lock1 = lock(Tile1, lock_id=1, sym_name = "lock1")

        @core(Tile1)
        def core_body():
            use_lock(lock1, 0)

            for y in range_(0, 3):
                for x in range_(0, 3):
                    buff_out[y, x] = (
                        buff2[0, 0] * buff1[y, x] +
                        buff2[0, 1] * buff1[y, x+1] +
                        buff2[1, 0] * buff1[y+1, x] +
                        buff2[1, 1] * buff1[y+1, x+1]
                    )

            use_lock(lock1, 1)
        


# Declares that subsequent code is in mlir-aie context
with mlir_mod_ctx() as ctx:
    mlir_aie_design()  # Call design function within the mlir-aie context
    print(ctx.module)  # Print the python-to-mlir conversion to stdout
