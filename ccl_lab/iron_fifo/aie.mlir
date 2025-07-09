module {
  aie.device(xcvc1902) {
    %tile_1_3 = aie.tile(1, 3)
    %tile_2_4 = aie.tile(2, 4)
    aie.objectfifo @in(%tile_1_3, {%tile_2_4}, 2 : i32) : !aie.objectfifo<memref<256xi32>> 
    %core_1_3 = aie.core(%tile_1_3) {
      %0 = aie.objectfifo.acquire @in(Produce, 1) : !aie.objectfifosubview<memref<256xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<256xi32>> -> memref<256xi32>
      %c0 = arith.constant 0 : index
      %c195 = arith.constant 195 : index
      %c1 = arith.constant 1 : index
      scf.for %arg0 = %c0 to %c195 step %c1 {
        %2 = memref.load %1[%arg0] : memref<256xi32>
        %c5_i32 = arith.constant 5 : i32
        %3 = arith.addi %2, %c5_i32 : i32
        memref.store %3, %1[%arg0] : memref<256xi32>
      }
      aie.objectfifo.release @in(Produce, 1)
      aie.end
    }
  }
}

