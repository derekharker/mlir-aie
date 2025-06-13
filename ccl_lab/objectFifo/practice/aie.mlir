module @practice {
    aie.device(xcvc1902) {
        %tile13 = aie.tile(1, 3)
        %tile54 = aie.tile(49, 1)

        aie.objectfifo @of (%tile13, {%tile54}, 1 : i32) : !aie.objectfifo<memref<256xi32>>

        %core13 = aie.core(%tile13) {
            %inputSubview = aie.objectfifo.acquire @of (Produce, 2) : !aie.objectfifosubview<memref<256xi32>>

            %input = aie.objectfifo.subview.access %inputSubview[0] : !aie.objectfifosubview<memref<256xi32>> -> memref<256xi32>
            %input2 = aie.objectfifo.subview.access %inputSubview[1] : !aie.objectfifosubview<memref<256xi32>> -> memref<256xi32>
            
            %val = arith.constant 8 : i32
            %idx = arith.constant 5 : index
            memref.store %val, %input[%idx] : memref<256xi32>

            %val2 = arith.constant 6 : i32
            %idx2 = arith.constant 2 : index
            memref.store %val2, %input2[%idx2] : memref<256xi32>

            aie.objectfifo.release @of (Produce, 2)
            aie.end
        }

        %core54 = aie.core(%tile54) {
            %inputSubview = aie.objectfifo.acquire @of (Consume, 1) : !aie.objectfifosubview<memref<256xi32>>

            %input = aie.objectfifo.subview.access %inputSubview[0] : !aie.objectfifosubview<memref<256xi32>> -> memref<256xi32>

            %idx = arith.constant 5 : index
            %d1 = memref.load %input[%idx] : memref<256xi32>

            %c1 = arith.constant 11 : i32
            %d2 = arith.addi %d1, %c1 : i32

            memref.store %d2, %input[%idx] : memref<256xi32>

            aie.objectfifo.release @of (Consume, 1)
            aie.end
        }
    }
}