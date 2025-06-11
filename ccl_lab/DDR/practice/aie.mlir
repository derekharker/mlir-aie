module @practice {
    aie.device(xcvc1902) {
        %tile15 = aie.tile(1, 5)
        %shimtile = aie.tile(6, 0)

        %ext_buf70_in  = aie.external_buffer {sym_name = "ddr_test_buffer_in"}: memref<256xi32>


    }
}