#!/usr/bin/env sage
# T2.6 — Self-Energy of a Charged Particle (Finite Result)  [prediction P3]
#
# Source: Williams LA-8370-MS (1980), Section III, pages 103-110, eqs (79)-(104).
# Full derivation, context and provenance:
#   Supplementary Materials (stand-alone document) — §S3, Appendix A [C7].
#
# ============================================================================
# Claim: classical/4D EM gives a DIVERGENT self-energy, but the 5D Dynamic Theory
# gives a FINITE one — the V-field term competes with the Coulomb term and the
# free energy G(R) has a minimum at a finite radius R0. This pass adds:
#   (1) the LIMIT structure exposing the mechanism: 4D G -> -inf as R->0 (Coulomb
#       collapse), but 5D G -> +inf as R->0 (the V-field ~R^{-4} wall), so a
#       finite minimum must exist;
#   (2) a genuine SECOND-ORDER test: G''(R0) > 0, i.e. R0 is a STABLE minimum;
#   (3) exact R0 and G_min, plus a dimensionless NUMERIC evaluation tabulating
#       G(R) to exhibit the minimum.
#
# Model (eqs 100-103): uniform sphere gamma = 3m/(4 pi R^3), V0 = k/R, giving
#   G(R) = -e^2/(4 pi eps0 R) + 3 e m k/(4 pi a0 R^4) + G0 .
# ============================================================================

_lines = []
def out(s=''):
    print(s); _lines.append(str(s))

out('=' * 70)
out('T2.6 — Finite self-energy of a charged particle (prediction P3)')
out('=' * 70)
out('')

# Positive physical/model constants
var('R e eps0 m k a0 G0', domain='positive')
assume(R > 0)

# 4D (classical) and 5D (Dynamic Theory) free energy G(R)
G4 = -e^2/(4*pi*eps0*R) + G0
G5 = -e^2/(4*pi*eps0*R) + 3*e*m*k/(4*pi*a0*R^4) + G0

# ----------------------------------------------------------------------------
# (1) Limit structure — the mechanism
# ----------------------------------------------------------------------------
out('-' * 70)
out('(1) Limits as R -> 0+ : Coulomb collapse (4D) vs V-field wall (5D)')
out('-' * 70)
lim4_0 = limit(G4 - G0, R=0, dir='+')
lim5_0 = limit(G5 - G0, R=0, dir='+')
lim5_inf = limit(G5 - G0, R=oo)
out('  4D:  lim_{R->0+} (G-G0) = %s   (Coulomb self-energy DIVERGES to -inf)' % lim4_0)
out('  5D:  lim_{R->0+} (G-G0) = %s   (V-field ~R^{-4} wall: G -> +inf)' % lim5_0)
out('  5D:  lim_{R->inf} (G-G0) = %s   (assembled charge dispersed)' % lim5_inf)
out('  => 5D G(R) comes down from +inf, so it must attain a finite minimum.')
assert lim4_0 == -oo and lim5_0 == +oo and lim5_inf == 0
out('')

# ----------------------------------------------------------------------------
# (2) Critical radius R0, and the SECOND-ORDER (stable-minimum) test
# ----------------------------------------------------------------------------
out('-' * 70)
out('(2) Stationary radius R0 and stability G\'\'(R0) > 0')
out('-' * 70)
dG = diff(G5, R)
R0 = (12*m*k*eps0/(e*a0))^(1/3)        # eq (103)
out('  R0 = (12 m k eps0 /(e a0))^(1/3)')
chk = (dG.subs(R=R0)).simplify_full()
out('  G\'(R0) = %s   (critical point): %s' % (chk, chk == 0))
assert chk == 0

d2G = diff(G5, R, 2)
d2G_R0 = (d2G.subs(R=R0)).simplify_full()
out('  G\'\'(R0) = %s' % d2G_R0)
pos = bool(d2G_R0 > 0)
out('  G\'\'(R0) > 0 (R0 is a STABLE MINIMUM, not just a critical point): %s' % pos)
assert pos
out('')

# ----------------------------------------------------------------------------
# (3) Finite minimum free energy G_min  (eq 104)
# ----------------------------------------------------------------------------
out('-' * 70)
out('(3) Finite minimum free energy  G_min = G0 - 3 e^2/(16 pi eps0 R0)')
out('-' * 70)
Gmin = (G5.subs(R=R0)).simplify_full()
Gmin_expected = G0 - 3*e^2/(16*pi*eps0*R0)
diff_min = (Gmin - Gmin_expected).simplify_full()
out('  G(R0)                     = %s' % Gmin)
out('  G0 - 3 e^2/(16 pi eps0 R0): difference = %s   [%s]'
    % (diff_min, 'VERIFIED' if diff_min == 0 else 'FAIL'))
assert diff_min == 0
out('  FINITE: R0 > 0 finite => G_min finite. (4D self-energy is divergent.)')
out('')

# ----------------------------------------------------------------------------
# (4) Dimensionless numeric demonstration (e=eps0=m=k=a0=1)
# ----------------------------------------------------------------------------
out('-' * 70)
out('(4) Numeric demonstration (dimensionless units e=eps0=m=k=a0=1)')
out('-' * 70)
sub1 = {e: 1, eps0: 1, m: 1, k: 1, a0: 1, G0: 0}
R0n = (R0.subs(sub1)).n()
Gminn = (Gmin.subs(sub1)).n()
out('  R0    = %s   (= 12^(1/3))' % R0n)
out('  G_min = %s   (finite, < 0 = G0)' % Gminn)
out('  G(R) - G0  sampled around the minimum:')
G5n = (G5 - G0).subs(sub1)
for Rv in [0.5, 1.0, 1.5, R0n, 3.0, 5.0, 10.0]:
    out('    R = %5.3f :  G-G0 = %+.5f' % (float(Rv), float(G5n.subs(R=Rv))))
out('  (minimum sits at R0 = %.4f, as predicted)' % float(R0n))
out('')

out('=' * 70)
out('T2.6 SUMMARY (prediction P3 — finite self-energy):')
out('  (1) 4D G -> -inf as R->0 (divergent); 5D G -> +inf (V-field wall).      [OK]')
out('  (2) R0 = (12 m k eps0/(e a0))^(1/3) is a STABLE minimum, G\'\'(R0) > 0.   [OK]')
out('  (3) G_min = G0 - 3 e^2/(16 pi eps0 R0)  — FINITE.                        [OK]')
out('  (4) numeric check: finite R0, finite G_min, minimum exhibited.          [OK]')
out('  SCOPE (finding L3-05): this is a stable minimum for the SUPPLIED')
out('  uniform-sphere free-energy ansatz -- NOT a general self-energy theorem.')
out('  The ansatz and its term signs are inputs: the R^-1 term is a NEGATIVE')
out('  binding term (not the usual POSITIVE classical EM field self-energy); it')
out('  is the R^-4 V-field term, not a regularised Coulomb field energy, that')
out('  supplies finiteness. Not derived from the 5D field equations here.')
out('     (R0, G_min scale with the DT constant a0, still to be fixed by expt.)')
out('=' * 70)
