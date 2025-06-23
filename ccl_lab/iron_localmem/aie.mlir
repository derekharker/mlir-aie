module {
  aie.device(xcvc1902) {
    %tile_1_4 = aie.tile(1, 4)
    %tile_2_4 = aie.tile(2, 4)
    %lock_2_4 = aie.lock(%tile_2_4)
    %lock_2_4_0 = aie.lock(%tile_2_4)
    %buffer_2_4 = aie.buffer(%tile_2_4) : memref<32xi32> 
    %core_1_4 = aie.core(%tile_1_4) {
      aie.use_lock(%lock_2_4, Acquire)
      %c3 = arith.constant 3 : index
      %c14_i32 = arith.constant 14 : i32
      memref.store %c14_i32, %buffer_2_4[%c3] : memref<32xi32>
      aie.use_lock(%lock_2_4, Release)
      aie.end
    }
    %core_2_4 = aie.core(%tile_2_4) {
      aie.use_lock(%lock_2_4_0, Acquire)
      aie.use_lock(%lock_2_4, Acquire)
      %c3 = arith.constant 3 : index
      %0 = memref.load %buffer_2_4[%c3] : memref<32xi32>
      %c100_i32 = arith.constant 100 : i32
      %1 = arith.addi %0, %c100_i32 : i32
      %c5 = arith.constant 5 : index
      memref.store %1, %buffer_2_4[%c5] : memref<32xi32>
      aie.use_lock(%lock_2_4_0, Release)
      aie.end
    }
  }
}

