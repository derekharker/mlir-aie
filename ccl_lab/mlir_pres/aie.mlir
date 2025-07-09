module {
    aie.device(xcvc1902) {
        %src = aie.tile(1, 4)
        %dst = aie.tile(5, 8)

        %f = aie.objectFifo.createObjectFifo(%src, {%dst}, 2)

        aie.core(%src) {

        }
    }
}