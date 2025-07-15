module {
  aie.device(xcvc1902) {
    %tile_1_4 = aie.tile(1, 4)
    %A = aie.buffer(%tile_1_4) {sym_name = "A"} : memref<1024xi8> 
    %B = aie.buffer(%tile_1_4) {sym_name = "B"} : memref<1024xi8> 
    %C = aie.buffer(%tile_1_4) {sym_name = "C"} : memref<1024xi8> 
    %lock_1_4 = aie.lock(%tile_1_4, 1)
    func.func private @matmul_i16_i32(memref<1024xi8>, memref<1024xi8>, memref<1024xi8>)
    %core_1_4 = aie.core(%tile_1_4) {
      aie.use_lock(%lock_1_4, Acquire)
      func.call @matmul_i16_i32(%A, %B, %C) : (memref<1024xi8>, memref<1024xi8>, memref<1024xi8>) -> ()
      aie.use_lock(%lock_1_4, Release)
      aie.end
    } {link_with = "mm.o"}
  }
}

