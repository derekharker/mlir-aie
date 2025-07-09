module {
  aie.device(xcvc1902) {
    %shim_noc_tile_3_0 = aie.tile(3, 0)
    %tile_0_2 = aie.tile(0, 2)
    aie.objectfifo @in(%shim_noc_tile_3_0, {%tile_0_2}, 2 : i32) : !aie.objectfifo<memref<64xi32>> 
    aie.objectfifo @factor(%shim_noc_tile_3_0, {%tile_0_2}, 2 : i32) : !aie.objectfifo<memref<1xi32>> 
    aie.objectfifo @out(%tile_0_2, {%shim_noc_tile_3_0}, 2 : i32) : !aie.objectfifo<memref<64xi32>> 
    %core_0_2 = aie.core(%tile_0_2) {
      %0 = aie.objectfifo.acquire @factor(Consume, 1) : !aie.objectfifosubview<memref<1xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<1xi32>> -> memref<1xi32>
      %2 = aie.objectfifo.acquire @in(Consume, 1) : !aie.objectfifosubview<memref<64xi32>>
      %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64xi32>> -> memref<64xi32>
      aie.objectfifo.release @in(Consume, 1)
      aie.objectfifo.release @factor(Consume, 1)
      %4 = aie.objectfifo.acquire @out(Produce, 1) : !aie.objectfifosubview<memref<64xi32>>
      %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64xi32>> -> memref<64xi32>
      %c0 = arith.constant 0 : index
      %c64 = arith.constant 64 : index
      %c1 = arith.constant 1 : index
      scf.for %arg0 = %c0 to %c64 step %c1 {
        %6 = memref.load %3[%arg0] : memref<64xi32>
        %c0_0 = arith.constant 0 : index
        %7 = memref.load %1[%c0_0] : memref<1xi32>
        %8 = arith.muli %6, %7 : i32
        memref.store %8, %5[%arg0] : memref<64xi32>
      }
      aie.objectfifo.release @out(Produce, 1)
      aie.end
    }
  }
}

