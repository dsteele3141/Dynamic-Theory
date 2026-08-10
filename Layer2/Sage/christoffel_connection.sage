#!/usr/bin/env sage
# Christoffel connection, Riemann antisymmetry, and Weyl identity (Eq 33)
#
# Source: P. E. Williams, LA-8370-MS (LASL, 1980), eq (33).
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S2, Appendix A [C2].

from sage.all import *

def ok(label, cond):
    print(f"  {label}: {'PASS' if cond else 'FAIL'}")
    assert cond

def to_sr(x):
    return x.expr() if hasattr(x, 'expr') else SR(x)

n = 4
M = Manifold(n, 'M')
X = M.chart(' '.join(['x%d' % i for i in range(n)]))
coords = X[:]

print("="*70)
print("04_christoffel_connection_adjudicated.sage")
print("="*70)

print("\n(A) Symmetry of Levi-Civita coefficients, hence of Williams Gamma=-{}")
g_full = M.metric('g_full')
for i in range(n):
    for j in range(i, n):
        g_full[i, j] = function('g%d%d' % (i, j))(*coords)
Gamma_full = g_full.connection().coef()

all_symm = True
for k in range(n):
    for i in range(n):
        for j in range(i+1, n):
            if to_sr(Gamma_full[k, i, j] - Gamma_full[k, j, i]).simplify_full() != 0:
                all_symm = False
ok("Gamma^k_ij = Gamma^k_ji for all indices", all_symm)

print("\n(B) Riemann first-pair antisymmetry (Diagonal Metric Case)")
gd = M.metric('gd')
for i in range(n):
    gd[i, i] = function('gd%d%d' % (i, i))(*coords)
Gamma = gd.connection().coef()

def get_riemann_from_gamma(gamma_field):
    R = M.tensor_field(1, 3, 'R')
    for l in range(n):
        for i in range(n):
            for j in range(n):
                for k in range(n):
                    R[l, i, j, k] = (
                        diff(gamma_field[l, i, k], coords[j])
                        - diff(gamma_field[l, i, j], coords[k])
                        + sum(gamma_field[l, j, s] * gamma_field[s, i, k] for s in range(n))
                        - sum(gamma_field[l, k, s] * gamma_field[s, i, j] for s in range(n))
                    )
    return R

R = get_riemann_from_gamma(Gamma)

all_antisymm = True
for a in range(n):
    for b in range(n):
        for c in range(n):
            for d in range(n):
                Rabcd = gd[a, a] * R[a, b, c, d]
                Rbacd = gd[b, b] * R[b, a, c, d]
                if to_sr(Rabcd + Rbacd).simplify_full() != 0:
                    all_antisymm = False
ok("R_abcd = -R_bacd for all 256 diagonal-metric components", all_antisymm)

print("\n(C) Weyl/Conformal Connection Identity (Eq 33)")
f = function('f')(*coords)
phi = [1/2 * diff(log(f), coords[k]) for k in range(n)]

def weyl_correction(met, met_inv, phi_vec, i, j, k):
    return sum(met_inv[i, l] * (
        met[l, j]*phi_vec[k] + met[l, k]*phi_vec[j] - met[j, k]*phi_vec[l]
    ) for l in range(n))

gd_sigma = M.metric('gd_sigma')
gd_sigma[:] = (f * gd)[:]
Gamma_sigma = gd_sigma.connection().coef()
gd_inv = gd.inverse()

eq33_pass = True
for i in range(n):
    for j in range(n):
        for k in range(n):
            # Williams: hat_hat_Gamma = -{g} - WeylCorrection
            formula = -Gamma[i, j, k] - weyl_correction(gd, gd_inv, phi, i, j, k)
            direct = -Gamma_sigma[i, j, k]
            if to_sr(formula - direct).simplify_full() != 0:
                eq33_pass = False
ok("Eq 33 Williams convention checked for all 64 components", eq33_pass)

print("\nSummary: Riemannian properties and Weyl identity verified without sampling.")
print("="*70)
