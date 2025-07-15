module {
  aie.device(xcvc1902) {
    func.func private @zero_i32(memref<32x32xi32>)
    func.func private @matmul_i8_i32(memref<32x32xi8>, memref<32x32xi8>, memref<32x32xi32>)
    %shim_noc_tile_0_0 = aie.tile(0, 0)
    %mem_tile_0_1 = aie.tile(0, 1)
    %tile_0_2 = aie.tile(0, 2)
    aie.objectfifo @inA(%shim_noc_tile_0_0, {%mem_tile_0_1}, 2 : i32) : !aie.objectfifo<memref<32x32xi8>> 
    aie.objectfifo @memA(%mem_tile_0_1 dimensionsToStream [<size = 4, stride = 256>, <size = 4, stride = 8>, <size = 8, stride = 32>, <size = 8, stride = 1>], {%tile_0_2}, 2 : i32) : !aie.objectfifo<memref<32x32xi8>> 
    aie.objectfifo.link [@inA] -> [@memA]([] [])
    aie.objectfifo @inB(%shim_noc_tile_0_0, {%mem_tile_0_1}, 2 : i32) : !aie.objectfifo<memref<32x32xi8>> 
    aie.objectfifo @memB(%mem_tile_0_1 dimensionsToStream [<size = 4, stride = 256>, <size = 4, stride = 8>, <size = 8, stride = 32>, <size = 8, stride = 1>], {%tile_0_2}, 2 : i32) : !aie.objectfifo<memref<32x32xi8>> 
    aie.objectfifo.link [@inB] -> [@memB]([] [])
    aie.objectfifo @memC(%tile_0_2, {%mem_tile_0_1}, 2 : i32) : !aie.objectfifo<memref<32x32xi32>> 
    aie.objectfifo @outC(%mem_tile_0_1 dimensionsToStream [<size = 4, stride = 256>, <size = 8, stride = 8>, <size = 4, stride = 64>, <size = 8, stride = 1>], {%shim_noc_tile_0_0}, 2 : i32) : !aie.objectfifo<memref<32x32xi32>> 
    aie.objectfifo.link [@memC] -> [@outC]([] [])
    %core_0_2 = aie.core(%tile_0_2) {
      %c0 = arith.constant 0 : index
      %c4294967295 = arith.constant 4294967295 : index
      %c1 = arith.constant 1 : index
      scf.for %arg0 = %c0 to %c4294967295 step %c1 {
        %c0_0 = arith.constant 0 : index
        %c256 = arith.constant 256 : index
        %c1_1 = arith.constant 1 : index
        scf.for %arg1 = %c0_0 to %c256 step %c1_1 {
          %0 = aie.objectfifo.acquire @memC(Produce, 1) : !aie.objectfifosubview<memref<32x32xi32>>
          %1 = aie.objectfifo.subview.access %0[0] : !aie.objectfifosubview<memref<32x32xi32>> -> memref<32x32xi32>
          func.call @zero_i32(%1) : (memref<32x32xi32>) -> ()
          %c0_2 = arith.constant 0 : index
          %c16 = arith.constant 16 : index
          %c1_3 = arith.constant 1 : index
          scf.for %arg2 = %c0_2 to %c16 step %c1_3 {
            %2 = aie.objectfifo.acquire @memA(Consume, 1) : !aie.objectfifosubview<memref<32x32xi8>>
            %3 = aie.objectfifo.subview.access %2[0] : !aie.objectfifosubview<memref<32x32xi8>> -> memref<32x32xi8>
            %4 = aie.objectfifo.acquire @memB(Consume, 1) : !aie.objectfifosubview<memref<32x32xi8>>
            %5 = aie.objectfifo.subview.access %4[0] : !aie.objectfifosubview<memref<32x32xi8>> -> memref<32x32xi8>
            func.call @matmul_i8_i32(%3, %5, %1) : (memref<32x32xi8>, memref<32x32xi8>, memref<32x32xi32>) -> ()
            aie.objectfifo.release @memA(Consume, 1)
            aie.objectfifo.release @memB(Consume, 1)
          }
          aie.objectfifo.release @memC(Produce, 1)
        }
      }
      aie.end
    } {link_with = "mm_32x32x32.o", stack_size = 3328 : i32}
    aiex.runtime_sequence @sequence(%arg0: memref<262144xi8>, %arg1: memref<262144xi8>, %arg2: memref<262144xi32>) {
      %0 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 0, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%0)
      %1 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 0, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%1)
      %2 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%2)
      %3 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 16384, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%3)
      %4 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 16384, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%4)
      %5 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%5)
      aiex.dma_await_task(%0)
      aiex.dma_free_task(%1)
      aiex.dma_free_task(%2)
      %6 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 32768, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%6)
      %7 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 32768, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%7)
      %8 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%8)
      aiex.dma_await_task(%3)
      aiex.dma_free_task(%4)
      aiex.dma_free_task(%5)
      %9 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 49152, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%9)
      %10 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 49152, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%10)
      %11 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%11)
      aiex.dma_await_task(%6)
      aiex.dma_free_task(%7)
      aiex.dma_free_task(%8)
      %12 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 65536, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%12)
      %13 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 65536, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%13)
      %14 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%14)
      aiex.dma_await_task(%9)
      aiex.dma_free_task(%10)
      aiex.dma_free_task(%11)
      %15 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 81920, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%15)
      %16 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 81920, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%16)
      %17 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%17)
      aiex.dma_await_task(%12)
      aiex.dma_free_task(%13)
      aiex.dma_free_task(%14)
      %18 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 98304, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%18)
      %19 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 98304, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%19)
      %20 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%20)
      aiex.dma_await_task(%15)
      aiex.dma_free_task(%16)
      aiex.dma_free_task(%17)
      %21 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 114688, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%21)
      %22 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 114688, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%22)
      %23 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%23)
      aiex.dma_await_task(%18)
      aiex.dma_free_task(%19)
      aiex.dma_free_task(%20)
      %24 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 131072, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%24)
      %25 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 131072, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%25)
      %26 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%26)
      aiex.dma_await_task(%21)
      aiex.dma_free_task(%22)
      aiex.dma_free_task(%23)
      %27 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 147456, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%27)
      %28 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 147456, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%28)
      %29 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%29)
      aiex.dma_await_task(%24)
      aiex.dma_free_task(%25)
      aiex.dma_free_task(%26)
      %30 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 163840, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%30)
      %31 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 163840, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%31)
      %32 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%32)
      aiex.dma_await_task(%27)
      aiex.dma_free_task(%28)
      aiex.dma_free_task(%29)
      %33 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 180224, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%33)
      %34 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 180224, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%34)
      %35 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%35)
      aiex.dma_await_task(%30)
      aiex.dma_free_task(%31)
      aiex.dma_free_task(%32)
      %36 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 196608, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%36)
      %37 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 196608, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%37)
      %38 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%38)
      aiex.dma_await_task(%33)
      aiex.dma_free_task(%34)
      aiex.dma_free_task(%35)
      %39 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 212992, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%39)
      %40 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 212992, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%40)
      %41 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%41)
      aiex.dma_await_task(%36)
      aiex.dma_free_task(%37)
      aiex.dma_free_task(%38)
      %42 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 229376, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%42)
      %43 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 229376, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%43)
      %44 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%44)
      aiex.dma_await_task(%39)
      aiex.dma_free_task(%40)
      aiex.dma_free_task(%41)
      %45 = aiex.dma_configure_task_for @outC {
        aie.dma_bd(%arg2 : memref<262144xi32>, 245760, 16384, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {issue_token = true}
      aiex.dma_start_task(%45)
      %46 = aiex.dma_configure_task_for @inA {
        aie.dma_bd(%arg0 : memref<262144xi8>, 245760, 16384, [<size = 16, stride = 0>, <size = 16, stride = 32>, <size = 32, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      } {repeat_count = 15 : i32}
      aiex.dma_start_task(%46)
      %47 = aiex.dma_configure_task_for @inB {
        aie.dma_bd(%arg1 : memref<262144xi8>, 0, 262144, [<size = 1, stride = 0>, <size = 16, stride = 32>, <size = 512, stride = 512>, <size = 32, stride = 1>]) {burst_length = 0 : i32}
        aie.end
      }
      aiex.dma_start_task(%47)
      aiex.dma_await_task(%42)
      aiex.dma_free_task(%43)
      aiex.dma_free_task(%44)
      aiex.dma_await_task(%45)
      aiex.npu.write32 {address = 213064 : ui32, column = 0 : i32, row = 0 : i32, value = 126 : ui32}
      aiex.npu.write32 {address = 213000 : ui32, column = 0 : i32, row = 0 : i32, value = 126 : ui32}
    }
  }
}

