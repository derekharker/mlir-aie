module {
  aie.device(xcvc1902) {
    %shim_pl_tile_0_0 = aie.tile(0, 0)
    %tile_0_1 = aie.tile(0, 1)
    %tile_0_2 = aie.tile(0, 2)
    aie.objectfifo @in(%shim_pl_tile_0_0, {%tile_0_1}, 2 : i32) : !aie.objectfifo<memref<48xi32>> 
    aie.objectfifo @in1(%tile_0_1, {%tile_0_2}, 2 : i32) : !aie.objectfifo<memref<48xi32>> 
    aie.objectfifo.link [@in] -> [@in1]([] [])
    aie.objectfifo @out(%tile_0_1, {%shim_pl_tile_0_0}, 2 : i32) : !aie.objectfifo<memref<48xi32>> 
    aie.objectfifo @out1(%tile_0_2, {%tile_0_1}, 2 : i32) : !aie.objectfifo<memref<48xi32>> 
    aie.objectfifo.link [@out1] -> [@out]([] [])
    %core_0_2 = aie.core(%tile_0_2) {
      %c0 = arith.constant 0 : index
      %c4294967295 = arith.constant 4294967295 : index
      %c1 = arith.constant 1 : index
      scf.for %arg0 = %c0 to %c4294967295 step %c1 {
        %0 = aie.objectfifo.acquire @in1(Consume, 1) : !aie.objectfifosubview<memref<48xi32>>
        %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<48xi32>> -> memref<48xi32>
        %2 = aie.objectfifo.acquire @out1(Produce, 1) : !aie.objectfifosubview<memref<48xi32>>
        %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<48xi32>> -> memref<48xi32>
        %c0_0 = arith.constant 0 : index
        %c48 = arith.constant 48 : index
        %c1_1 = arith.constant 1 : index
        scf.for %arg1 = %c0_0 to %c48 step %c1_1 {
          %4 = memref.load %1[%arg1] : memref<48xi32>
          %c1_i32 = arith.constant 1 : i32
          %5 = arith.addi %4, %c1_i32 : i32
          memref.store %5, %3[%arg1] : memref<48xi32>
        }
        aie.objectfifo.release @in1(Consume, 1)
        aie.objectfifo.release @out1(Produce, 1)
      }
      aie.end
    }
  }
}

