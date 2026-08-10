#!/usr/bin/env sage
# 5D energy-momentum tensor components from the field tensor F
#
# Source: P. E. Williams, LA-8370-MS (LASL, 1980), Section III.
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S2, Appendix A [C4].

from sage.all import *

def ok(label, cond):
    print(f"  {label}: {'PASS' if cond else 'FAIL'}")
    assert cond

E1, E2, E3 = var('E1 E2 E3', domain='real')
B1, B2, B3 = var('B1 B2 B3', domain='real')
V0, V1, V2, V3 = var('V0 V1 V2 V3', domain='real')

E_sq = E1^2 + E2^2 + E3^2
B_sq = B1^2 + B2^2 + B3^2
V_sq = V1^2 + V2^2 + V3^2

# 1. FIELD TENSOR F (Imaginary-time Euclidean)
F = matrix(SR, 5, 5, [
    [ 0,     I*E1,  I*E2,  I*E3,  I*V0],
    [-I*E1,  0,     B3,   -B2,    V1  ],
    [-I*E2, -B3,    0,     B1,    V2  ],
    [-I*E3,  B2,   -B1,   0,      V3  ],
    [-I*V0, -V1,   -V2,  -V3,    0   ]
])

print("="*70)
print("12_energy_momentum_tensor_adjudicated.sage")
print("="*70)

print("\n(A) Tensor Component Verification")
F_sq_scalar = sum(F[i,j]^2 for i in range(5) for j in range(5)).simplify_full()
T_raw = (F*F + 1/4 * F_sq_scalar * identity_matrix(5)).simplify_full()

# T00: xi = (1/8pi)[E^2 + B^2 + V^2 + V0^2]
xi_4pi = 1/2 * (E_sq + B_sq + V_sq + V0^2)
ok("T_00 matches energy density xi", (T_raw[0,0] - xi_4pi).simplify_full() == 0)

# T01: Energy Flow
ExB1 = E2*B3 - E3*B2
T01_expected = -I * (ExB1 + V0*V1)
ok("T_01 matches Poynting + V-field flow", (T_raw[0,1] - T01_expected).simplify_full() == 0)

# T44: Mass Stress
T44_expected = 1/2 * (V0^2 + B_sq - E_sq - V_sq)
ok("T_44 matches expected mass stress", (T_raw[4,4] - T44_expected).simplify_full() == 0)

print("\n(B) Manuscript Audit (Page 99)")
print("  Theory: S_alpha = -(c/i) T_0alpha (Corrected).")
print("  Theory: Stress bracket [8pi*xi - 2V^2] (Dimensionally consistent corrected form).")
ok("T_11 matches corrected Dynamic stress decomposition", 
   (T_raw[1,1] - (E1^2 + B1^2 - V1^2 - 1/2*(E_sq + B_sq + V0^2 - V_sq))).simplify_full() == 0)

print("\nSummary: Energy-momentum tensor components and corrected decomposition verified.")
print("="*70)
