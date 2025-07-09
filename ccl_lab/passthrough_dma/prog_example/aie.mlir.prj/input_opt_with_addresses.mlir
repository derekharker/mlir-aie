module attributes {llvm.target_triple = "aie"} {
  llvm.mlir.global external @out_buff_0() {addr_space = 0 : i32} : !llvm.array<10 x i32>
  llvm.mlir.global external @out_cons_buff_0() {addr_space = 0 : i32} : !llvm.array<10 x i32>
  llvm.mlir.global external @back_buff_0() {addr_space = 0 : i32} : !llvm.array<10 x i32>
  llvm.mlir.global external @back_cons_buff_0() {addr_space = 0 : i32} : !llvm.array<10 x i32>
  llvm.func @debug_i32(i32) attributes {sym_visibility = "private"}
  llvm.func @llvm.aie.event0() attributes {sym_visibility = "private"}
  llvm.func @llvm.aie.event1() attributes {sym_visibility = "private"}
  llvm.func @llvm.aie.put.ms(i32, i32) attributes {sym_visibility = "private"}
  llvm.func @llvm.aie.put.wms(i32, i128) attributes {sym_visibility = "private"}
  llvm.func @llvm.aie.put.fms(i32, f32) attributes {sym_visibility = "private"}
  llvm.func @llvm.aie.get.ss(i32) -> i32 attributes {sym_visibility = "private"}
  llvm.func @llvm.aie.get.wss(i32) -> i128 attributes {sym_visibility = "private"}
  llvm.func @llvm.aie.get.fss(i32) -> f32 attributes {sym_visibility = "private"}
  llvm.func @llvm.aie.put.mcd(i384) attributes {sym_visibility = "private"}
  llvm.func @llvm.aie.get.scd() -> i384 attributes {sym_visibility = "private"}
  llvm.func @llvm.aie.lock.acquire.reg(i32, i32) attributes {sym_visibility = "private"}
  llvm.func @llvm.aie.lock.release.reg(i32, i32) attributes {sym_visibility = "private"}
  llvm.mlir.global external @back_cons() {addr_space = 0 : i32} : !llvm.array<10 x i32>
  llvm.mlir.global external @back() {addr_space = 0 : i32} : !llvm.array<10 x i32>
  llvm.mlir.global external @out_cons() {addr_space = 0 : i32} : !llvm.array<10 x i32>
  llvm.mlir.global external @out() {addr_space = 0 : i32} : !llvm.array<10 x i32>
  llvm.func @core_2_3() {
    %0 = llvm.mlir.addressof @back_buff_0 : !llvm.ptr
    %1 = llvm.mlir.addressof @out_cons_buff_0 : !llvm.ptr
    %2 = llvm.mlir.constant(49 : i32) : i32
    %3 = llvm.mlir.constant(3 : i32) : i32
    %4 = llvm.mlir.constant(10 : index) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(4 : i32) : i32
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.constant(0 : i32) : i32
    %9 = llvm.mlir.constant(1 : i32) : i32
    %10 = llvm.mlir.constant(48 : i32) : i32
    llvm.call @llvm.aie.lock.acquire.reg(%10, %9) : (i32, i32) -> ()
    llvm.call @llvm.aie.lock.acquire.reg(%2, %8) : (i32, i32) -> ()
    %11 = llvm.getelementptr %1[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<10 x i32>
    %12 = llvm.getelementptr inbounds|nuw %11[1] : (!llvm.ptr) -> !llvm.ptr, i32
    llvm.store %6, %12 : i32, !llvm.ptr
    llvm.br ^bb1(%5 : i64)
  ^bb1(%13: i64):  // 2 preds: ^bb0, ^bb2
    %14 = llvm.icmp "slt" %13, %4 : i64
    llvm.cond_br %14, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %15 = llvm.getelementptr inbounds|nuw %11[%13] : (!llvm.ptr, i64) -> !llvm.ptr, i32
    %16 = llvm.load %15 : !llvm.ptr -> i32
    %17 = llvm.getelementptr %0[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<10 x i32>
    %18 = llvm.getelementptr inbounds|nuw %17[%13] : (!llvm.ptr, i64) -> !llvm.ptr, i32
    llvm.store %16, %18 : i32, !llvm.ptr
    %19 = llvm.add %13, %7 : i64
    llvm.br ^bb1(%19 : i64)
  ^bb3:  // pred: ^bb1
    %20 = llvm.getelementptr %0[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<10 x i32>
    %21 = llvm.getelementptr inbounds|nuw %20[6] : (!llvm.ptr) -> !llvm.ptr, i32
    llvm.store %3, %21 : i32, !llvm.ptr
    llvm.call @llvm.aie.lock.release.reg(%10, %8) : (i32, i32) -> ()
    llvm.call @llvm.aie.lock.release.reg(%2, %9) : (i32, i32) -> ()
    llvm.return
  }
  llvm.func @core_1_1() {
    %0 = llvm.mlir.addressof @back_cons_buff_0 : !llvm.ptr
    %1 = llvm.mlir.addressof @out_buff_0 : !llvm.ptr
    %2 = llvm.mlir.constant(49 : i32) : i32
    %3 = llvm.mlir.constant(9 : i32) : i32
    %4 = llvm.mlir.constant(1 : i32) : i32
    %5 = llvm.mlir.constant(5 : i32) : i32
    %6 = llvm.mlir.constant(0 : i32) : i32
    %7 = llvm.mlir.constant(48 : i32) : i32
    llvm.call @llvm.aie.lock.acquire.reg(%7, %6) : (i32, i32) -> ()
    %8 = llvm.getelementptr %1[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<10 x i32>
    %9 = llvm.getelementptr inbounds|nuw %8[2] : (!llvm.ptr) -> !llvm.ptr, i32
    llvm.store %5, %9 : i32, !llvm.ptr
    llvm.call @llvm.aie.lock.release.reg(%7, %4) : (i32, i32) -> ()
    llvm.call @llvm.aie.lock.acquire.reg(%2, %4) : (i32, i32) -> ()
    %10 = llvm.getelementptr %0[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<10 x i32>
    %11 = llvm.getelementptr inbounds|nuw %10[5] : (!llvm.ptr) -> !llvm.ptr, i32
    llvm.store %3, %11 : i32, !llvm.ptr
    llvm.call @llvm.aie.lock.release.reg(%2, %6) : (i32, i32) -> ()
    llvm.return
  }
}

