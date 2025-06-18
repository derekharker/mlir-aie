module {
  aie.device(xcvc1902) {
    func.func private @passThroughLine(memref<64xi32>, memref<64xi32>, i32)
    %shim_pl_tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    aie.objectfifo @in(%shim_pl_tile_0_0, {%tile_0_2}, 2 : i32) : !aie.objectfifo<memref<64xi32>> 
    aie.objectfifo @out(%tile_0_2, {%shim_pl_tile_0_0}, 2 : i32) : !aie.objectfifo<memref<64xi32>> 
    %core_0_2 = aie.core(%tile_0_2) {
      %c0 = arith.constant 0 : index
      %c9223372036854775807 = arith.constant 9223372036854775807 : index
      %c1 = arith.constant 1 : index
      scf.for %arg0 = %c0 to %c9223372036854775807 step %c1 {
        %0 = aie.objectfifo.acquire @out(Produce, 1) : !aie.objectfifosubview<memref<64xi32>>
        %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64xi32>> -> memref<64xi32>
        %2 = aie.objectfifo.acquire @in(Consume, 1) : !aie.objectfifosubview<memref<64xi32>>
        %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64xi32>> -> memref<64xi32>
        %c64_i32 = arith.constant 64 : i32
        func.call @passThroughLine(%3, %1, %c64_i32) : (memref<64xi32>, memref<64xi32>, i32) -> ()
        aie.objectfifo.release @in(Consume, 1)
        aie.objectfifo.release @out(Produce, 1)
      }
      aie.end
    } {link_with = "passThrough.cc.o"}
  }
}

