module {
  aie.device(xcvc1902) {
    func.func @passThroughLine(%arg0: memref<32xi32>, %arg1: memref<32xi32>, %arg2: i32) {
      %c0 = arith.constant 0 : index
      %c32 = arith.constant 32 : index
      %c1 = arith.constant 1 : index
      scf.for %arg3 = %c0 to %c32 step %c1 {
        %0 = memref.load %arg0[%arg3] : memref<32xi32>
        memref.store %0, %arg1[%arg3] : memref<32xi32>
      }
      return
    }
    %shim_noc_tile_3_0 = aie.tile(3, 0)
    %tile_3_3 = aie.tile(3, 3)
    aie.objectfifo @in(%shim_noc_tile_3_0, {%tile_3_3}, 2 : i32) : !aie.objectfifo<memref<32xi32>> 
    aie.objectfifo @out(%tile_3_3, {%shim_noc_tile_3_0}, 2 : i32) : !aie.objectfifo<memref<32xi32>> 
    %core_3_3 = aie.core(%tile_3_3) {
      %c0 = arith.constant 0 : index
      %c9223372036854775807 = arith.constant 9223372036854775807 : index
      %c1 = arith.constant 1 : index
      scf.for %arg0 = %c0 to %c9223372036854775807 step %c1 {
        %0 = aie.objectfifo.acquire @out(Produce, 1) : !aie.objectfifosubview<memref<32xi32>>
        %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<32xi32>> -> memref<32xi32>
        %2 = aie.objectfifo.acquire @in(Consume, 1) : !aie.objectfifosubview<memref<32xi32>>
        %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<32xi32>> -> memref<32xi32>
        %c0_0 = arith.constant 0 : index
        %c5_i32 = arith.constant 5 : i32
        memref.store %c5_i32, %1[%c0_0] : memref<32xi32>
        aie.objectfifo.release @in(Consume, 1)
        aie.objectfifo.release @out(Produce, 1)
      }
      aie.end
    }
  }
}

