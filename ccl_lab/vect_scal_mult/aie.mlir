module {
  aie.device(xcvc1902) {
    func.func private @vector_scalar_mul_aie_scalar(memref<64xi32>, memref<64xi32>, i32, i32)
    %tile_3_3 = aie.tile(3, 3)
    %tile_0_2 = aie.tile(0, 2)
    aie.objectfifo @in(%tile_3_3, {%tile_0_2}, 2 : i32) : !aie.objectfifo<memref<64xi32>> 
    aie.objectfifo @out(%tile_0_2, {%tile_3_3}, 2 : i32) : !aie.objectfifo<memref<64xi32>> 
    %core_0_2 = aie.core(%tile_0_2) {
      %0 = aie.objectfifo.acquire @in(Consume, 1) : !aie.objectfifosubview<memref<64xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64xi32>> -> memref<64xi32>
      %2 = aie.objectfifo.acquire @out(Produce, 1) : !aie.objectfifosubview<memref<64xi32>>
      %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64xi32>> -> memref<64xi32>
      %c20_i32 = arith.constant 20 : i32
      %c64_i32 = arith.constant 64 : i32
      func.call @vector_scalar_mul_aie_scalar(%1, %3, %c20_i32, %c64_i32) : (memref<64xi32>, memref<64xi32>, i32, i32) -> ()
      aie.objectfifo.release @in(Consume, 1)
      aie.objectfifo.release @out(Produce, 1)
      aie.end
    } {link_with = "vect_scale_mult.o"}
  }
}

