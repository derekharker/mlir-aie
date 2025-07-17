module {
  aie.device(xcvc1902) {
    func.func private @passThroughLine(memref<32xi32>, memref<32xi32>, i32)
    %tile_3_5 = aie.tile(3, 5)
    %tile_3_3 = aie.tile(3, 3)
    %lock = aie.lock(%tile_3_3, 1) {sym_name = "lock"}
    aie.objectfifo @in(%tile_3_5, {%tile_3_3}, 2 : i32) : !aie.objectfifo<memref<32xi32>> 
    aie.objectfifo @out(%tile_3_3, {%tile_3_5}, 2 : i32) : !aie.objectfifo<memref<32xi32>> 
    %core_3_3 = aie.core(%tile_3_3) {
      aie.use_lock(%lock, "Acquire", 0)
      %0 = aie.objectfifo.acquire @out(Produce, 1) : !aie.objectfifosubview<memref<32xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<32xi32>> -> memref<32xi32>
      %2 = aie.objectfifo.acquire @in(Consume, 1) : !aie.objectfifosubview<memref<32xi32>>
      %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<32xi32>> -> memref<32xi32>
      %c32_i32 = arith.constant 32 : i32
      func.call @passThroughLine(%3, %1, %c32_i32) : (memref<32xi32>, memref<32xi32>, i32) -> ()
      aie.objectfifo.release @in(Consume, 1)
      aie.objectfifo.release @out(Produce, 1)
      aie.use_lock(%lock, "Release", 1)
      aie.end
    } {link_with = "passThrough.cc.o"}
  }
}

