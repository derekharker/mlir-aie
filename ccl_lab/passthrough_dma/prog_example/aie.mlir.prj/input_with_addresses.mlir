module {
  aie.device(xcvc1902) {
    memref.global "public" @back_cons : memref<10xi32>
    memref.global "public" @back : memref<10xi32>
    memref.global "public" @out_cons : memref<10xi32>
    memref.global "public" @out : memref<10xi32>
    %tile_1_1 = aie.tile(1, 1)
    %tile_2_3 = aie.tile(2, 3)
    %back_cons_buff_0 = aie.buffer(%tile_1_1) {address = 1024 : i32, mem_bank = 0 : i32, sym_name = "back_cons_buff_0"} : memref<10xi32> 
    %back_cons_lock_0 = aie.lock(%tile_1_1, 1) {init = 0 : i32, sym_name = "back_cons_lock_0"}
    %back_buff_0 = aie.buffer(%tile_2_3) {address = 1024 : i32, mem_bank = 0 : i32, sym_name = "back_buff_0"} : memref<10xi32> 
    %back_lock_0 = aie.lock(%tile_2_3, 1) {init = 0 : i32, sym_name = "back_lock_0"}
    %out_cons_buff_0 = aie.buffer(%tile_2_3) {address = 8192 : i32, mem_bank = 1 : i32, sym_name = "out_cons_buff_0"} : memref<10xi32> 
    %out_cons_lock_0 = aie.lock(%tile_2_3, 0) {init = 0 : i32, sym_name = "out_cons_lock_0"}
    %out_buff_0 = aie.buffer(%tile_1_1) {address = 8192 : i32, mem_bank = 1 : i32, sym_name = "out_buff_0"} : memref<10xi32> 
    %out_lock_0 = aie.lock(%tile_1_1, 0) {init = 0 : i32, sym_name = "out_lock_0"}
    aie.flow(%tile_1_1, DMA : 0, %tile_2_3, DMA : 0)
    aie.flow(%tile_2_3, DMA : 0, %tile_1_1, DMA : 0)
    %core_1_1 = aie.core(%tile_1_1) {
      aie.use_lock(%out_lock_0, Acquire, 0)
      %c2 = arith.constant 2 : index
      %c5_i32 = arith.constant 5 : i32
      memref.store %c5_i32, %out_buff_0[%c2] : memref<10xi32>
      aie.use_lock(%out_lock_0, Release, 1)
      aie.use_lock(%back_cons_lock_0, Acquire, 1)
      %c5 = arith.constant 5 : index
      %c9_i32 = arith.constant 9 : i32
      memref.store %c9_i32, %back_cons_buff_0[%c5] : memref<10xi32>
      aie.use_lock(%back_cons_lock_0, Release, 0)
      aie.end
    }
    %core_2_3 = aie.core(%tile_2_3) {
      aie.use_lock(%out_cons_lock_0, Acquire, 1)
      aie.use_lock(%back_lock_0, Acquire, 0)
      %c1 = arith.constant 1 : index
      %c4_i32 = arith.constant 4 : i32
      memref.store %c4_i32, %out_cons_buff_0[%c1] : memref<10xi32>
      %c0 = arith.constant 0 : index
      %c10 = arith.constant 10 : index
      %c1_0 = arith.constant 1 : index
      cf.br ^bb1(%c0 : index)
    ^bb1(%0: index):  // 2 preds: ^bb0, ^bb2
      %1 = arith.cmpi slt, %0, %c10 : index
      cf.cond_br %1, ^bb2, ^bb3
    ^bb2:  // pred: ^bb1
      %2 = memref.load %out_cons_buff_0[%0] : memref<10xi32>
      memref.store %2, %back_buff_0[%0] : memref<10xi32>
      %3 = arith.addi %0, %c1_0 : index
      cf.br ^bb1(%3 : index)
    ^bb3:  // pred: ^bb1
      %c6 = arith.constant 6 : index
      %c3_i32 = arith.constant 3 : i32
      memref.store %c3_i32, %back_buff_0[%c6] : memref<10xi32>
      aie.use_lock(%out_cons_lock_0, Release, 0)
      aie.use_lock(%back_lock_0, Release, 1)
      aie.end
    }
    %mem_1_1 = aie.mem(%tile_1_1) {
      %0 = aie.dma_start(MM2S, 0, ^bb1, ^bb2)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%out_lock_0, Acquire, 1)
      aie.dma_bd(%out_buff_0 : memref<10xi32>, 0, 10) {bd_id = 0 : i32, next_bd_id = 0 : i32}
      aie.use_lock(%out_lock_0, Release, 0)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 0, ^bb3, ^bb4)
    ^bb3:  // 2 preds: ^bb2, ^bb3
      aie.use_lock(%back_cons_lock_0, Acquire, 0)
      aie.dma_bd(%back_cons_buff_0 : memref<10xi32>, 0, 10) {bd_id = 1 : i32, next_bd_id = 1 : i32}
      aie.use_lock(%back_cons_lock_0, Release, 1)
      aie.next_bd ^bb3
    ^bb4:  // pred: ^bb2
      aie.end
    }
    %mem_2_3 = aie.mem(%tile_2_3) {
      %0 = aie.dma_start(S2MM, 0, ^bb1, ^bb2)
    ^bb1:  // 2 preds: ^bb0, ^bb1
      aie.use_lock(%out_cons_lock_0, Acquire, 0)
      aie.dma_bd(%out_cons_buff_0 : memref<10xi32>, 0, 10) {bd_id = 0 : i32, next_bd_id = 0 : i32}
      aie.use_lock(%out_cons_lock_0, Release, 1)
      aie.next_bd ^bb1
    ^bb2:  // pred: ^bb0
      %1 = aie.dma_start(MM2S, 0, ^bb3, ^bb4)
    ^bb3:  // 2 preds: ^bb2, ^bb3
      aie.use_lock(%back_lock_0, Acquire, 1)
      aie.dma_bd(%back_buff_0 : memref<10xi32>, 0, 10) {bd_id = 1 : i32, next_bd_id = 1 : i32}
      aie.use_lock(%back_lock_0, Release, 0)
      aie.next_bd ^bb3
    ^bb4:  // pred: ^bb2
      aie.end
    }
  }
}
