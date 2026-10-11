# T2.12 — Viscous Stress from Geometry (Eqs 165-172)
#
# Source: Williams LA-8370-MS (LASL, 1980), eqs 165-172.
# Full derivation, context and provenance:
#   Supplementary Materials (stand-alone document) — §S3, Appendix A [C4].

from sage.all import *

# --- Symbols ---
P, c = var('P c', domain='real')
gh0, gh1, gh44 = var('gh0 gh1 gh44', domain='real') # ghat components
assume(gh0 != 0, gh1 != 0, gh44 != 0)
f0, f1 = var('f0 f1', domain='real') # Mass density gradients
eps = var('eps', domain='real')


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


# 1. COVARIANT HYPERSURFACE METRIC (T2.11 Result)
print("="*60)
print("COMPUTATION 1: Covariant Metric Perturbation (h_ab)")
print("="*60)

# 2D Spacetime analogue for clarity
G_hat_low = diagonal_matrix([gh0, gh1])
f_vec = matrix(SR, 2, 1, [f0, f1])
# h_ab = gh44 * f_a * f_b (Rank-1 perturbation from Page 147)
H_low = gh44 * (f_vec * f_vec.transpose())

A_low = G_hat_low + eps * H_low
print(f"\nCovariant Metric A_ab:\n{A_low}")

# 2. EXACT CONTRAVARIANT METRIC (Sherman-Morrison)
print("\n" + "="*60)
print("COMPUTATION 2: Exact Contravariant Metric (Inversion)")
print("="*60)

def sm_inverse(G, u, v, scalar):
    """Exact inverse of (G + scalar * u * v^T)."""
    G_inv = G.inverse()
    denom = 1 + scalar * (v.transpose() * G_inv * u)[0,0]
    return G_inv - (scalar / denom) * (G_inv * u * v.transpose() * G_inv)

A_inv_exact = sm_inverse(G_hat_low, f_vec, f_vec, eps * gh44)
print(f"\nExact Contravariant Metric A^ab (Sherman-Morrison):")
print(A_inv_exact.simplify_full())

# Cross-check: the Sherman-Morrison inverse really is the inverse of A_low.
ok("Sherman-Morrison inverse satisfies A^ab A_bc = I.",
   (A_inv_exact * A_low - identity_matrix(SR, 2)).simplify_full().is_zero())

# 3. DEFINITION OF VISCOUS h^ab (Eq 168 context)
print("\n" + "="*60)
print("COMPUTATION 3: Viscous Term h^ab and Linearization")
print("="*60)

# By definition in Eq 168: h^ab = A^ab - ghat^ab
G_hat_upper = G_hat_low.inverse()
H_upper_exact = (A_inv_exact - G_hat_upper).simplify_full()

# Linearized first order in mass gradients (eps)
H_upper_linear = H_upper_exact.apply_map(lambda entry: entry.diff(eps)).subs(eps=0).simplify_full()
expected_linear = (-G_hat_upper * H_low * G_hat_upper).simplify_full()

print(f"\nExact h^ab perturbation:\n{H_upper_exact}")
print(f"\nLinearized h^ab:\n{H_upper_linear}")
ok("Linearized h^ab = -ghat^ac h_cd ghat^db (sign flip + metric scaling).",
   (H_upper_linear - expected_linear).simplify_full().is_zero())

# 4. VISCOUS STRESS t^ab (Eq 170)
print("\n" + "="*60)
print("COMPUTATION 4: Viscous Stress Identity (t^ab = -P h^ab)")
print("="*60)

# t^ab = -P * h^ab
t_ab = -P * H_upper_linear
print(f"\nViscous Stress t^ab (linearized):\n{t_ab}")
print("\nINTERPRETATION (definition + reading, NON-ASSERTED):")
print("  1. The viscous stress t^ab is proportional to (P * gh44) * (grad gamma)^2.")
print("  2. Index-raising introduces a MINUS sign relative to the covariant h_ab")
print("     (this sign is the asserted COMPUTATION 3 result).")
print("  3. Viscosity coefficients in Eq 172 are therefore derived from the")
print("     geometric curvature of the 5D hypersurface.")

print("\nAudit Complete: 14_viscous_stress.sage")
print("="*60)
