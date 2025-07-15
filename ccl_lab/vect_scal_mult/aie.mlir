module {
  aie.device(xcvc1902) {
    func.func private @vector_scalar_mul_aie_scalar(memref<64xi32>, memref<64xi32>, i32, i32)
    %tile_3_3 = aie.tile(3, 3)
    %A = aie.buffer(%tile_3_3) {sym_name = "A"} : memref<64xi32> 
    %B = aie.buffer(%tile_3_3) {sym_name = "B"} : memref<64xi32> 
    %lock_3_3 = aie.lock(%tile_3_3, 1) {sym_name = "lock"}
    %core_3_3 = aie.core(%tile_3_3) {
      aie.use_lock(%lock_3_3, "Acquire", 0)
      %c20_i32 = arith.constant 20 : i32
      %c64_i32 = arith.constant 64 : i32
      func.call @vector_scalar_mul_aie_scalar(%A, %B, %c20_i32, %c64_i32) : (memref<64xi32>, memref<64xi32>, i32, i32) -> ()
      aie.use_lock(%lock_3_3, "Release", 1)
      aie.end
    } {link_with = "vect_scale_mult.o"}
  }
}

