module {
  aie.device(xcvc1902) {
    %tile_1_3 = aie.tile(1, 3)
    %local = aie.buffer(%tile_1_3) {sym_name = "local"} : memref<48xi32> 
    %core_1_3 = aie.core(%tile_1_3) {
      %c0 = arith.constant 0 : index
      %c48 = arith.constant 48 : index
      %c1 = arith.constant 1 : index
      scf.for %arg0 = %c0 to %c48 step %c1 {
        %c0_i32 = arith.constant 0 : i32
        memref.store %c0_i32, %local[%arg0] : memref<48xi32>
      }
      aie.end
    }
  }
}

