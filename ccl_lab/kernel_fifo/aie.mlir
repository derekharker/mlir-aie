module {
  aie.device(xcvc1902) {
    %tile_1_4 = aie.tile(1, 4)
    %tile_1_7 = aie.tile(1, 7)
    %lock_a34_8 = aie.lock(%tile_1_7, 1) {sym_name = "lock_a34_8"}
    aie.objectfifo @A(%tile_1_4, {%tile_1_7}, 1 : i32) : !aie.objectfifo<memref<16xi32>> 
    %B = aie.buffer(%tile_1_7) {sym_name = "B"} : memref<16xi32> 
    func.func private @passThroughLine(memref<16xi32>, memref<16xi32>, i32)
    %core_1_4 = aie.core(%tile_1_4) {
      %0 = aie.objectfifo.acquire @A(Produce, 1) : !aie.objectfifosubview<memref<16xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<16xi32>> -> memref<16xi32>
      %c7 = arith.constant 7 : index
      %c4_i32 = arith.constant 4 : i32
      memref.store %c4_i32, %1[%c7] : memref<16xi32>
      aie.objectfifo.release @A(Produce, 1)
      aie.end
    }
    %core_1_7 = aie.core(%tile_1_7) {
      aie.use_lock(%lock_a34_8, "Acquire", 0)
      %0 = aie.objectfifo.acquire @A(Consume, 1) : !aie.objectfifosubview<memref<16xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<16xi32>> -> memref<16xi32>
      %c16_i32 = arith.constant 16 : i32
      func.call @passThroughLine(%1, %B, %c16_i32) : (memref<16xi32>, memref<16xi32>, i32) -> ()
      aie.objectfifo.release @A(Consume, 1)
      aie.use_lock(%lock_a34_8, "Release", 1)
      aie.end
    } {link_with = "passThrough.o"}
  }
}

