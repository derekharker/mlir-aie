module {
  aie.device(xcvc1902) {
    %tile_1_4 = aie.tile(1, 4)
    %A = aie.buffer(%tile_1_4) {sym_name = "A"} : memref<4x2xi32> 
    %B = aie.buffer(%tile_1_4) {sym_name = "B"} : memref<2x4xi32> 
    %C = aie.buffer(%tile_1_4) {sym_name = "C"} : memref<4x4xi32> 
    %lock_1_4 = aie.lock(%tile_1_4, 1) {sym_name = "lock"}
    func.func private @gemm_kernel_top(memref<4x2xi32>, memref<2x4xi32>, memref<4x4xi32>)
    %core_1_4 = aie.core(%tile_1_4) {
      aie.use_lock(%lock_1_4, "Acquire", 0)
      func.call @gemm_kernel_top(%A, %B, %C) : (memref<4x2xi32>, memref<2x4xi32>, memref<4x4xi32>) -> ()
      aie.use_lock(%lock_1_4, "Release", 1)
      aie.end
    } {link_with = "gemm_kernel.o"}
  }
}

