module {
  aie.device(xcvc1902) {
    %tile_1_1 = aie.tile(1, 1)
    %tile_2_3 = aie.tile(2, 3)
    aie.objectfifo @out(%tile_1_1, {%tile_2_3}, 1 : i32) : !aie.objectfifo<memref<10xi32>> 
    aie.objectfifo @back(%tile_2_3, {%tile_1_1}, 1 : i32) : !aie.objectfifo<memref<10xi32>> 
    %core_1_1 = aie.core(%tile_1_1) {
      %0 = aie.objectfifo.acquire @out(Produce, 1) : !aie.objectfifosubview<memref<10xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<10xi32>> -> memref<10xi32>
      %2 = aie.objectfifo.acquire @back(Consume, 1) : !aie.objectfifosubview<memref<10xi32>>
      %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<10xi32>> -> memref<10xi32>
      %c2 = arith.constant 2 : index
      %c5_i32 = arith.constant 5 : i32
      memref.store %c5_i32, %1[%c2] : memref<10xi32>
      %c5 = arith.constant 5 : index
      %c9_i32 = arith.constant 9 : i32
      memref.store %c9_i32, %3[%c5] : memref<10xi32>
      aie.objectfifo.release @out(Produce, 1)
      aie.objectfifo.release @back(Consume, 1)
      aie.end
    }
    %core_2_3 = aie.core(%tile_2_3) {
      %0 = aie.objectfifo.acquire @out(Consume, 1) : !aie.objectfifosubview<memref<10xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<10xi32>> -> memref<10xi32>
      %2 = aie.objectfifo.acquire @back(Produce, 1) : !aie.objectfifosubview<memref<10xi32>>
      %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<10xi32>> -> memref<10xi32>
      %c1 = arith.constant 1 : index
      %c4_i32 = arith.constant 4 : i32
      memref.store %c4_i32, %1[%c1] : memref<10xi32>
      %c0 = arith.constant 0 : index
      %c10 = arith.constant 10 : index
      %c1_0 = arith.constant 1 : index
      scf.for %arg0 = %c0 to %c10 step %c1_0 {
        %4 = memref.load %1[%arg0] : memref<10xi32>
        memref.store %4, %3[%arg0] : memref<10xi32>
      }
      %c6 = arith.constant 6 : index
      %c3_i32 = arith.constant 3 : i32
      memref.store %c3_i32, %3[%c6] : memref<10xi32>
      aie.objectfifo.release @out(Consume, 1)
      aie.objectfifo.release @back(Produce, 1)
      aie.end
    }
  }
}

