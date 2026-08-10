#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE (primary): P. E. Williams, "The Dynamic Theory: A New View of
#   Space-Time-Matter", Ch. 13 "Quantum Gravity" (p.452): QM applies to ALL
#   isentropic systems regardless of size, so the gravitational Schrodinger
#   equation (with the LARGE gravitational unit of action h_g) is solved for the
#   Sun's planetary orbits; "not all quantum numbers lead to a solution" -> GAPS.
#   The book gives this QUALITATIVELY (no explicit r_n); we test the natural DT
#   analog -- the gravitational Bohr radius from the gateway London quantisation
#   (T2.10): r_n = n^2 h_g^2/(G M m^2)  =>  r_n proportional to n^2.
#   DATA: planetary semi-major axes (AU), standard ephemerides.
# --------------------------------------------------------------------------

# ============================================================================
# 34_quantized_orbits.sage                      [A]  (assertion-hardened)
#
# Big-topic pot shot: ARE PLANETARY ORBITS QUANTISED? DT's quantum-gravity claim,
# tested against the real solar system. The natural DT quantisation (Bohr analog,
# Coulomb coupling e^2/4pi eps0 -> gravitational GMm) is r_n proportional to n^2.
# Test: do the planets land on integer n? Honest expectation: a NEGATIVE -- the
# solar-system spacing is ~geometric (Titius-Bode), not quadratic.
#
# FOLLOW-UPS (deeper tests, refine the verdict to "inconclusive, under-constrained"):
#   34c -- the giants' own moon systems: r~n^2 ladders fit, but w=sqrt(GM/A) is NOT
#          universal (~7x spread) => no single hbar_g; Galileans Laplace-locked.
#   34d -- outer-system spacing = QUANTISATION x MUTUAL HILL RADII together: giants
#          ~8-16 mutual Hill radii apart (feeding), the n^2 ladder indexes those into
#          ~4 empty levels between each giant. Empty orbits are EXPECTED, not a mass
#          shortage (mass peaks at Jupiter). Standard feeding reproduces the spacing
#          without the ladder, so the claim rests only on integer-locking (RMS ~0.15).
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 34_quantized_orbits.sage
# ============================================================================

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


names = ['Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter', 'Saturn', 'Uranus', 'Neptune']
a_AU = [0.387, 0.723, 1.000, 1.524, 5.203, 9.537, 19.191, 30.07]
N = len(a_AU)

print("=" * 70)
print("QUANTISED ORBITS -- DT gravitational-Bohr r_n ~ n^2 vs the real solar system")
print("=" * 70)

# --- (1) anchored fit: Mercury = ground state n0, others follow r_n ~ n^2 ----
print("\n[1] DT quantisation r_n = a1 n^2 ; anchor Mercury at n0, predict the rest")
print("    (n_i = n0 * sqrt(a_i / a_Mercury); a clean quantisation needs integer n_i)")


def fit_n0(n0):
    a1 = a_AU[0] / n0**2
    ns = [n0 * sqrt(a_AU[i] / a_AU[0]) for i in range(N)]
    resid = [float(ns[i] - round(ns[i])) for i in range(N)]
    rms = float(sqrt(sum(x**2 for x in resid) / N))
    return ns, resid, rms


best_rms = None
for n0 in (1, 2, 3, 4):
    ns, resid, rms = fit_n0(n0)
    if best_rms is None or rms < best_rms[1]:
        best_rms = (n0, rms, ns, resid)
n0b, rmsb, nsb, residb = best_rms
print("    best anchor n0 = %d  ->  RMS of (n - nearest integer) = %.3f" % (n0b, rmsb))
for i in range(N):
    print("      %-9s a=%6.2f AU  n=%6.3f  nearest=%2d  resid=%+.3f"
          % (names[i], a_AU[i], nsb[i], round(nsb[i]), residb[i]))

# --- (2) is that a real quantisation, or ~random? ---------------------------
print("\n[2] Significance: compare to the random-spacing expectation")
rms_random = float(1 / sqrt(12))         # uniform residual in [-1/2,1/2] -> RMS 0.289
print("    DT n^2 fit RMS = %.3f ;  random expectation = %.3f" % (rmsb, rms_random))
ok("NOT a clean quantisation: RMS-in-n in (0.1, 0.25); a real one would be <~0.05.",
   0.1 < rmsb < 0.25)
ok("better than random spacing (RMS < 0.289), but only modestly.",
   rmsb < rms_random)
ok("some planets sit far from integer n (Neptune resid ~0.44; max |resid| > 0.3).",
   max(abs(x) for x in residb) > 0.3)

# --- (3) the fit is under-constrained: many empty levels ('gaps') -----------
print("\n[3] The 'gaps': how much freedom does the fit use?")
occ = sorted(int(round(x)) for x in nsb)
span = occ[-1] - occ[0]
gaps = [k for k in range(occ[0], occ[-1] + 1) if k not in occ]
print("    occupied n: %s" % occ)
print("    empty levels (gaps): %s" % gaps)
print("    -> %d planets spread over %d levels (n=%d..%d): ~%.1f levels per planet."
      % (N, span + 1, occ[0], occ[-1], (span + 1) / N))
ok("the fit uses MANY empty levels (span/N > 2) -> under-constrained / numerology-prone.",
   (span + 1) / N > 2)
# the one suggestive note: the inner contiguous gap coincides with the asteroid belt
print("    NOTE: the inner gap n=%d..%d (between Mars and Jupiter) is the ASTEROID"
      % (occ[3] + 1, occ[4] - 1))
print("          BELT region (~2.1-3.3 AU) -- suggestive, but post-hoc given the freedom.")

print("\n  VERDICT (pot shot lands INCONCLUSIVE / numerology-prone, not a clean win):")
print("  DT's natural gravitational-Bohr quantisation r_n ~ n^2 fits the planets")
print("  with RMS %.2f in n -- better than random (0.29) but FAR from a clean" % rmsb)
print("  quantisation (<0.05); Neptune misses by 0.44, and the fit needs a free")
print("  scale, a free ground state, and many empty 'gap' levels. With that much")
print("  freedom the scheme is under-constrained -- the classic quantised-orbit")
print("  numerology. The asteroid-belt-in-a-gap is a fun coincidence but post-hoc.")
print("  So the quantum-gravity 'quantised orbits' claim is NOT cleanly supported")
print("  (the book gives it only qualitatively). Contrast scripts 20/22 (magnetic")
print("  moment, perihelion), which were clean parameter-free wins -- this is not.")

print("\n" + "=" * 70)
print("34 COMPLETE.")
print("=" * 70)
