module {
  aie.device(xcvc1902) {
    %tile_1_4 = aie.tile(1, 4)
    %a14 = aie.buffer(%tile_1_4) {sym_name = "a14"} : memref<256xi32> 
    %lock_1_4 = aie.lock(%tile_1_4, 1) {sym_name = "lock_1_4"}
    func.func private @extern_kernel(memref<256xi32>)
    %core_1_4 = aie.core(%tile_1_4) {
      aie.use_lock(%lock_1_4, "Acquire", 0)
      func.call @extern_kernel(%a14) : (memref<256xi32>) -> ()
      aie.use_lock(%lock_1_4, "Release", 1)
      aie.end
    } {link_with = "kernel.o"}
  }
}

