module {
  aie.device(xcvc1902) {
    %tile_1_1 = aie.tile(1, 1)
    %tile_2_3 = aie.tile(2, 3)
    %tile_3_4 = aie.tile(3, 4)
    func.func private @passThroughLine(memref<16xi32>, memref<16xi32>, i32)
    aie.objectfifo @out(%tile_1_1, {%tile_2_3}, 1 : i32) : !aie.objectfifo<memref<16xi32>> 
    aie.objectfifo @back(%tile_2_3, {%tile_3_4}, 1 : i32) : !aie.objectfifo<memref<16xi32>> 
    %core_1_1 = aie.core(%tile_1_1) {
      %0 = aie.objectfifo.acquire @out(Produce, 1) : !aie.objectfifosubview<memref<16xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<16xi32>> -> memref<16xi32>
      %c2 = arith.constant 2 : index
      %c5_i32 = arith.constant 5 : i32
      memref.store %c5_i32, %1[%c2] : memref<16xi32>
      aie.objectfifo.release @out(Produce, 1)
      aie.end
    }
    %core_2_3 = aie.core(%tile_2_3) {
      %0 = aie.objectfifo.acquire @out(Consume, 1) : !aie.objectfifosubview<memref<16xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<16xi32>> -> memref<16xi32>
      %2 = aie.objectfifo.acquire @back(Produce, 1) : !aie.objectfifosubview<memref<16xi32>>
      %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<16xi32>> -> memref<16xi32>
      %c16_i32 = arith.constant 16 : i32
      func.call @passThroughLine(%3, %1, %c16_i32) : (memref<16xi32>, memref<16xi32>, i32) -> ()
      aie.objectfifo.release @out(Consume, 1)
      aie.objectfifo.release @back(Produce, 1)
      aie.end
    } {link_with = "passThrough.cc.o"}
    %core_3_4 = aie.core(%tile_3_4) {
      %0 = aie.objectfifo.acquire @back(Consume, 1) : !aie.objectfifosubview<memref<16xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<16xi32>> -> memref<16xi32>
      %c5 = arith.constant 5 : index
      %c9_i32 = arith.constant 9 : i32
      memref.store %c9_i32, %1[%c5] : memref<16xi32>
      aie.objectfifo.release @back(Consume, 1)
      aie.end
    }
  }
}
