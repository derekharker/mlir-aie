module {
  aie.device(xcvc1902) {
    %tile_2_2 = aie.tile(2, 2)
    %buff1 = aie.buffer(%tile_2_2) {sym_name = "buff1"} : memref<4x4xi32> 
    %buff2 = aie.buffer(%tile_2_2) {sym_name = "buff2"} : memref<2x2xi32> 
    %buff_out = aie.buffer(%tile_2_2) {sym_name = "buff_out"} : memref<3x3xi32> 
    %lock1 = aie.lock(%tile_2_2, 1) {sym_name = "lock1"}
    %core_2_2 = aie.core(%tile_2_2) {
      aie.use_lock(%lock1, "Acquire", 0)
      %c0 = arith.constant 0 : index
      %c3 = arith.constant 3 : index
      %c1 = arith.constant 1 : index
      scf.for %arg0 = %c0 to %c3 step %c1 {
        %c0_0 = arith.constant 0 : index
        %c3_1 = arith.constant 3 : index
        %c1_2 = arith.constant 1 : index
        scf.for %arg1 = %c0_0 to %c3_1 step %c1_2 {
          %c0_3 = arith.constant 0 : index
          %c0_4 = arith.constant 0 : index
          %0 = memref.load %buff2[%c0_3, %c0_4] : memref<2x2xi32>
          %1 = memref.load %buff1[%arg0, %arg1] : memref<4x4xi32>
          %2 = arith.muli %0, %1 : i32
          %c0_5 = arith.constant 0 : index
          %c1_6 = arith.constant 1 : index
          %3 = memref.load %buff2[%c0_5, %c1_6] : memref<2x2xi32>
          %c1_7 = arith.constant 1 : index
          %4 = arith.addi %arg1, %c1_7 : index
          %5 = memref.load %buff1[%arg0, %4] : memref<4x4xi32>
          %6 = arith.muli %3, %5 : i32
          %7 = arith.addi %2, %6 : i32
          %c1_8 = arith.constant 1 : index
          %c0_9 = arith.constant 0 : index
          %8 = memref.load %buff2[%c1_8, %c0_9] : memref<2x2xi32>
          %c1_10 = arith.constant 1 : index
          %9 = arith.addi %arg0, %c1_10 : index
          %10 = memref.load %buff1[%9, %arg1] : memref<4x4xi32>
          %11 = arith.muli %8, %10 : i32
          %12 = arith.addi %7, %11 : i32
          %c1_11 = arith.constant 1 : index
          %c1_12 = arith.constant 1 : index
          %13 = memref.load %buff2[%c1_11, %c1_12] : memref<2x2xi32>
          %c1_13 = arith.constant 1 : index
          %14 = arith.addi %arg0, %c1_13 : index
          %c1_14 = arith.constant 1 : index
          %15 = arith.addi %arg1, %c1_14 : index
          %16 = memref.load %buff1[%14, %15] : memref<4x4xi32>
          %17 = arith.muli %13, %16 : i32
          %18 = arith.addi %12, %17 : i32
          memref.store %18, %buff_out[%arg0, %arg1] : memref<3x3xi32>
        }
      }
      aie.use_lock(%lock1, "Release", 1)
      aie.end
    }
  }
}

