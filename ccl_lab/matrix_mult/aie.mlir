"builtin.module"() ({
  "aie.device"() <{device = 1 : i32}> ({
    "func.func"() <{function_type = (memref<64x32xi32>) -> (), sym_name = "zero_i32", sym_visibility = "private"}> ({
    }) : () -> ()
    "func.func"() <{function_type = (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> (), sym_name = "matmul_i16_i32", sym_visibility = "private"}> ({
    }) : () -> ()
    %0 = "aie.tile"() <{col = 0 : i32, row = 0 : i32}> : () -> index
    %1 = "aie.tile"() <{col = 1 : i32, row = 0 : i32}> : () -> index
    %2 = "aie.tile"() <{col = 2 : i32, row = 0 : i32}> : () -> index
    %3 = "aie.tile"() <{col = 3 : i32, row = 0 : i32}> : () -> index
    %4 = "aie.tile"() <{col = 0 : i32, row = 1 : i32}> : () -> index
    %5 = "aie.tile"() <{col = 1 : i32, row = 1 : i32}> : () -> index
    %6 = "aie.tile"() <{col = 2 : i32, row = 1 : i32}> : () -> index
    %7 = "aie.tile"() <{col = 3 : i32, row = 1 : i32}> : () -> index
    %8 = "aie.tile"() <{col = 0 : i32, row = 2 : i32}> : () -> index
    %9 = "aie.tile"() <{col = 1 : i32, row = 2 : i32}> : () -> index
    %10 = "aie.tile"() <{col = 2 : i32, row = 2 : i32}> : () -> index
    %11 = "aie.tile"() <{col = 3 : i32, row = 2 : i32}> : () -> index
    %12 = "aie.tile"() <{col = 0 : i32, row = 3 : i32}> : () -> index
    %13 = "aie.tile"() <{col = 1 : i32, row = 3 : i32}> : () -> index
    %14 = "aie.tile"() <{col = 2 : i32, row = 3 : i32}> : () -> index
    %15 = "aie.tile"() <{col = 3 : i32, row = 3 : i32}> : () -> index
    %16 = "aie.tile"() <{col = 0 : i32, row = 4 : i32}> : () -> index
    %17 = "aie.tile"() <{col = 1 : i32, row = 4 : i32}> : () -> index
    %18 = "aie.tile"() <{col = 2 : i32, row = 4 : i32}> : () -> index
    %19 = "aie.tile"() <{col = 3 : i32, row = 4 : i32}> : () -> index
    %20 = "aie.tile"() <{col = 0 : i32, row = 5 : i32}> : () -> index
    %21 = "aie.tile"() <{col = 1 : i32, row = 5 : i32}> : () -> index
    %22 = "aie.tile"() <{col = 2 : i32, row = 5 : i32}> : () -> index
    %23 = "aie.tile"() <{col = 3 : i32, row = 5 : i32}> : () -> index
    "aie.objectfifo"(%0, %4) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x64xi16>>, plio = false, sym_name = "inA_0", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%1, %5) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x64xi16>>, plio = false, sym_name = "inA_1", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%2, %6) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x64xi16>>, plio = false, sym_name = "inA_2", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%3, %7) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x64xi16>>, plio = false, sym_name = "inA_3", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%0, %4) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi16>>, plio = false, sym_name = "inB_0", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%1, %5) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi16>>, plio = false, sym_name = "inB_1", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%2, %6) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi16>>, plio = false, sym_name = "inB_2", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%3, %7) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi16>>, plio = false, sym_name = "inB_3", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%4, %4) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "mergeC_0", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%5, %5) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "mergeC_1", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%6, %6) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "mergeC_2", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%7, %7) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "mergeC_3", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%4, %0) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[<size = 16, stride = 128>, <size = 4, stride = 4>, <size = 8, stride = 16>, <size = 4, stride = 1>]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "outC_0", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%5, %1) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[<size = 16, stride = 128>, <size = 4, stride = 4>, <size = 8, stride = 16>, <size = 4, stride = 1>]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "outC_1", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%6, %2) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[<size = 16, stride = 128>, <size = 4, stride = 4>, <size = 8, stride = 16>, <size = 4, stride = 1>]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "outC_2", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%7, %3) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[<size = 16, stride = 128>, <size = 4, stride = 4>, <size = 8, stride = 16>, <size = 4, stride = 1>]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "outC_3", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%4, %8, %12, %16, %20) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x64xi16>>, plio = false, sym_name = "memA_0", via_DMA = false}> : (index, index, index, index, index) -> ()
    "aie.objectfifo"(%5, %9, %13, %17, %21) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x64xi16>>, plio = false, sym_name = "memA_1", via_DMA = false}> : (index, index, index, index, index) -> ()
    "aie.objectfifo"(%6, %10, %14, %18, %22) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x64xi16>>, plio = false, sym_name = "memA_2", via_DMA = false}> : (index, index, index, index, index) -> ()
    "aie.objectfifo"(%7, %11, %15, %19, %23) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[<size = 16, stride = 256>, <size = 16, stride = 4>, <size = 4, stride = 64>, <size = 4, stride = 1>]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x64xi16>>, plio = false, sym_name = "memA_3", via_DMA = false}> : (index, index, index, index, index) -> ()
    "aie.objectfifo"(%4, %8, %12, %16, %20) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[<size = 16, stride = 128>, <size = 8, stride = 4>, <size = 4, stride = 32>, <size = 4, stride = 1>]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi16>>, plio = false, sym_name = "memB_0", via_DMA = false}> : (index, index, index, index, index) -> ()
    "aie.objectfifo"(%5, %9, %13, %17, %21) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[<size = 16, stride = 128>, <size = 8, stride = 4>, <size = 4, stride = 32>, <size = 4, stride = 1>]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi16>>, plio = false, sym_name = "memB_1", via_DMA = false}> : (index, index, index, index, index) -> ()
    "aie.objectfifo"(%6, %10, %14, %18, %22) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[<size = 16, stride = 128>, <size = 8, stride = 4>, <size = 4, stride = 32>, <size = 4, stride = 1>]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi16>>, plio = false, sym_name = "memB_2", via_DMA = false}> : (index, index, index, index, index) -> ()
    "aie.objectfifo"(%7, %11, %15, %19, %23) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[<size = 16, stride = 128>, <size = 8, stride = 4>, <size = 4, stride = 32>, <size = 4, stride = 1>]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi16>>, plio = false, sym_name = "memB_3", via_DMA = false}> : (index, index, index, index, index) -> ()
    "aie.objectfifo"(%8, %4) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_0_0", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%9, %5) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_0_1", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%10, %6) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_0_2", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%11, %7) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_0_3", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%12, %4) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_1_0", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%13, %5) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_1_1", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%14, %6) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_1_2", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%15, %7) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_1_3", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%16, %4) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_2_0", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%17, %5) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_2_1", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%18, %6) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_2_2", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%19, %7) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_2_3", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%20, %4) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_3_0", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%21, %5) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_3_1", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%22, %6) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_3_2", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo"(%23, %7) <{dimensionsFromStreamPerConsumer = #aie<bd_dim_layout_array_array[]>, dimensionsToStream = #aie<bd_dim_layout_array[]>, disable_synchronization = false, elemNumber = 2 : i32, elemType = !aie.objectfifo<memref<64x32xi32>>, plio = false, sym_name = "memC_3_3", via_DMA = false}> : (index, index) -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@inA_0], fifoOuts = [@memA_0], src_offsets = []}> : () -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@inB_0], fifoOuts = [@memB_0], src_offsets = []}> : () -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@memC_0_0, @memC_1_0, @memC_2_0, @memC_3_0], fifoOuts = [@mergeC_0], src_offsets = []}> : () -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@mergeC_0], fifoOuts = [@outC_0], src_offsets = []}> : () -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@inA_1], fifoOuts = [@memA_1], src_offsets = []}> : () -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@inB_1], fifoOuts = [@memB_1], src_offsets = []}> : () -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@memC_0_1, @memC_1_1, @memC_2_1, @memC_3_1], fifoOuts = [@mergeC_1], src_offsets = []}> : () -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@mergeC_1], fifoOuts = [@outC_1], src_offsets = []}> : () -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@inA_2], fifoOuts = [@memA_2], src_offsets = []}> : () -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@inB_2], fifoOuts = [@memB_2], src_offsets = []}> : () -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@memC_0_2, @memC_1_2, @memC_2_2, @memC_3_2], fifoOuts = [@mergeC_2], src_offsets = []}> : () -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@mergeC_2], fifoOuts = [@outC_2], src_offsets = []}> : () -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@inA_3], fifoOuts = [@memA_3], src_offsets = []}> : () -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@inB_3], fifoOuts = [@memB_3], src_offsets = []}> : () -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@memC_0_3, @memC_1_3, @memC_2_3, @memC_3_3], fifoOuts = [@mergeC_3], src_offsets = []}> : () -> ()
    "aie.objectfifo.link"() <{dst_offsets = [], fifoIns = [@mergeC_3], fifoOuts = [@outC_3], src_offsets = []}> : () -> ()
    %24 = "aie.core"(%8) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %232 = "arith.constant"() <{value = 0 : index}> : () -> index
      %233 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %234 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%232, %233, %234) ({
      ^bb0(%arg33: index):
        %235 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_0_0, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %236 = "aie.objectfifo.subview.access"(%235) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%236) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %237 = "arith.constant"() <{value = 0 : index}> : () -> index
        %238 = "arith.constant"() <{value = 8 : index}> : () -> index
        %239 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%237, %238, %239) ({
        ^bb0(%arg34: index):
          %240 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_0, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %241 = "aie.objectfifo.subview.access"(%240) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %242 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_0, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %243 = "aie.objectfifo.subview.access"(%242) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%241, %243, %236) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_0, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_0, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_0_0, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    %25 = "aie.core"(%9) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %220 = "arith.constant"() <{value = 0 : index}> : () -> index
      %221 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %222 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%220, %221, %222) ({
      ^bb0(%arg31: index):
        %223 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_0_1, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %224 = "aie.objectfifo.subview.access"(%223) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%224) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %225 = "arith.constant"() <{value = 0 : index}> : () -> index
        %226 = "arith.constant"() <{value = 8 : index}> : () -> index
        %227 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%225, %226, %227) ({
        ^bb0(%arg32: index):
          %228 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_1, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %229 = "aie.objectfifo.subview.access"(%228) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %230 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_1, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %231 = "aie.objectfifo.subview.access"(%230) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%229, %231, %224) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_1, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_1, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_0_1, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    %26 = "aie.core"(%10) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %208 = "arith.constant"() <{value = 0 : index}> : () -> index
      %209 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %210 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%208, %209, %210) ({
      ^bb0(%arg29: index):
        %211 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_0_2, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %212 = "aie.objectfifo.subview.access"(%211) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%212) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %213 = "arith.constant"() <{value = 0 : index}> : () -> index
        %214 = "arith.constant"() <{value = 8 : index}> : () -> index
        %215 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%213, %214, %215) ({
        ^bb0(%arg30: index):
          %216 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_2, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %217 = "aie.objectfifo.subview.access"(%216) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %218 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_2, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %219 = "aie.objectfifo.subview.access"(%218) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%217, %219, %212) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_2, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_2, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_0_2, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    %27 = "aie.core"(%11) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %196 = "arith.constant"() <{value = 0 : index}> : () -> index
      %197 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %198 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%196, %197, %198) ({
      ^bb0(%arg27: index):
        %199 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_0_3, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %200 = "aie.objectfifo.subview.access"(%199) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%200) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %201 = "arith.constant"() <{value = 0 : index}> : () -> index
        %202 = "arith.constant"() <{value = 8 : index}> : () -> index
        %203 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%201, %202, %203) ({
        ^bb0(%arg28: index):
          %204 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_3, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %205 = "aie.objectfifo.subview.access"(%204) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %206 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_3, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %207 = "aie.objectfifo.subview.access"(%206) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%205, %207, %200) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_3, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_3, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_0_3, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    %28 = "aie.core"(%12) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %184 = "arith.constant"() <{value = 0 : index}> : () -> index
      %185 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %186 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%184, %185, %186) ({
      ^bb0(%arg25: index):
        %187 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_1_0, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %188 = "aie.objectfifo.subview.access"(%187) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%188) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %189 = "arith.constant"() <{value = 0 : index}> : () -> index
        %190 = "arith.constant"() <{value = 8 : index}> : () -> index
        %191 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%189, %190, %191) ({
        ^bb0(%arg26: index):
          %192 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_0, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %193 = "aie.objectfifo.subview.access"(%192) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %194 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_0, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %195 = "aie.objectfifo.subview.access"(%194) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%193, %195, %188) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_0, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_0, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_1_0, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    %29 = "aie.core"(%13) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %172 = "arith.constant"() <{value = 0 : index}> : () -> index
      %173 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %174 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%172, %173, %174) ({
      ^bb0(%arg23: index):
        %175 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_1_1, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %176 = "aie.objectfifo.subview.access"(%175) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%176) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %177 = "arith.constant"() <{value = 0 : index}> : () -> index
        %178 = "arith.constant"() <{value = 8 : index}> : () -> index
        %179 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%177, %178, %179) ({
        ^bb0(%arg24: index):
          %180 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_1, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %181 = "aie.objectfifo.subview.access"(%180) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %182 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_1, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %183 = "aie.objectfifo.subview.access"(%182) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%181, %183, %176) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_1, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_1, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_1_1, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    %30 = "aie.core"(%14) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %160 = "arith.constant"() <{value = 0 : index}> : () -> index
      %161 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %162 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%160, %161, %162) ({
      ^bb0(%arg21: index):
        %163 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_1_2, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %164 = "aie.objectfifo.subview.access"(%163) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%164) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %165 = "arith.constant"() <{value = 0 : index}> : () -> index
        %166 = "arith.constant"() <{value = 8 : index}> : () -> index
        %167 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%165, %166, %167) ({
        ^bb0(%arg22: index):
          %168 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_2, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %169 = "aie.objectfifo.subview.access"(%168) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %170 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_2, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %171 = "aie.objectfifo.subview.access"(%170) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%169, %171, %164) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_2, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_2, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_1_2, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    %31 = "aie.core"(%15) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %148 = "arith.constant"() <{value = 0 : index}> : () -> index
      %149 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %150 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%148, %149, %150) ({
      ^bb0(%arg19: index):
        %151 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_1_3, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %152 = "aie.objectfifo.subview.access"(%151) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%152) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %153 = "arith.constant"() <{value = 0 : index}> : () -> index
        %154 = "arith.constant"() <{value = 8 : index}> : () -> index
        %155 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%153, %154, %155) ({
        ^bb0(%arg20: index):
          %156 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_3, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %157 = "aie.objectfifo.subview.access"(%156) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %158 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_3, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %159 = "aie.objectfifo.subview.access"(%158) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%157, %159, %152) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_3, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_3, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_1_3, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    %32 = "aie.core"(%16) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %136 = "arith.constant"() <{value = 0 : index}> : () -> index
      %137 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %138 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%136, %137, %138) ({
      ^bb0(%arg17: index):
        %139 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_2_0, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %140 = "aie.objectfifo.subview.access"(%139) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%140) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %141 = "arith.constant"() <{value = 0 : index}> : () -> index
        %142 = "arith.constant"() <{value = 8 : index}> : () -> index
        %143 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%141, %142, %143) ({
        ^bb0(%arg18: index):
          %144 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_0, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %145 = "aie.objectfifo.subview.access"(%144) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %146 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_0, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %147 = "aie.objectfifo.subview.access"(%146) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%145, %147, %140) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_0, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_0, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_2_0, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    %33 = "aie.core"(%17) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %124 = "arith.constant"() <{value = 0 : index}> : () -> index
      %125 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %126 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%124, %125, %126) ({
      ^bb0(%arg15: index):
        %127 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_2_1, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %128 = "aie.objectfifo.subview.access"(%127) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%128) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %129 = "arith.constant"() <{value = 0 : index}> : () -> index
        %130 = "arith.constant"() <{value = 8 : index}> : () -> index
        %131 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%129, %130, %131) ({
        ^bb0(%arg16: index):
          %132 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_1, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %133 = "aie.objectfifo.subview.access"(%132) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %134 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_1, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %135 = "aie.objectfifo.subview.access"(%134) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%133, %135, %128) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_1, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_1, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_2_1, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    %34 = "aie.core"(%18) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %112 = "arith.constant"() <{value = 0 : index}> : () -> index
      %113 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %114 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%112, %113, %114) ({
      ^bb0(%arg13: index):
        %115 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_2_2, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %116 = "aie.objectfifo.subview.access"(%115) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%116) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %117 = "arith.constant"() <{value = 0 : index}> : () -> index
        %118 = "arith.constant"() <{value = 8 : index}> : () -> index
        %119 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%117, %118, %119) ({
        ^bb0(%arg14: index):
          %120 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_2, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %121 = "aie.objectfifo.subview.access"(%120) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %122 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_2, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %123 = "aie.objectfifo.subview.access"(%122) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%121, %123, %116) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_2, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_2, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_2_2, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    %35 = "aie.core"(%19) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %100 = "arith.constant"() <{value = 0 : index}> : () -> index
      %101 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %102 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%100, %101, %102) ({
      ^bb0(%arg11: index):
        %103 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_2_3, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %104 = "aie.objectfifo.subview.access"(%103) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%104) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %105 = "arith.constant"() <{value = 0 : index}> : () -> index
        %106 = "arith.constant"() <{value = 8 : index}> : () -> index
        %107 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%105, %106, %107) ({
        ^bb0(%arg12: index):
          %108 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_3, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %109 = "aie.objectfifo.subview.access"(%108) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %110 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_3, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %111 = "aie.objectfifo.subview.access"(%110) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%109, %111, %104) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_3, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_3, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_2_3, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    %36 = "aie.core"(%20) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %88 = "arith.constant"() <{value = 0 : index}> : () -> index
      %89 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %90 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%88, %89, %90) ({
      ^bb0(%arg9: index):
        %91 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_3_0, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %92 = "aie.objectfifo.subview.access"(%91) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%92) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %93 = "arith.constant"() <{value = 0 : index}> : () -> index
        %94 = "arith.constant"() <{value = 8 : index}> : () -> index
        %95 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%93, %94, %95) ({
        ^bb0(%arg10: index):
          %96 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_0, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %97 = "aie.objectfifo.subview.access"(%96) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %98 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_0, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %99 = "aie.objectfifo.subview.access"(%98) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%97, %99, %92) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_0, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_0, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_3_0, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    %37 = "aie.core"(%21) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %76 = "arith.constant"() <{value = 0 : index}> : () -> index
      %77 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %78 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%76, %77, %78) ({
      ^bb0(%arg7: index):
        %79 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_3_1, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %80 = "aie.objectfifo.subview.access"(%79) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%80) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %81 = "arith.constant"() <{value = 0 : index}> : () -> index
        %82 = "arith.constant"() <{value = 8 : index}> : () -> index
        %83 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%81, %82, %83) ({
        ^bb0(%arg8: index):
          %84 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_1, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %85 = "aie.objectfifo.subview.access"(%84) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %86 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_1, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %87 = "aie.objectfifo.subview.access"(%86) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%85, %87, %80) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_1, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_1, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_3_1, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    %38 = "aie.core"(%22) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %64 = "arith.constant"() <{value = 0 : index}> : () -> index
      %65 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %66 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%64, %65, %66) ({
      ^bb0(%arg5: index):
        %67 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_3_2, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %68 = "aie.objectfifo.subview.access"(%67) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%68) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %69 = "arith.constant"() <{value = 0 : index}> : () -> index
        %70 = "arith.constant"() <{value = 8 : index}> : () -> index
        %71 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%69, %70, %71) ({
        ^bb0(%arg6: index):
          %72 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_2, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %73 = "aie.objectfifo.subview.access"(%72) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %74 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_2, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %75 = "aie.objectfifo.subview.access"(%74) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%73, %75, %68) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_2, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_2, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_3_2, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    %39 = "aie.core"(%23) <{link_with = "mm_64x64x32.o", stack_size = 1024 : i32}> ({
      %52 = "arith.constant"() <{value = 0 : index}> : () -> index
      %53 = "arith.constant"() <{value = 4294967295 : index}> : () -> index
      %54 = "arith.constant"() <{value = 1 : index}> : () -> index
      "scf.for"(%52, %53, %54) ({
      ^bb0(%arg3: index):
        %55 = "aie.objectfifo.acquire"() <{objFifo_name = @memC_3_3, port = 0 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi32>>
        %56 = "aie.objectfifo.subview.access"(%55) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi32>>) -> memref<64x32xi32>
        "func.call"(%56) <{callee = @zero_i32}> : (memref<64x32xi32>) -> ()
        %57 = "arith.constant"() <{value = 0 : index}> : () -> index
        %58 = "arith.constant"() <{value = 8 : index}> : () -> index
        %59 = "arith.constant"() <{value = 1 : index}> : () -> index
        "scf.for"(%57, %58, %59) ({
        ^bb0(%arg4: index):
          %60 = "aie.objectfifo.acquire"() <{objFifo_name = @memA_3, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x64xi16>>
          %61 = "aie.objectfifo.subview.access"(%60) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x64xi16>>) -> memref<64x64xi16>
          %62 = "aie.objectfifo.acquire"() <{objFifo_name = @memB_3, port = 1 : i32, size = 1 : i32}> : () -> !aie.objectfifosubview<memref<64x32xi16>>
          %63 = "aie.objectfifo.subview.access"(%62) <{index = 0 : i32}> : (!aie.objectfifosubview<memref<64x32xi16>>) -> memref<64x32xi16>
          "func.call"(%61, %63, %56) <{callee = @matmul_i16_i32}> : (memref<64x64xi16>, memref<64x32xi16>, memref<64x32xi32>) -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memA_3, port = 1 : i32, size = 1 : i32}> : () -> ()
          "aie.objectfifo.release"() <{objFifo_name = @memB_3, port = 1 : i32, size = 1 : i32}> : () -> ()
          "scf.yield"() : () -> ()
        }) : (index, index, index) -> ()
        "aie.objectfifo.release"() <{objFifo_name = @memC_3_3, port = 0 : i32, size = 1 : i32}> : () -> ()
        "scf.yield"() : () -> ()
      }) : (index, index, index) -> ()
      "aie.end"() : () -> ()
    }) : (index) -> index
    "aiex.runtime_sequence"() <{sym_name = "sequence"}> ({
    ^bb0(%arg0: memref<262144xi16>, %arg1: memref<262144xi16>, %arg2: memref<262144xi32>):
      %40 = "aiex.dma_configure_task_for"() <{alloc = @inA_0, issue_token = false, repeat_count = 0 : i32}> ({
        "aie.dma_bd"(%arg0) <{burst_length = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 1>]>, len = 0 : i32, offset = 0 : i32}> : (memref<262144xi16>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%40) : (index) -> ()
      %41 = "aiex.dma_configure_task_for"() <{alloc = @inB_0, issue_token = false, repeat_count = 0 : i32}> ({
        "aie.dma_bd"(%arg1) <{burst_length = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 1>]>, len = 0 : i32, offset = 0 : i32}> : (memref<262144xi16>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%41) : (index) -> ()
      %42 = "aiex.dma_configure_task_for"() <{alloc = @outC_0, issue_token = true, repeat_count = 0 : i32}> ({
        "aie.dma_bd"(%arg2) <{burst_length = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 1>]>, len = 0 : i32, offset = 0 : i32}> : (memref<262144xi32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%42) : (index) -> ()
      %43 = "aiex.dma_configure_task_for"() <{alloc = @inA_1, issue_token = false, repeat_count = 0 : i32}> ({
        "aie.dma_bd"(%arg0) <{burst_length = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 1>]>, len = 0 : i32, offset = 0 : i32}> : (memref<262144xi16>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%43) : (index) -> ()
      %44 = "aiex.dma_configure_task_for"() <{alloc = @inB_1, issue_token = false, repeat_count = 0 : i32}> ({
        "aie.dma_bd"(%arg1) <{burst_length = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 1>]>, len = 0 : i32, offset = 0 : i32}> : (memref<262144xi16>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%44) : (index) -> ()
      %45 = "aiex.dma_configure_task_for"() <{alloc = @outC_1, issue_token = true, repeat_count = 0 : i32}> ({
        "aie.dma_bd"(%arg2) <{burst_length = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 1>]>, len = 0 : i32, offset = 0 : i32}> : (memref<262144xi32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%45) : (index) -> ()
      %46 = "aiex.dma_configure_task_for"() <{alloc = @inA_2, issue_token = false, repeat_count = 0 : i32}> ({
        "aie.dma_bd"(%arg0) <{burst_length = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 1>]>, len = 0 : i32, offset = 0 : i32}> : (memref<262144xi16>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%46) : (index) -> ()
      %47 = "aiex.dma_configure_task_for"() <{alloc = @inB_2, issue_token = false, repeat_count = 0 : i32}> ({
        "aie.dma_bd"(%arg1) <{burst_length = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 1>]>, len = 0 : i32, offset = 0 : i32}> : (memref<262144xi16>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%47) : (index) -> ()
      %48 = "aiex.dma_configure_task_for"() <{alloc = @outC_2, issue_token = true, repeat_count = 0 : i32}> ({
        "aie.dma_bd"(%arg2) <{burst_length = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 1>]>, len = 0 : i32, offset = 0 : i32}> : (memref<262144xi32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%48) : (index) -> ()
      %49 = "aiex.dma_configure_task_for"() <{alloc = @inA_3, issue_token = false, repeat_count = 0 : i32}> ({
        "aie.dma_bd"(%arg0) <{burst_length = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 1>]>, len = 0 : i32, offset = 0 : i32}> : (memref<262144xi16>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%49) : (index) -> ()
      %50 = "aiex.dma_configure_task_for"() <{alloc = @inB_3, issue_token = false, repeat_count = 0 : i32}> ({
        "aie.dma_bd"(%arg1) <{burst_length = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 1>]>, len = 0 : i32, offset = 0 : i32}> : (memref<262144xi16>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%50) : (index) -> ()
      %51 = "aiex.dma_configure_task_for"() <{alloc = @outC_3, issue_token = true, repeat_count = 0 : i32}> ({
        "aie.dma_bd"(%arg2) <{burst_length = 0 : i32, dimensions = #aie<bd_dim_layout_array[<size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 0>, <size = 0, stride = 1>]>, len = 0 : i32, offset = 0 : i32}> : (memref<262144xi32>) -> ()
        "aie.end"() : () -> ()
      }) : () -> index
      "aiex.dma_start_task"(%51) : (index) -> ()
    }) : () -> ()
    "aie.end"() : () -> ()
  }) : () -> ()
}) : () -> ()

