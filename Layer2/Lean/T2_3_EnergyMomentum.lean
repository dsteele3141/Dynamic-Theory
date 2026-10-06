/-
  T2.3 — Energy-Momentum Tensor in 5D

  Source: P. E. Williams, LA-8370-MS (LASL, 1980), Section III.
  Full derivation, context and provenance:
  Supplementary_Material.pdf — §S2, Appendix A [C4].
-/

import Mathlib.Tactic
import Mathlib.Basic.Complex.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Algebra.BigOperators.Fin
import Layer2.Lean.T2_4_ForceDensity

namespace DTWilliams.EnergyMomentum

set_option linter.unnecessarySeqFocus false

open Matrix
open Complex (I)
open DTWilliams.ForceDensity (Ften)

variable (E1 E2 E3 B1 B2 B3 V0 V1 V2 V3 : ℂ)

/-- The field scalar `F_{st}F_{st} = Σ_{s,t} (F_{st})²` (Euclidean i-time). -/
noncomputable def Fscalar : ℂ :=
  ∑ s, ∑ t, (Ften E1 E2 E3 B1 B2 B3 V0 V1 V2 V3 s t) ^ 2

/-- The bracket `Tdens_{jk} = (F²)_{jk} + ¼ δ_{jk} F_{st}F_{st}` (= 4π·T_{jk}). -/
noncomputable def Tdens (j k : Fin 5) : ℂ :=
  (Ften E1 E2 E3 B1 B2 B3 V0 V1 V2 V3 * Ften E1 E2 E3 B1 B2 B3 V0 V1 V2 V3) j k
    + (1 / 4) * Fscalar E1 E2 E3 B1 B2 B3 V0 V1 V2 V3 * (if j = k then 1 else 0)

/-- **Scalar invariant.** `F_{st}F_{st} = 2(B² + V² − E² − V₀²)`. -/
theorem Fscalar_eq :
    Fscalar E1 E2 E3 B1 B2 B3 V0 V1 V2 V3
      = 2 * ((B1^2+B2^2+B3^2) + (V1^2+V2^2+V3^2) - (E1^2+E2^2+E3^2) - V0^2) := by
  unfold Fscalar
  simp [Ften, Fin.sum_univ_five] <;> ring_nf <;>
    simp only [Complex.I_sq] <;> ring

/-- **T₀₀ — energy density.** `½(E²+B²+V₀²+V²)`. -/
theorem T00 :
    Tdens E1 E2 E3 B1 B2 B3 V0 V1 V2 V3 0 0
      = (1/2) * ((E1^2+E2^2+E3^2) + (B1^2+B2^2+B3^2) + V0^2 + (V1^2+V2^2+V3^2)) := by
  unfold Tdens Fscalar
  simp [Ften, Matrix.mul_apply, Fin.sum_univ_five] <;> ring_nf <;>
    simp only [Complex.I_sq] <;> ring

/-- **T₀₁ — Poynting + V-field energy flow.** `−i[(Ē×B̄)₁ + V₀V₁]`. -/
theorem T01 :
    Tdens E1 E2 E3 B1 B2 B3 V0 V1 V2 V3 0 1
      = -I * ((E2*B3 - E3*B2) + V0*V1) := by
  unfold Tdens Fscalar
  simp [Ften, Matrix.mul_apply, Fin.sum_univ_five] <;> ring_nf

/-- **T₀₄ — mass-energy coupling.** `i(Ē·V̄)`. -/
theorem T04 :
    Tdens E1 E2 E3 B1 B2 B3 V0 V1 V2 V3 0 4
      = I * (E1*V1 + E2*V2 + E3*V3) := by
  unfold Tdens Fscalar
  simp [Ften, Matrix.mul_apply, Fin.sum_univ_five] <;> ring_nf

/-- **T₄₁ — V-field spatial momentum.** `V₀E₁ + (V̄×B̄)₁`. -/
theorem T41 :
    Tdens E1 E2 E3 B1 B2 B3 V0 V1 V2 V3 4 1
      = V0*E1 + (V2*B3 - V3*B2) := by
  unfold Tdens Fscalar
  simp [Ften, Matrix.mul_apply, Fin.sum_univ_five] <;> ring_nf <;>
    simp only [Complex.I_sq] <;> ring

/-- **T₄₄ — mass-density stress.** `½(V₀²+B²−E²−V²)`. -/
theorem T44 :
    Tdens E1 E2 E3 B1 B2 B3 V0 V1 V2 V3 4 4
      = (1/2) * (V0^2 + (B1^2+B2^2+B3^2) - (E1^2+E2^2+E3^2) - (V1^2+V2^2+V3^2)) := by
  unfold Tdens Fscalar
  simp [Ften, Matrix.mul_apply, Fin.sum_univ_five] <;> ring_nf <;>
    simp only [Complex.I_sq] <;> ring

/-- **T₁₁ — dynamic stress (diagonal).**
    `E₁² + B₁² − V₁² − ½(E²+B²+V₀²−V²)`. -/
theorem T11 :
    Tdens E1 E2 E3 B1 B2 B3 V0 V1 V2 V3 1 1
      = E1^2 + B1^2 - V1^2
        - (1/2) * ((E1^2+E2^2+E3^2) + (B1^2+B2^2+B3^2) + V0^2 - (V1^2+V2^2+V3^2)) := by
  unfold Tdens Fscalar
  simp [Ften, Matrix.mul_apply, Fin.sum_univ_five] <;> ring_nf <;>
    simp only [Complex.I_sq] <;> ring

/-- **T₁₂ — dynamic stress (off-diagonal).** `E₁E₂ + B₁B₂ − V₁V₂` (no trace term). -/
theorem T12 :
    Tdens E1 E2 E3 B1 B2 B3 V0 V1 V2 V3 1 2
      = E1*E2 + B1*B2 - V1*V2 := by
  unfold Tdens Fscalar
  simp [Ften, Matrix.mul_apply, Fin.sum_univ_five] <;> ring_nf <;>
    simp only [Complex.I_sq] <;> ring

/-- **Trace.** `T_{jj} = ½(B²+V²−E²−V₀²)` (equal to ¼·F_{st}F_{st}). -/
theorem trace_eq :
    (∑ j, Tdens E1 E2 E3 B1 B2 B3 V0 V1 V2 V3 j j)
      = (1/2) * ((B1^2+B2^2+B3^2) + (V1^2+V2^2+V3^2) - (E1^2+E2^2+E3^2) - V0^2) := by
  unfold Tdens Fscalar
  simp [Ften, Matrix.mul_apply, Fin.sum_univ_five] <;> ring_nf <;>
    simp only [Complex.I_sq] <;> ring

/-- **Classical limit (Maxwell stress tensor).** With the V-field off
    (`V₀=V̄=0`), the dynamic stress `T₁₁` reduces to the Maxwell stress diagonal
    `E₁² + B₁² − ½(E²+B²)`. -/
theorem T11_classical :
    Tdens E1 E2 E3 B1 B2 B3 0 0 0 0 1 1
      = E1^2 + B1^2 - (1/2) * ((E1^2+E2^2+E3^2) + (B1^2+B2^2+B3^2)) := by
  unfold Tdens Fscalar
  simp [Ften, Matrix.mul_apply, Fin.sum_univ_five] <;> ring_nf <;>
    simp only [Complex.I_sq] <;> ring

end DTWilliams.EnergyMomentum
