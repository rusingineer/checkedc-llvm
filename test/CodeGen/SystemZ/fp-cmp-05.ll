; Test that floating-point instructions that set cc are used to
; eliminate compares for load complement, load negative and load
; positive. Right now, the WFL.DB (vector) instructions are not
; handled by SystemZElimcompare, so for Z13 this is currently
; unimplemented.
;
; RUN: llc < %s -mtriple=s390x-linux-gnu -mcpu=z10 | FileCheck %s -check-prefix=CHECK-Z10

; Load complement (sign-bit flipped).
; Test f32
define float @f1(float %a, float %b, float %f) {
; CHECK-LABEL: f1:
; CHECK-Z10: lcebr
; CHECK-Z10-NEXT: je
  %neg = fsub float -0.0, %f
  %cond = fcmp oeq float %neg, 0.0
  %res = select i1 %cond, float %a, float %b
  ret float %res
}

; Test f64
define double @f2(double %a, double %b, double %f) {
; CHECK-LABEL: f2:
; CHECK-Z10: lcdbr
; CHECK-Z10-NEXT: je
  %neg = fsub double -0.0, %f
  %cond = fcmp oeq double %neg, 0.0
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Negation of floating-point absolute.
; Test f32
declare float @llvm.fabs.f32(float %f)
define float @f3(float %a, float %b, float %f) {
; CHECK-LABEL: f3:
; CHECK-Z10: lnebr
; CHECK-Z10-NEXT: je
  %abs = call float @llvm.fabs.f32(float %f)
  %neg = fsub float -0.0, %abs
  %cond = fcmp oeq float %neg, 0.0
  %res = select i1 %cond, float %a, float %b
  ret float %res
}

; Test f64
declare double @llvm.fabs.f64(double %f)
define double @f4(double %a, double %b, double %f) {
; CHECK-LABEL: f4:
; CHECK-Z10: lndbr
; CHECK-Z10-NEXT: je
  %abs = call double @llvm.fabs.f64(double %f)
  %neg = fsub double -0.0, %abs
  %cond = fcmp oeq double %neg, 0.0
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Absolute floating-point value.
; Test f32
define float @f5(float %a, float %b, float %f) {
; CHECK-LABEL: f5:
; CHECK-Z10: lpebr
; CHECK-Z10-NEXT: je
  %abs = call float @llvm.fabs.f32(float %f)
  %cond = fcmp oeq float %abs, 0.0
  %res = select i1 %cond, float %a, float %b
  ret float %res
}

; Test f64
define double @f6(double %a, double %b, double %f) {
; CHECK-LABEL: f6:
; CHECK-Z10: lpdbr
; CHECK-Z10-NEXT: je
  %abs = call double @llvm.fabs.f64(double %f)
  %cond = fcmp oeq double %abs, 0.0
  %res = select i1 %cond, double %a, double %b
  ret double %res
}
