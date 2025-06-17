module {
  aie.device(xcvc1902) {
    %tile_1_1 = aie.tile(1, 1)
    %tile_2_3 = aie.tile(2, 3)
    %tile_3_4 = aie.tile(3, 4)
    aie.objectfifo @in(%tile_1_1, {%tile_2_3}, 1 : i32) : !aie.objectfifo<memref<10xi32>> 
    aie.objectfifo @pass(%tile_2_3, {%tile_3_4}, 1 : i32) : !aie.objectfifo<memref<10xi32>> 
    %core_1_1 = aie.core(%tile_1_1) {
      %0 = aie.objectfifo.acquire @in(Produce, 1) : !aie.objectfifosubview<memref<10xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<10xi32>> -> memref<10xi32>
      %c2 = arith.constant 2 : index
      %c5_i32 = arith.constant 5 : i32
      memref.store %c5_i32, %1[%c2] : memref<10xi32>
      aie.objectfifo.release @in(Produce, 1)
      aie.end
    }
    %core_2_3 = aie.core(%tile_2_3) {
      %0 = aie.objectfifo.acquire @in(Consume, 1) : !aie.objectfifosubview<memref<10xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<10xi32>> -> memref<10xi32>
      %2 = aie.objectfifo.acquire @pass(Produce, 1) : !aie.objectfifosubview<memref<10xi32>>
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
      aie.objectfifo.release @in(Consume, 1)
      aie.objectfifo.release @pass(Produce, 1)
      aie.end
    }
    %core_3_4 = aie.core(%tile_3_4) {
      %0 = aie.objectfifo.acquire @pass(Consume, 1) : !aie.objectfifosubview<memref<10xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<10xi32>> -> memref<10xi32>
      %c3 = arith.constant 3 : index
      %c1_i32 = arith.constant 1 : i32
      memref.store %c1_i32, %1[%c3] : memref<10xi32>
      aie.objectfifo.release @pass(Consume, 1)
      aie.end
    }
  }
}

