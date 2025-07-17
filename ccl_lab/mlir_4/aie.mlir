module {
  aie.device(xcvc1902) {
    %tile_1_4 = aie.tile(1, 4)
    %tile_3_4 = aie.tile(3, 4)
    %lock_a34_8 = aie.lock(%tile_3_4, 1) {sym_name = "lock_a34_8"}
    aie.objectfifo @of(%tile_1_4, {%tile_3_4}, 1 : i32) : !aie.objectfifo<memref<256xi32>> 
    %core_1_4 = aie.core(%tile_1_4) {
      %0 = aie.objectfifo.acquire @of(Produce, 1) : !aie.objectfifosubview<memref<256xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<256xi32>> -> memref<256xi32>
      %c3 = arith.constant 3 : index
      %c14_i32 = arith.constant 14 : i32
      memref.store %c14_i32, %1[%c3] : memref<256xi32>
      aie.objectfifo.release @of(Produce, 1)
      aie.end
    }
    %core_3_4 = aie.core(%tile_3_4) {
      aie.use_lock(%lock_a34_8, "Acquire", 0)
      %0 = aie.objectfifo.acquire @of(Consume, 1) : !aie.objectfifosubview<memref<256xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<256xi32>> -> memref<256xi32>
      %c3 = arith.constant 3 : index
      %2 = memref.load %1[%c3] : memref<256xi32>
      %c100_i32 = arith.constant 100 : i32
      %3 = arith.addi %2, %c100_i32 : i32
      %c5 = arith.constant 5 : index
      memref.store %3, %1[%c5] : memref<256xi32>
      aie.objectfifo.release @of(Consume, 1)
      aie.use_lock(%lock_a34_8, "Release", 1)
      aie.end
    }
  }
}

