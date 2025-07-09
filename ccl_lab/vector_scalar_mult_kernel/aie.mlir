module {
  aie.device(xcvc1902) {
    %tile_1_3 = aie.tile(1, 3)
    aie.objectfifo @in(%tile_1_3, {%tile_1_3}, 1 : i32) : !aie.objectfifo<memref<1024xi32>> 
    aie.objectfifo @infactor(%tile_1_3, {%tile_1_3}, 1 : i32) : !aie.objectfifo<memref<1xi32>> 
    aie.objectfifo @out(%tile_1_3, {%tile_1_3}, 1 : i32) : !aie.objectfifo<memref<1024xi32>> 
    %core_1_3 = aie.core(%tile_1_3) {
      %0 = aie.objectfifo.acquire @infactor(Produce, 1) : !aie.objectfifosubview<memref<1xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<1xi32>> -> memref<1xi32>
      %c0 = arith.constant 0 : index
      %c4 = arith.constant 4 : index
      %c1 = arith.constant 1 : index
      scf.for %arg0 = %c0 to %c4 step %c1 {
        %2 = aie.objectfifo.acquire @in(Produce, 1) : !aie.objectfifosubview<memref<1024xi32>>
        %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<1024xi32>> -> memref<1024xi32>
        %4 = aie.objectfifo.acquire @out(Produce, 1) : !aie.objectfifosubview<memref<1024xi32>>
        %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<1024xi32>> -> memref<1024xi32>
        aie.objectfifo.release @in(Produce, 1)
        aie.objectfifo.release @out(Produce, 1)
      }
      aie.objectfifo.release @infactor(Produce, 1)
      aie.end
    }
  }
}

