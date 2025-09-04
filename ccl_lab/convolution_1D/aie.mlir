module {
  aie.device(xcvc1902) {
    %tile_2_2 = aie.tile(2, 2)
    %buff1 = aie.buffer(%tile_2_2) {sym_name = "buff1"} : memref<5xi32> 
    %buff2 = aie.buffer(%tile_2_2) {sym_name = "buff2"} : memref<2xi32> 
    %buff_out = aie.buffer(%tile_2_2) {sym_name = "buff_out"} : memref<4xi32> 
    %lock1 = aie.lock(%tile_2_2, 1) {sym_name = "lock1"}
    %core_2_2 = aie.core(%tile_2_2) {
      aie.use_lock(%lock1, "Acquire", 0)
      %c0 = arith.constant 0 : index
      %0 = memref.load %buff2[%c0] : memref<2xi32>
      %c0_0 = arith.constant 0 : index
      %1 = memref.load %buff1[%c0_0] : memref<5xi32>
      %2 = arith.muli %0, %1 : i32
      %c1 = arith.constant 1 : index
      %3 = memref.load %buff2[%c1] : memref<2xi32>
      %c1_1 = arith.constant 1 : index
      %4 = memref.load %buff1[%c1_1] : memref<5xi32>
      %5 = arith.muli %3, %4 : i32
      %6 = arith.addi %2, %5 : i32
      %c0_2 = arith.constant 0 : index
      memref.store %6, %buff_out[%c0_2] : memref<4xi32>
      %c0_3 = arith.constant 0 : index
      %7 = memref.load %buff2[%c0_3] : memref<2xi32>
      %c1_4 = arith.constant 1 : index
      %8 = memref.load %buff1[%c1_4] : memref<5xi32>
      %9 = arith.muli %7, %8 : i32
      %c1_5 = arith.constant 1 : index
      %10 = memref.load %buff2[%c1_5] : memref<2xi32>
      %c2 = arith.constant 2 : index
      %11 = memref.load %buff1[%c2] : memref<5xi32>
      %12 = arith.muli %10, %11 : i32
      %13 = arith.addi %9, %12 : i32
      %c1_6 = arith.constant 1 : index
      memref.store %13, %buff_out[%c1_6] : memref<4xi32>
      %c0_7 = arith.constant 0 : index
      %14 = memref.load %buff2[%c0_7] : memref<2xi32>
      %c2_8 = arith.constant 2 : index
      %15 = memref.load %buff1[%c2_8] : memref<5xi32>
      %16 = arith.muli %14, %15 : i32
      %c1_9 = arith.constant 1 : index
      %17 = memref.load %buff2[%c1_9] : memref<2xi32>
      %c3 = arith.constant 3 : index
      %18 = memref.load %buff1[%c3] : memref<5xi32>
      %19 = arith.muli %17, %18 : i32
      %20 = arith.addi %16, %19 : i32
      %c2_10 = arith.constant 2 : index
      memref.store %20, %buff_out[%c2_10] : memref<4xi32>
      %c0_11 = arith.constant 0 : index
      %21 = memref.load %buff2[%c0_11] : memref<2xi32>
      %c3_12 = arith.constant 3 : index
      %22 = memref.load %buff1[%c3_12] : memref<5xi32>
      %23 = arith.muli %21, %22 : i32
      %c1_13 = arith.constant 1 : index
      %24 = memref.load %buff2[%c1_13] : memref<2xi32>
      %c4 = arith.constant 4 : index
      %25 = memref.load %buff1[%c4] : memref<5xi32>
      %26 = arith.muli %24, %25 : i32
      %27 = arith.addi %23, %26 : i32
      %c3_14 = arith.constant 3 : index
      memref.store %27, %buff_out[%c3_14] : memref<4xi32>
      aie.use_lock(%lock1, "Release", 1)
      aie.end
    }
  }
}

