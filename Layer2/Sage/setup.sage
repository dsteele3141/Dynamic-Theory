#!/usr/bin/env sage
# Sage layer setup + SageManifolds smoke test
#
# Source: P. E. Williams, LA-8370-MS (LASL, 1980).
# Full derivation, context and provenance:
#   Supplementary Materials (stand-alone document) — §S2, Appendix A [C2].
#
# Stands up the SageManifolds pseudo-Riemannian tensor-calculus layer
# (Christoffel, Ricci, Einstein tensor) needed for the curvature items, and
# validates it on a known result: the 4D Schwarzschild metric is Ricci-flat.

import os

_lines = []
def out(s=''):
    print(s)
    _lines.append(str(s))

out('=' * 60)
out('04_sage / 01_setup  —  Sage layer + SageManifolds smoke test')
out('=' * 60)
out('Sage version: ' + sage.version.version)
out('')

# ----------------------------------------------------------------------------
# Smoke test 1: flat 2D metric has zero Ricci scalar
# ----------------------------------------------------------------------------
out('-' * 60)
out('Smoke test 1: flat 2D metric -> Ricci scalar = 0')
out('-' * 60)
M2 = Manifold(2, 'M2')
X2.<x, y> = M2.chart()
g2 = M2.metric('g')
g2[0, 0] = 1
g2[1, 1] = 1
rs = g2.ricci_scalar().expr()
out('  Ricci scalar = %s   [%s]' % (rs, 'OK' if rs == 0 else 'FAIL'))
assert rs == 0
out('')

# ----------------------------------------------------------------------------
# Smoke test 2: 4D Schwarzschild is Ricci-flat  (vacuum Einstein eq R_ij = 0)
#   ds^2 = -(1-2m/r)dt^2 + (1-2m/r)^{-1}dr^2 + r^2 dth^2 + r^2 sin^2(th) dph^2
# This exercises the full Christoffel -> Riemann -> Ricci pipeline that
# T1.9 (Einstein equations from the Weyl action) and T2.14 (5D Schwarzschild)
# depend on.
# ----------------------------------------------------------------------------
out('-' * 60)
out('Smoke test 2: 4D Schwarzschild -> Ricci tensor = 0 (Ricci-flat)')
out('-' * 60)
M = Manifold(4, 'M', structure='Lorentzian')
X.<t, r, th, ph> = M.chart(r't r:(0,+oo) th:(0,pi):\theta ph:(0,2*pi):\phi')
m = var('m', domain='positive')

g = M.metric()
g[0, 0] = -(1 - 2*m/r)
g[1, 1] = 1/(1 - 2*m/r)
g[2, 2] = r^2
g[3, 3] = (r*sin(th))^2

Ric = g.ricci()
all_zero = True
for i in range(4):
    for j in range(i, 4):
        comp = Ric[i, j].expr().simplify_full()
        if comp != 0:
            all_zero = False
            out('  R_{%d%d} = %s   [NONZERO]' % (i, j, comp))
out('  All R_{ij} = 0 (Ricci-flat): %s   [%s]'
    % (all_zero, 'VERIFIED' if all_zero else 'FAIL'))
assert all_zero, 'Schwarzschild not Ricci-flat — SageManifolds setup problem'
out('')

# Bonus: Kretschmann scalar K = R_{abcd}R^{abcd} = 48 m^2 / r^6 (curvature is
# real, only the coordinate singularity at r=2m is removable) — a nontrivial
# curvature invariant, confirming the Riemann tensor is computed correctly.
out('-' * 60)
out('Bonus: Kretschmann scalar K = R_abcd R^abcd')
out('-' * 60)
Riem = g.riemann()
Riem_up = Riem.up(g)
K = (Riem_up['^{abcd}'] * Riem.down(g)['_{abcd}']).expr().simplify_full()
out('  K = %s' % K)
expected_K = 48 * m^2 / r^6
out('  expected 48 m^2 / r^6 ; difference = %s   [%s]'
    % ((K - expected_K).simplify_full(),
       'VERIFIED' if (K - expected_K).simplify_full() == 0 else 'FAIL'))
out('')

out('=' * 60)
out('SAGE LAYER READY')
out('SageManifolds tensor-calculus pipeline validated:')
out('  metric -> Christoffel -> Riemann -> Ricci -> scalar invariants  [OK]')
out('Next Sage target: T1.9 (Weyl variational principle): Weyl-scalar')
out('  expansion R[Weyl] = R[Levi-Civita] + phi-terms (=> 2nd-order EL),')
out('  Maxwell EL from the F^2 term, and the phi_i <-> F_alpha identification.')
out('=' * 60)
