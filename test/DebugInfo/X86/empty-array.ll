; RUN: llc -mtriple=x86_64-apple-darwin -O0 -filetype=obj -o %t < %s
; RUN: llvm-dwarfdump -debug-dump=info %t | FileCheck %s
; <rdar://problem/12566646>

%class.A = type { [0 x i32] }

@a = global %class.A zeroinitializer, align 4

; CHECK: DW_TAG_class_type
; CHECK:      DW_TAG_member
; CHECK-NEXT: DW_AT_name [DW_FORM_strp]  ( .debug_str[0x{{[0-9a-f]*}}] = "x")
; CHECK-NEXT: DW_AT_type [DW_FORM_ref4]  (cu + 0x{{[0-9a-f]*}} => {[[ARRAY:0x[0-9a-f]*]]})

; CHECK:      [[ARRAY]]: DW_TAG_array_type [{{.*}}] *
; CHECK-NEXT: DW_AT_type [DW_FORM_ref4]    (cu + 0x{{[0-9a-f]*}} => {[[BASETYPE:0x[0-9a-f]*]]})

; CHECK:      DW_TAG_subrange_type
; CHECK-NEXT: DW_AT_type [DW_FORM_ref4]  (cu + 0x{{[0-9a-f]*}} => {[[BASE2:0x[0-9a-f]*]]})
; CHECK-NOT:  DW_AT_upper_bound

; CHECK: [[BASETYPE]]: DW_TAG_base_type
; CHECK: [[BASE2]]: DW_TAG_base_type
; CHECK-NEXT: DW_AT_name
; CHECK-NEXT: DW_AT_byte_size [DW_FORM_data1]  (0x08)
; CHECK-NEXT: DW_AT_encoding [DW_FORM_data1]   (DW_ATE_unsigned)

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!21}

!0 = !MDCompileUnit(language: DW_LANG_C_plus_plus, producer: "clang version 3.3 (trunk 169136)", isOptimized: false, emissionKind: 0, file: !20, enums: !1, retainedTypes: !1, subprograms: !1, globals: !3, imports:  !1)
!1 = !{}
!3 = !{!5}
!5 = !MDGlobalVariable(name: "a", line: 1, isLocal: false, isDefinition: true, scope: null, file: !6, type: !7, variable: %class.A* @a)
!6 = !MDFile(filename: "t.cpp", directory: "/Volumes/Sandbox/llvm")
!7 = !MDCompositeType(tag: DW_TAG_class_type, name: "A", line: 1, align: 32, file: !20, elements: !8)
!8 = !{!9, !14}
!9 = !MDDerivedType(tag: DW_TAG_member, name: "x", line: 1, flags: DIFlagPrivate, file: !20, scope: !7, baseType: !10)
!10 = !MDCompositeType(tag: DW_TAG_array_type, align: 32, baseType: !11, elements: !12)
!11 = !MDBasicType(tag: DW_TAG_base_type, name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!12 = !{!13}
!13 = !MDSubrange(count: -1)
!14 = !MDSubprogram(name: "A", line: 1, isLocal: false, isDefinition: false, virtualIndex: 6, flags: DIFlagArtificial | DIFlagPrototyped, isOptimized: false, scopeLine: 1, file: !6, scope: !7, type: !15)
!15 = !MDSubroutineType(types: !16)
!16 = !{null, !17}
!17 = !MDDerivedType(tag: DW_TAG_pointer_type, size: 64, align: 64, flags: DIFlagArtificial | DIFlagObjectPointer, baseType: !7)
!20 = !MDFile(filename: "t.cpp", directory: "/Volumes/Sandbox/llvm")
!21 = !{i32 1, !"Debug Info Version", i32 3}
