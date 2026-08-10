#!/usr/bin/env sage
# Bianchi and Maxwell identities in 5D (Eqs 68, 70)
#
# Source: P. E. Williams, LA-8370-MS (LASL, 1980), eqs (68), (70). The reversed
#   Eq-68d gauge sign (+ -> -) follows Williams' acknowledgement of the reversal
#   found by Dr. Dan Ross.
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S2, Appendix A [C3].

from sage.all import *

def ok(label, cond):
    print(f"  {label}: {'PASS' if cond else 'FAIL'}")
    assert cond

# 1. SETUP MANIFOLD (5D Minkowski with signature (+,-,-,-,-))
M = Manifold(5, 'M', structure='Lorentzian')
X.<x0, x1, x2, x3, x4> = M.chart()

g = M.metric('g')
g[0,0] = 1
g[1,1] = -1
g[2,2] = -1
g[3,3] = -1
g[4,4] = -1

# 2. DEFINE FIELD TENSOR F
F = M.tensor_field(0, 2, 'F', antisym=[0,1])

E1 = function('E1')(*X); E2 = function('E2')(*X); E3 = function('E3')(*X)
B1 = function('B1')(*X); B2 = function('B2')(*X); B3 = function('B3')(*X)
V0 = function('V0')(*X); V1 = function('V1')(*X); V2 = function('V2')(*X); V3 = function('V3')(*X)

F[0,1] = I*E1; F[0,2] = I*E2; F[0,3] = I*E3; F[0,4] = I*V0
F[1,2] = B3;   F[1,3] = -B2;  F[1,4] = V1
F[2,3] = B1;   F[2,4] = V2
F[3,4] = V3

print("="*70)
print("03_bianchi_maxwell_adjudicated.sage")
print("="*70)

print("\n(A) Bianchi identity dF = 0 (Eq 68)")
dF = F.exterior_derivative()

# 68a: div B = 0
b123 = dF[1, 2, 3]
expected_68a = diff(B1, x1) + diff(B2, x2) + diff(B3, x3)
ok("Eq 68a residual (div B)", (b123 - expected_68a).expr().simplify_full() == 0)

# 68b: curl E + (1/c)dB/dt = 0
b012 = dF[0, 1, 2]
expected_68b = diff(B3, x0) + I*diff(E1, x2) - I*diff(E2, x1)
ok("Eq 68b component residual", (b012 - expected_68b).expr().simplify_full() == 0)

# 68d: grad V0 + (1/c)dV/dt + a0 dE/dgamma = 0
b014 = dF[0, 1, 4]
expected_68d = I*diff(E1, x4) - I*diff(V0, x1) + diff(V1, x0)
ok("Eq 68d component residual", (b014 - expected_68d).expr().simplify_full() == 0)
print("  Note: Eq 68d result contains -dE/dgamma, matching the corrected physics.")

print("\n(B) Divergence equations J^j = nabla_i F^{ij} (Eq 70)")
F_upper = F.up(g)
nabla = g.connection()
J = nabla(F_upper).trace(0, 2)

divE = diff(E1, x1) + diff(E2, x2) + diff(E3, x3)
divV = diff(V1, x1) + diff(V2, x2) + diff(V3, x3)

# 70a: div E + dV0/dx4 = 4pi*rho
J0_expected = I*(divE + diff(V0, x4))
ok("Eq 70a algebraic residual", (J[0] - J0_expected).expr().simplify_full() == 0)

# 70c: div V - (1/c)dV0/dt = -(4pi/c)J4
# With x0=ict, -I*d/dx0 = -(1/c)d/dt. Covariant J_4 = -J^4.
J4_raw = J[4].expr().simplify_full()
expected_J4_raw = divV - I*diff(V0, x0)
ok("Raw J^4 matches div(V) - (1/c)dV0/dt", (J4_raw - expected_J4_raw).simplify_full() == 0)
print("  With x0=ict and covariant fifth current J_4 = -J^4 (g44=-1),")
print("  Eq 70c matches the manuscript's physical signs.")

print("\n(C) Signature Check")
g_plus = M.metric('g_plus')
g_plus[0,0] = 1; g_plus[1,1] = -1; g_plus[2,2] = -1; g_plus[3,3] = -1; g_plus[4,4] = 1
J_plus = g_plus.connection()(F.up(g_plus)).trace(0, 2)
ok("g44=+1 flips the V0 term in J^0", (J_plus[0] - I*(divE - diff(V0, x4))).expr().simplify_full() == 0)

print("\nSummary: Bianchi and Maxwell identities verified with explicit sign conventions.")
print("="*70)
