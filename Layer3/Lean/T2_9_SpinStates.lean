/-
  T2.9 — Allowed fundamental spin states

  Source: Williams LA-8370-MS (1980), pages 125-128.
  Full derivation, context and provenance:
  Supplementary_Material.pdf — §S3, Appendix A [C6].

  Note: doubled units (+1, -1, -3) represent source half-integers (+1/2, -1/2, -3/2).
-/

import Mathlib.Tactic

namespace DTWilliams.Gemini.SpinStates

/-- The eight combinations listed on pages 126-128. -/
inductive OctetState
  | t1p | t1m | t2p | t2m | t3p | t3m | t4p | t4m
  deriving DecidableEq, Fintype

open OctetState

/-- Doubled `(s1,s2,s3,u1,u2,u3)` values for each listed state. -/
def spinData : OctetState -> Int × Int × Int × Int × Int × Int
  | t1p => ( 1,  1,  1, -1,  1, -1)
  | t1m => ( 1,  1,  1,  1, -1,  1)
  | t2p => ( 1, -1, -1,  1,  1, -1)
  | t2m => ( 1, -1, -1, -1, -1,  1)
  | t3p => (-1, -1,  1,  1, -1, -1)
  | t3m => (-1, -1,  1, -1,  1,  1)
  | t4p => (-1,  1, -1, -1, -1, -1)
  | t4m => (-1,  1, -1,  1,  1,  1)

def s1 (q : OctetState) : Int := (spinData q).1
def s2 (q : OctetState) : Int := (spinData q).2.1
def s3 (q : OctetState) : Int := (spinData q).2.2.1
def u1 (q : OctetState) : Int := (spinData q).2.2.2.1
def u2 (q : OctetState) : Int := (spinData q).2.2.2.2.1
def u3 (q : OctetState) : Int := (spinData q).2.2.2.2.2

/-- Williams' doubled four-spin component formulas. -/
def S1 (q : OctetState) : Int := s1 q - u2 q - u3 q
def S2 (q : OctetState) : Int := s2 q + u1 q - u3 q
def S3 (q : OctetState) : Int := s3 q + u1 q + u2 q
def S4 (q : OctetState) : Int := s1 q - s2 q + s3 q

def tVector (q : OctetState) : Int × Int × Int :=
  (-(u2 q + u3 q), u1 q - u3 q, u1 q + u2 q)

/-- The source octet has exactly eight cases. -/
theorem octet_card : Fintype.card OctetState = 8 := by
  decide

/-- Each listed standard/new spin component is ±1/2, in doubled units. -/
theorem components_are_half_units (q : OctetState) :
    (s1 q = 1 ∨ s1 q = -1) ∧ (s2 q = 1 ∨ s2 q = -1) ∧
    (s3 q = 1 ∨ s3 q = -1) ∧ (u1 q = 1 ∨ u1 q = -1) ∧
    (u2 q = 1 ∨ u2 q = -1) ∧ (u3 q = 1 ∨ u3 q = -1) := by
  cases q <;> decide

/-- Williams' allowed four-spin values are 1/2 or -3/2, in doubled units. -/
theorem S_values_are_source_values (q : OctetState) :
    (S1 q = 1 ∨ S1 q = -3) ∧ (S2 q = 1 ∨ S2 q = -3) ∧
    (S3 q = 1 ∨ S3 q = -3) ∧ (S4 q = 1 ∨ S4 q = -3) := by
  cases q <;> decide

/-- The four positive t-vectors printed on page 127, in doubled units. -/
theorem positive_t_vectors :
    tVector t1p = (0, 0, 0) ∧
    tVector t2p = (0, 2, 2) ∧
    tVector t3p = (2, 2, 0) ∧
    tVector t4p = (2, 0, -2) := by
  decide

/-- The corresponding negative t-vectors printed on pages 127-128. -/
theorem negative_t_vectors :
    tVector t1m = (0, 0, 0) ∧
    tVector t2m = (0, -2, -2) ∧
    tVector t3m = (-2, -2, 0) ∧
    tVector t4m = (-2, 0, 2) := by
  decide

end DTWilliams.Gemini.SpinStates
