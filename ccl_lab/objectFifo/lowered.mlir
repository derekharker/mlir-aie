module @tutorial_3 {
  aie.device(xcvc1902) {
    memref.global "public" @of : memref<256xi32>
    %tile_1_3 = aie.tile(1, 3)
    %tile_2_3 = aie.tile(2, 3)
    %of_buff_0 = aie.buffer(%tile_1_3) {sym_name = "of_buff_0"} : memref<256xi32> 
    %of_buff_1 = aie.buffer(%tile_1_3) {sym_name = "of_buff_1"} : memref<256xi32> 
    %of_lock_0 = aie.lock(%tile_1_3, 0) {init = 0 : i32, sym_name = "of_lock_0"}
    %of_lock_1 = aie.lock(%tile_1_3, 1) {init = 0 : i32, sym_name = "of_lock_1"}
    %lock_a24_2 = aie.lock(%tile_2_3, 2) {sym_name = "lock_a24_2"}
    %core_1_3 = aie.core(%tile_1_3) {
      aie.use_lock(%of_lock_0, Acquire, 0)
      %c14_i32 = arith.constant 14 : i32
      %c3 = arith.constant 3 : index
      memref.store %c14_i32, %of_buff_0[%c3] : memref<256xi32>
      aie.use_lock(%of_lock_0, Release, 1)
      aie.end
    }
    %core_2_3 = aie.core(%tile_2_3) {
      aie.use_lock(%lock_a24_2, Acquire, 0)
      aie.use_lock(%of_lock_0, Acquire, 1)
      %c3 = arith.constant 3 : index
      %0 = memref.load %of_buff_0[%c3] : memref<256xi32>
      %c100_i32 = arith.constant 100 : i32
      %1 = arith.addi %0, %c100_i32 : i32
      %c5 = arith.constant 5 : index
      memref.store %1, %of_buff_0[%c5] : memref<256xi32>
      aie.use_lock(%of_lock_0, Release, 0)
      aie.use_lock(%lock_a24_2, Release, 1)
      aie.end
    }
  }
}

