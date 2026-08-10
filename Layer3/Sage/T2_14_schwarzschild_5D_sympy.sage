#!/usr/bin/env sage
# T2.14 — 5D Schwarzschild (determinant, Christoffel, Ricci/Eq 184-185, 4D embedding)
#
# Source: Williams LA-8370-MS (LASL, 1980), eqs 184-185.
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S3, Appendix A [C3].

from sage.all import *
from sage.manifolds.all import *

def ok(label, cond):
    print(f"  {label}: {'PASS' if cond else 'FAIL'}")
    assert cond

print("="*70)
print("18_schwarzschild_5D_adjudicated.sage")
print("="*70)

M = Manifold(5, 'M', structure='Lorentzian')
X = M.chart(r't r th:\theta ph:\phi gm:\gamma')
t, r, th, ph, gm = X[:]

mu = function('mu')(r, gm)
lam = function('lam')(r, gm)
nu = function('nu')(r, gm)

g = M.metric('g')
g[0, 0] = exp(mu)
g[1, 1] = -exp(lam)
g[2, 2] = -r^2
g[3, 3] = -r^2 * sin(th)^2
g[4, 4] = -exp(nu)

print("\n(A) Metric determinant Audit (Page 163)")
det_g = g.determinant().expr().simplify_full()
det_expected = exp(mu + lam + nu) * r^4 * sin(th)^2
ok("det(g) = exp(mu+lam+nu) r^4 sin(theta)^2", (det_g - det_expected).simplify_full() == 0)
print("  Note: Manuscript Page 163 prints sin^-2(theta), confirmed as transcription error.")

print("\n(B) Christoffel Typo Audit (Page 164)")
Gamma = g.connection()
G_th_th_r = Gamma[2, 2, 1].expr().simplify_full()
G_r_th_r = Gamma[1, 2, 1].expr().simplify_full()
ok("Gamma^theta_{theta r} = 1/r", (G_th_th_r - 1/r).simplify_full() == 0)
ok("Gamma^r_{theta r} = 0", G_r_th_r == 0)
print("  Note: Manuscript Page 164 prints {1_21} = 1/r; confirmed index typo.")

print("\n(C) Ricci Field Equations (Eq 184-185)")
Ric = g.ricci()
R22 = Ric[2, 2].expr().simplify_full()
R33 = Ric[3, 3].expr().simplify_full()

mu_r = diff(mu, r); lam_r = diff(lam, r); nu_r = diff(nu, r)
eq184 = exp(-lam) * (1 + r/2 * (mu_r + nu_r - lam_r)) - 1

ok("R_22 equals -Eq184", (R22 + eq184).simplify_full() == 0)
ok("Eq 185 is redundant (R33 = sin^2 * R22)", (R33 - sin(th)^2 * R22).simplify_full() == 0)

print("\n(D) 4D Schwarzschild Embedding")
Ms = Manifold(5, 'Ms', structure='Lorentzian')
Xs = Ms.chart(r'ts rs ths phs gms')
ts, rs, ths, phs, gms = Xs[:]
mass = var('mass', domain='positive')
fs = 1 - 2*mass/rs

gs = Ms.metric('gs')
gs[0, 0] = fs
gs[1, 1] = -1/fs
gs[2, 2] = -rs^2
gs[3, 3] = -rs^2 * sin(ths)^2
gs[4, 4] = -1

Rics = gs.ricci()
all_zero = True
for i in range(5):
    for j in range(i, 5):
        if Rics[i, j].expr().simplify_full() != 0:
            all_zero = False
ok("All Ricci components vanish for Schwarzschild_4 x R", all_zero)

print("\nSummary: 5D Schwarzschild limit and manuscript typos verified.")
print("="*70)
