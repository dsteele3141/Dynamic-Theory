#!/usr/bin/env sage
# Geometry-dependent canonical commutator / uncertainty (Book Eq 6.23)
#
# Source: P. E. Williams, "The Dynamic Theory" (the book), Ch. 6, Eq (6.23) —
#   developed in the book rather than the Report; the underpinning Weyl
#   connection identity is LA-8370-MS (LASL, 1980), Eq (33).
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S2, Appendix A [C9].

from sage.all import *

def ok(label, cond):
    print(f"  {label}: {'PASS' if cond else 'FAIL'}")
    assert cond

def kron(i, j):
    return 1 if i == j else 0

print("="*70)
print("09_geometry_dependent_uncertainty.sage  (L2-b: Book Eq 6.23)")
print("="*70)

# ----------------------------------------------------------------------------
# Setup: 4D base Minkowski metric eta = (+,-,-,-); Weyl gauge function omega(x).
# (The EM/Weyl gauge sector lives in 4D; the result extends to the 5D manifold.)
# ----------------------------------------------------------------------------
n = 4
xs = list(var('x0 x1 x2 x3'))
eta    = diagonal_matrix(SR, [1, -1, -1, -1])
etinv  = eta.inverse()                       # = eta for Minkowski

omega = function('omega')(*xs)               # Weyl gauge function
phi   = [diff(omega, xs[i]) for i in range(n)]   # gauge potential phi_i = d_i ln f^{1/2}
phi_up = [sum(etinv[a, dd] * phi[dd] for dd in range(n)) for a in range(n)]

f2   = exp(2*omega)                          # conformal factor f = e^{2 omega}
met  = f2 * eta                              # Weyl-rescaled metric  g_{ij}
minv = exp(-2*omega) * etinv                 # inverse metric        g^{ij}

def christoffel(metM, minvM):
    """Levi-Civita symbol {a; bc} = 1/2 g^{ad}(d_b g_{dc} + d_c g_{db} - d_d g_{bc})."""
    Ch = [[[SR(0) for _ in range(n)] for _ in range(n)] for _ in range(n)]
    for a in range(n):
        for b in range(n):
            for c in range(n):
                acc = SR(0)
                for dd in range(n):
                    acc += minvM[a, dd] * (diff(metM[dd, c], xs[b])
                                           + diff(metM[dd, b], xs[c])
                                           - diff(metM[b, c], xs[dd]))
                Ch[a][b][c] = (acc / 2).simplify_full()
    return Ch

def comm_coeff(minvM, Ch):
    """C^{jk} = (1/(i hbar)) [x^j, p^k] = g^{kl}(delta^j_l + Gamma^j_{sl} x^s)."""
    return [[ sum(minvM[k, l] * (kron(j, l)
                  + sum(Ch[j][s][l] * xs[s] for s in range(n)))
                  for l in range(n))
              for k in range(n)] for j in range(n)]

Chr = christoffel(met, minv)

# ----------------------------------------------------------------------------
print("\n(A) Christoffel of the Weyl-conformal metric = the eq-2.8 / Rpt-33 form")
# Weyl connection (eq 2.8) over base eta:  Gamma^a_{bc} = d^a_b phi_c + d^a_c phi_b - eta_{bc} phi^a
weyl_ok = True
for a in range(n):
    for b in range(n):
        for c in range(n):
            predicted = kron(a, b)*phi[c] + kron(a, c)*phi[b] - eta[b, c]*phi_up[a]
            if (Chr[a][b][c] - predicted).simplify_full() != 0:
                weyl_ok = False
                print(f"  mismatch at ({a},{b},{c})")
ok("conformal Christoffel = Weyl gauge form (phi_i = d_i ln f^{1/2})", weyl_ok)

# ----------------------------------------------------------------------------
print("\n(B) Flat / no-gauge limit: canonical commutator recovered")
Chr_flat = [[[SR(0) for _ in range(n)] for _ in range(n)] for _ in range(n)]
C_flat = comm_coeff(etinv, Chr_flat)
flat_ok = all((C_flat[j][k] - etinv[k, j]).simplify_full() == 0
              for j in range(n) for k in range(n))
ok("phi=0  =>  [x^j,p^k] = i hbar g^{kj}  (standard QM commutator)", flat_ok)

# ----------------------------------------------------------------------------
print("\n(C) Vector on (phi != 0): nonzero, phi-sourced correction (PURE GAUGE)")
C_curved = comm_coeff(minv, Chr)
# Delta^{jk} = correction beyond the canonical g^{kj} prefactor
Delta = [[ (C_curved[j][k] - minv[k, j]).simplify_full() for k in range(n)]
         for j in range(n)]

nonzero = any(Delta[j][k] != 0 for j in range(n) for k in range(n))
ok("phi != 0 induces a nonzero commutator correction (Delta != 0)", nonzero)

zero_phi = {phi[i]: 0 for i in range(n)}
vanish_ok = all(Delta[j][k].subs(zero_phi).simplify_full() == 0
                for j in range(n) for k in range(n))
ok("correction is built only from phi: Delta -> 0 when phi_i -> 0", vanish_ok)

# show one component explicitly: the correction is linear in the gauge potential
print("\n  Sample correction term (j=1,k=1), exhibiting its phi-dependence:")
print("    Delta^{11} =", Delta[1][1])

# ----------------------------------------------------------------------------
print("\n" + "-"*70)
print("INTERPRETATION (L2-b -- kinematic identity only):")
print("  The commutator [x^j,p^k] = i hbar g^{kl}(delta^j_l + Gamma^j_{sl} x^s)")
print("  (Book 6.23) is connection-dependent: with a Weyl-conformal metric the")
print("  correction is the eq-2.8 form built from phi_i = d_i omega. But phi here")
print("  is EXACT (d phi = 0) -- the gravitational/integrable (WIST) branch, PURE")
print("  GAUGE, NOT the electromagnetic sector -- and Gamma^j_{sl} x^s is")
print("  COORDINATE-DEPENDENT (nonzero in flat space, curvilinear coords). So this")
print("  is a VERIFIED IDENTITY + the canonical-QM flat limit; it is NOT a")
print("  measurable prediction (no invariant uncertainty observable is derived).")
print("  The earlier strong-gauge/nuclear 'prediction' reading is WITHDRAWN.")
print("="*70)
