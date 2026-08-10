#!/usr/bin/env sage
# T2.14 — 5D Schwarzschild (determinant, Ricci/Eq 184-185, 4D embedding)
#
# Source: Williams LA-8370-MS (LASL, 1980), eqs 184-185.
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S3, Appendix A [C3].

from sage.all import *
from sage.manifolds.all import *
import os
import sys


class Tee:
    def __init__(self, *streams):
        self.streams = streams

    def write(self, data):
        for stream in self.streams:
            stream.write(data)
            stream.flush()

    def flush(self):
        for stream in self.streams:
            stream.flush()


def ok(label, cond):
    print("  %s: %s [%s]" % (label, cond, "PASS" if cond else "FAIL"))
    assert cond


print("=" * 70)
print("T2.14 5D Schwarzschild hardened checks")
print("=" * 70)

M = Manifold(5, 'M', structure='Lorentzian')
X.<t, r, th, ph, gm> = M.chart(r't r:(0,+oo) th:(0,pi):\theta ph:(0,2*pi):\phi gm')
mu = function('mu')(r, gm)
lam = function('lam')(r, gm)
nu = function('nu')(r, gm)
g = M.metric('g')
g[0, 0] = exp(mu)
g[1, 1] = -exp(lam)
g[2, 2] = -r^2
g[3, 3] = -(r*sin(th))^2
g[4, 4] = -exp(nu)

print("\n(A) Determinant")
detg = g.determinant().expr().simplify_full()
expected_det = exp(mu + lam + nu) * r^4 * sin(th)^2
print("  det(g) = %s" % detg)
ok("det(g) = exp(mu+lam+nu) r^4 sin(theta)^2", (detg - expected_det).simplify_full() == 0)

print("\n(B) Full Ricci equations and Eq 184/185")
Ric = g.ricci()
R00 = Ric[0, 0].expr().simplify_full()
R11 = Ric[1, 1].expr().simplify_full()
R22 = Ric[2, 2].expr().simplify_full()
R33 = Ric[3, 3].expr().simplify_full()
R44 = Ric[4, 4].expr().simplify_full()
R14 = Ric[1, 4].expr().simplify_full()
print("  R_00 = %s" % R00)
print("  R_11 = %s" % R11)
print("  R_22 = %s" % R22)
print("  R_44 = %s" % R44)
print("  R_{r,gamma} = %s" % R14)
eq184 = exp(-lam) * (1 + (r/2) * (diff(mu, r) + diff(nu, r) - diff(lam, r))) - 1
ratio = (R22 / eq184).simplify_full()
print("  R_22 / Eq184 = %s" % ratio)
ok("R_22 = -Eq184 under Sage curvature sign convention", ratio == -1)
ok("R_33 = sin(theta)^2 R_22", (R33 - sin(th)^2 * R22).simplify_full() == 0)

print("\n(C) Embedded 4D Schwarzschild x R")
Ms = Manifold(5, 'Ms', structure='Lorentzian')
Xs.<ts, rs, ths, phs, gms> = Ms.chart(r'ts rs:(0,+oo) ths:(0,pi):\theta phs:(0,2*pi):\phi gms')
MM = var('M', domain='positive')
f = 1 - 2*MM/rs
gs = Ms.metric('gs')
gs[0, 0] = f
gs[1, 1] = -1/f
gs[2, 2] = -rs^2
gs[3, 3] = -(rs*sin(ths))^2
gs[4, 4] = -1
Rics = gs.ricci()
all_zero = True
for i in range(5):
    for j in range(i, 5):
        comp = Rics[i, j].expr().simplify_full()
        if comp != 0:
            all_zero = False
            print("  R_%d%d = %s [NONZERO]" % (i, j, comp))
ok("All Ricci components vanish for Schwarzschild_4 x R", all_zero)

# SCOPE (finding L3-03): this verifies that the PRODUCT ansatz Schwarzschild_4 x R
# is a Ricci-flat solution of the 5D vacuum equations -- an EXISTENCE/EMBEDDING
# result conditional on that ansatz. It does NOT solve the general 5D field
# equations, prove uniqueness, or derive the slice from DT's time-dependent mass
# potential.
print("\nSummary: embedding check -- Schwarzschild_4 x R is a Ricci-flat solution of")
print("the 5D vacuum ansatz (existence/embedding, not a general solve or uniqueness);")
print("determinant and Eq184 asserted.")
print("=" * 70)
