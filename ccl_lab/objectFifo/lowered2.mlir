module @tutorial_4 {
  aie.device(xcvc1902) {
    memref.global "public" @of_cons : memref<256xi32>
    memref.global "public" @of : memref<256xi32>
    %tile_1_4 = aie.tile(1, 4)
    %tile_3_4 = aie.tile(3, 4)
    %of_cons_buff_0 = aie.buffer(%tile_3_4) {sym_name = "of_cons_buff_0"} : memref<256xi32> 
    %of_cons_buff_1 = aie.buffer(%tile_3_4) {sym_name = "of_cons_buff_1"} : memref<256xi32> 
    %of_cons_lock_0 = aie.lock(%tile_3_4, 0) {init = 0 : i32, sym_name = "of_cons_lock_0"}
    %of_cons_lock_1 = aie.lock(%tile_3_4, 1) {init = 0 : i32, sym_name = "of_cons_lock_1"}
    %of_buff_0 = aie.buffer(%tile_1_4) {sym_name = "of_buff_0"} : memref<256xi32> 
    %of_buff_1 = aie.buffer(%tile_1_4) {sym_name = "of_buff_1"} : memref<256xi32> 
    %of_buff_2 = aie.buffer(%tile_1_4) {sym_name = "of_buff_2"} : memref<256xi32> 
    %of_lock_0 = aie.lock(%tile_1_4, 0) {init = 0 : i32, sym_name = "of_lock_0"}
    %of_lock_1 = aie.lock(%tile_1_4, 1) {init = 0 : i32, sym_name = "of_lock_1"}
    %of_lock_2 = aie.lock(%tile_1_4, 2) {init = 0 : i32, sym_name = "of_lock_2"}
    aie.flow(%tile_1_4, DMA : 0, %tile_3_4, DMA : 0)
    %lock_a34_8 = aie.lock(%tile_3_4, 8) {sym_name = "lock_a34_8"}
    %core_1_4 = aie.core(%tile_1_4) {
      aie.use_lock(%of_lock_0, Acquire, 0)
      aie.use_lock(%of_lock_1, Acquire, 0)
      %c14_i32 = arith.constant 14 : i32
      %c3 = arith.constant 3 : index
      memref.store %c14_i32, %of_buff_0[%c3] : memref<256xi32>
      aie.use_lock(%of_lock_0, Release, 1)
      aie.end
    }
    %core_3_4 = aie.core(%tile_3_4) {
      aie.use_lock(%lock_a34_8, Acquire, 0)
      aie.use_lock(%of_cons_lock_0, Acquire, 1)
      %c3 = arith.constant 3 : index
      %0 = memref.load %of_cons_buff_0[%c3] : memref<256xi32>
      %c100_i32 = arith.constant 100 : i32
      %1 = arith.addi %0, %c100_i32 : i32
      %c5 = arith.constant 5 : index
      memref.store %1, %of_cons_buff_0[%c5] : memref<256xi32>
      aie.use_lock(%of_cons_lock_0, Release, 0)
      aie.use_lock(%lock_a34_8, Release, 1)
      aie.end
    }
    %mem_1_4 = aie.mem(%tile_1_4) {
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb4)
    ^bb1:  // 2 preds: ^bb0, ^bb3
      aie.use_lock(%of_lock_0, Acquire, 1)
      aie.dma_bd(%of_buff_0 : memref<256xi32>, 0, 256)
      aie.use_lock(%of_lock_0, Release, 0)
      aie.next_bd ^bb2
    ^bb2:  // pred: ^bb1
      aie.use_lock(%of_lock_1, Acquire, 1)
      aie.dma_bd(%of_buff_1 : memref<256xi32>, 0, 256)
      aie.use_lock(%of_lock_1, Release, 0)
      aie.next_bd ^bb3
    ^bb3:  // pred: ^bb2
      aie.use_lock(%of_lock_2, Acquire, 1)
      aie.dma_bd(%of_buff_2 : memref<256xi32>, 0, 256)
      aie.use_lock(%of_lock_2, Release, 0)
      aie.next_bd ^bb1
    ^bb4:  // pred: ^bb0
      aie.end
    }
    %mem_3_4 = aie.mem(%tile_3_4) {
      %0 = aie.dma_start(S2MM, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb2
      aie.use_lock(%of_cons_lock_0, Acquire, 0)
      aie.dma_bd(%of_cons_buff_0 : memref<256xi32>, 0, 256)
      aie.use_lock(%of_cons_lock_0, Release, 1)
      aie.next_bd ^bb2
    ^bb2:  // pred: ^bb1
      aie.use_lock(%of_cons_lock_1, Acquire, 0)
      aie.dma_bd(%of_cons_buff_1 : memref<256xi32>, 0, 256)
      aie.use_lock(%of_cons_lock_1, Release, 1)
      aie.next_bd ^bb1
    ^bb3:  // pred: ^bb0
      aie.end
    }
  }
}

