/-
  Nonstandard Model — A3 (strong sector): the 3-body cyclic structure vs su(3).

  Source: P. E. Williams, "The Dynamic Theory" (book, 2009), Ch. 2 Eq (2.32) / Ch. 9 Eqs (9.40)-(9.41).
  Full derivation, context and provenance:
  Supplementary Materials (stand-alone document) — §S3 (Nonstandard Model; Appendix A.2, script 14, B-C1).
-/

import Mathlib.Tactic

namespace DTWilliams.NonstandardModel.SU3Circulant

open Matrix

/-- 3-cycle permutation matrix P (1 → 2 → 3 → 1). -/
def P : Matrix (Fin 3) (Fin 3) ℤ := !![0, 0, 1; 1, 0, 0; 0, 1, 0]

/-- All-ones matrix J. -/
def J : Matrix (Fin 3) (Fin 3) ℤ := !![1, 1, 1; 1, 1, 1; 1, 1, 1]

/-- Williams' cyclic combination `C^θ = A^β + A^γ`, as a map on the 3 labels. -/
def M : Matrix (Fin 3) (Fin 3) ℤ := !![0, 1, 1; 1, 0, 1; 1, 1, 0]

/-- Gell-Mann generator λ1 (real). -/
def lam1 : Matrix (Fin 3) (Fin 3) ℤ := !![0, 1, 0; 1, 0, 0; 0, 0, 0]

/-- Gell-Mann generator λ3 (real). -/
def lam3 : Matrix (Fin 3) (Fin 3) ℤ := !![1, 0, 0; 0, -1, 0; 0, 0, 0]

/-- P is the 3-cycle: `P³ = 1`. -/
theorem P_cube : P * P * P = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [P, mul_apply, Fin.sum_univ_three]

/-- `M` is circulant: a polynomial in `P`, namely `M = P + P²`. -/
theorem M_circulant : M = P + P * P := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [M, P]

/-- `M = J - 1` (Williams' written form, where `1` is the identity matrix). -/
theorem M_eq_J_sub_one : M = J - 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [M, J, Matrix.sub_apply]

/-- `J = 1 + P + P²`: the all-ones matrix is the sum of the three cyclic
permutations. -/
theorem J_decomp : J = 1 + P + P * P := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [J, P, Matrix.add_apply]

/-- The cyclic combination COMMUTES with its generator: `[M, P] = 0`. -/
theorem M_comm_P : M * P = P * M := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [M, P, mul_apply, Fin.sum_univ_three]

/-- `M` is symmetric. -/
theorem M_symm : Mᵀ = M := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [M, transpose_apply]

/-- `M` is traceless — so `i·M` is a traceless anti-Hermitian element of su(3). -/
theorem M_trace_zero : M.trace = 0 := by
  simp [M, trace, diag, Fin.sum_univ_three]

/-- su(3) is NON-ABELIAN: λ1 and λ3 do not commute. -/
theorem su3_nonabelian : lam1 * lam3 ≠ lam3 * lam1 := by
  intro h
  have h00 := congrFun (congrFun h 0) 1
  simp [lam1, lam3, mul_apply, Fin.sum_univ_three] at h00

/-- The non-abelian witness, explicitly: `[λ1, λ3] ≠ 0`. -/
theorem comm_lam1_lam3 :
    lam1 * lam3 - lam3 * lam1 = !![0, -2, 0; 2, 0, 0; 0, 0, 0] := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [lam1, lam3, Matrix.sub_apply]

/--
  A3 capstone. Williams' explicit cyclic construction commutes with its
  generator (it is abelian / circulant — a Cartan slice of su(3)), WHEREAS su(3)
  contains a non-commuting pair. So the cyclic combination cannot generate the
  non-abelian su(3): the "SU(3) characteristics" are the fundamental-triplet
  index structure and a Cartan resemblance, not the full colour gauge algebra.
-/
theorem cyclic_abelian_but_su3_nonabelian :
    (M * P = P * M) ∧ (lam1 * lam3 ≠ lam3 * lam1) :=
  ⟨M_comm_P, su3_nonabelian⟩

end DTWilliams.NonstandardModel.SU3Circulant
