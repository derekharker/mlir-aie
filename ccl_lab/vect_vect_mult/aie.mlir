module {
  aie.device(xcvc1902) {
    %tile_1_1 = aie.tile(1, 1)
    %tile_2_3 = aie.tile(2, 3)
    %tile_3_4 = aie.tile(3, 4)
    aie.objectfifo @in1(%tile_1_1, {%tile_2_3}, 1 : i32) : !aie.objectfifo<memref<64xi32>> 
    aie.objectfifo @in2(%tile_1_1, {%tile_2_3}, 1 : i32) : !aie.objectfifo<memref<64xi32>> 
    aie.objectfifo @out(%tile_2_3, {%tile_3_4}, 1 : i32) : !aie.objectfifo<memref<64xi32>> 
    %core_1_1 = aie.core(%tile_1_1) {
      %0 = aie.objectfifo.acquire @in1(Produce, 1) : !aie.objectfifosubview<memref<64xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64xi32>> -> memref<64xi32>
      %c2 = arith.constant 2 : index
      %c5_i32 = arith.constant 5 : i32
      memref.store %c5_i32, %1[%c2] : memref<64xi32>
      aie.objectfifo.release @in1(Produce, 1)
      aie.end
    }
    %core_2_3 = aie.core(%tile_2_3) {
      %0 = aie.objectfifo.acquire @in1(Consume, 1) : !aie.objectfifosubview<memref<64xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64xi32>> -> memref<64xi32>
      %2 = aie.objectfifo.acquire @in2(Consume, 1) : !aie.objectfifosubview<memref<64xi32>>
      %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<64xi32>> -> memref<64xi32>
      %4 = aie.objectfifo.acquire @out(Produce, 1) : !aie.objectfifosubview<memref<64xi32>>
      %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<64xi32>> -> memref<64xi32>
      %c1 = arith.constant 1 : index
      %c4_i32 = arith.constant 4 : i32
      memref.store %c4_i32, %1[%c1] : memref<64xi32>
      %c0 = arith.constant 0 : index
      %c10 = arith.constant 10 : index
      %c1_0 = arith.constant 1 : index
      scf.for %arg0 = %c0 to %c10 step %c1_0 {
        %6 = memref.load %1[%arg0] : memref<64xi32>
        %7 = memref.load %3[%arg0] : memref<64xi32>
        %8 = arith.muli %6, %7 : i32
        memref.store %8, %5[%arg0] : memref<64xi32>
      }
      %c6 = arith.constant 6 : index
      %c3_i32 = arith.constant 3 : i32
      memref.store %c3_i32, %5[%c6] : memref<64xi32>
      aie.objectfifo.release @in1(Consume, 1)
      aie.objectfifo.release @in2(Consume, 1)
      aie.objectfifo.release @out(Produce, 1)
      aie.end
    }
    %core_3_4 = aie.core(%tile_3_4) {
      %0 = aie.objectfifo.acquire @out(Consume, 1) : !aie.objectfifosubview<memref<64xi32>>
      %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<64xi32>> -> memref<64xi32>
      %c3 = arith.constant 3 : index
      %c1_i32 = arith.constant 1 : i32
      memref.store %c1_i32, %1[%c3] : memref<64xi32>
      aie.objectfifo.release @out(Consume, 1)
      aie.end
    }
  }
}

