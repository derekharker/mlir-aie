; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"
target triple = "aie"

@out_buff_0 = external global [10 x i32]
@out_cons_buff_0 = external global [10 x i32]
@back_buff_0 = external global [10 x i32]
@back_cons_buff_0 = external global [10 x i32]
@back_cons = external global [10 x i32]
@back = external global [10 x i32]
@out_cons = external global [10 x i32]
@out = external global [10 x i32]

declare void @debug_i32(i32)

declare void @llvm.aie.event0()

declare void @llvm.aie.event1()

declare void @llvm.aie.put.ms(i32, i32)

declare void @llvm.aie.put.wms(i32, i128)

declare void @llvm.aie.put.fms(i32, float)

declare i32 @llvm.aie.get.ss(i32)

declare i128 @llvm.aie.get.wss(i32)

declare float @llvm.aie.get.fss(i32)

declare void @llvm.aie.put.mcd(i384)

declare i384 @llvm.aie.get.scd()

declare void @llvm.aie.lock.acquire.reg(i32, i32)

declare void @llvm.aie.lock.release.reg(i32, i32)

define void @core_2_3() {
  call void @llvm.aie.lock.acquire.reg(i32 48, i32 1)
  call void @llvm.aie.lock.acquire.reg(i32 49, i32 0)
  store i32 4, ptr getelementptr inbounds (i8, ptr @out_cons_buff_0, i64 4), align 4
  br label %1

1:                                                ; preds = %4, %0
  %2 = phi i64 [ %8, %4 ], [ 0, %0 ]
  %3 = icmp slt i64 %2, 10
  br i1 %3, label %4, label %9

4:                                                ; preds = %1
  %5 = getelementptr inbounds i32, ptr @out_cons_buff_0, i64 %2
  %6 = load i32, ptr %5, align 4
  %7 = getelementptr inbounds i32, ptr @back_buff_0, i64 %2
  store i32 %6, ptr %7, align 4
  %8 = add i64 %2, 1
  br label %1

9:                                                ; preds = %1
  store i32 3, ptr getelementptr inbounds (i8, ptr @back_buff_0, i64 24), align 4
  call void @llvm.aie.lock.release.reg(i32 48, i32 0)
  call void @llvm.aie.lock.release.reg(i32 49, i32 1)
  ret void
}

define void @core_1_1() {
  call void @llvm.aie.lock.acquire.reg(i32 48, i32 0)
  store i32 5, ptr getelementptr inbounds (i8, ptr @out_buff_0, i64 8), align 4
  call void @llvm.aie.lock.release.reg(i32 48, i32 1)
  call void @llvm.aie.lock.acquire.reg(i32 49, i32 1)
  store i32 9, ptr getelementptr inbounds (i8, ptr @back_cons_buff_0, i64 20), align 4
  call void @llvm.aie.lock.release.reg(i32 49, i32 0)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
