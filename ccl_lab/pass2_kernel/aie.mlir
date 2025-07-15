module {
  aie.device(xcvc1902) {
    %tile_1_4 = aie.tile(1, 4)
    %tile_1_5 = aie.tile(1, 5)
    %A = aie.buffer(%tile_1_4) {sym_name = "A"} : memref<4x8xi32> 
    %B = aie.buffer(%tile_1_5) {sym_name = "B"} : memref<4x8xi32> 
    %lock_1_4 = aie.lock(%tile_1_4, 1) {sym_name = "lock"}
    func.func private @passThroughLine(memref<4x8xi32>, memref<4x8xi32>, i32, i32)
    %core_1_4 = aie.core(%tile_1_4) {
      aie.use_lock(%lock_1_4, "Acquire", 0)
      %c1_i32 = arith.constant 1 : i32
      %c1024_i32 = arith.constant 1024 : i32
      func.call @passThroughLine(%A, %B, %c1_i32, %c1024_i32) : (memref<4x8xi32>, memref<4x8xi32>, i32, i32) -> ()
      aie.use_lock(%lock_1_4, "Release", 1)
      aie.end
    } {link_with = "passThrough.o"}
  }
}

