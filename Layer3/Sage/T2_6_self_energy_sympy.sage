#!/usr/bin/env sage
# T2.6 — Self-Energy of a Charged Particle (R0 and finite G_min; prediction P3)
#
# Source: Williams LA-8370-MS (LASL, 1980), eqs 99, 103-104.
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S3, Appendix A [C7].

from sage.all import *

def ok(label, cond):
    print(f"  {label}: {'PASS' if cond else 'FAIL'}")
    assert cond

e, eps0, R, G0 = var('e epsilon_0 R G_0', domain='real')
m, k, a0 = var('m k a_0', domain='real')
assume(e > 0, eps0 > 0, R > 0, G0 > 0, m > 0, k > 0, a0 > 0)
q = var('q', domain='real')
gamma_v, V0 = var('gamma V_0', domain='real')

print("="*70)
print("19_self_energy_adjudicated.sage")
print("="*70)

print("\n(A) 5D Free Energy (Eq 99)")
G_5D = integrate(e / (4*pi*eps0*R) - gamma_v*V0/a0, q, 0, -e) + G0
expected_G = G0 - e^2/(4*pi*eps0*R) + e*gamma_v*V0/a0
ok("Integrated G matches Eq 99 structure", (G_5D - expected_G).simplify_full() == 0)

print("\n(B) Equilibrium Radius R0 (Eq 103)")
gamma_model = 3*m / (4*pi*R^3)
V0_model = k / R
G_model = G_5D.subs(gamma=gamma_model, V_0=V0_model)

dGdR = diff(G_model, R)
R0_val = (12*m*k*eps0 / (e*a0))^(1/3)
residual = dGdR.subs(R=R0_val).simplify_full()
if residual != 0:
    print(f"  DEBUG: residual = {residual}")
ok("Derived R0 matches Eq 103", residual == 0)

print("\n(C) Minimum Self-Energy Audit (Eq 104)")
R0 = var('R_0')
G_min_val = G_model.subs(R=R0_val).simplify_full()
G_min_expected_val = (G0 - 3*e^2/(16*pi*eps0*R0)).subs({R0: R0_val}).simplify_full()
residual_G = (G_min_val - G_min_expected_val).simplify_full()
if residual_G != 0:
    print(f"  DEBUG: G_min_val = {G_min_val}")
    print(f"  DEBUG: G_min_expected_val = {G_min_expected_val}")
    print(f"  DEBUG: residual_G = {residual_G}")
ok("Derived G_min = G0 - 3e^2/(16pi eps0 R0)", residual_G == 0)
print("  Note: Manuscript Eq 104 prints 1/16; confirmed as coefficient error.")

print("\n(D) Stability Check (G'' > 0)")
d2GdR2 = diff(G_model, R, 2)
d2GdR2_at_R0 = d2GdR2.subs(R=R0_val).simplify_full()
ok("R0 is a stable minimum (G'' > 0)", bool(d2GdR2_at_R0 > 0))

print("\nSummary: Finite self-energy radius and stable minimum verified.")
print("="*70)
