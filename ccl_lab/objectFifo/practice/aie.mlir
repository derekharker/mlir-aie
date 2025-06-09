module @practice {
    aie.device(xcvc1902) {
        %tile13 = aie.tile(1, 3)
        %tile54 = aie.tile(5, 4)

        aie.objectfifo @of (%tile13)
    }
}