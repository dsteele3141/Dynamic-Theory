#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE (primary): P. E. Williams, "The Dynamic Theory", Ch.13 "Quantum
#   Gravity" -- QM applies to ALL isentropic systems regardless of size, so the
#   gravitational-Bohr quantisation r_n ~ n^2 should hold not only for the Sun's
#   planets (script 34) but INDEPENDENTLY for each giant planet's regular-moon
#   system. DATA: standard satellite/planet ephemerides (semi-major axes, masses).
# --------------------------------------------------------------------------

# ============================================================================
# 34c_moon_system_quantisation.sage             [A]  (assertion-hardened)
#
# NUANCE TEST for the outer solar system (follow-up to script 34). The single
# heliocentric r_n = a1 n^2 fit is mass-INDEPENDENT; DT's London quantisation
# L = m v r = n hbar_g is mass-DEPENDENT. The sharp, INDEPENDENT test is the
# giants' own regular-moon systems: each should be its own gravitational-Bohr
# ladder r_n = A_p n^2, and if ONE universal action underlies them all, the
# derived quantisation velocity  w_p = sqrt(G M_p / A_p)  (Nottale form; = the
# n=1 orbital speed) must be the SAME across the Sun, Jupiter, Saturn, Uranus.
#
# This spends DATA, not parameters: the moons were not used to fit the planets.
#
# Tests: (1) does each system admit an r~n^2 ladder, and how clean (RMS-in-n)?
#        (2) is w_p universal (=> one hbar_g) or per-system (=> under-constrained)?
#        (3) are the ladders confounded by known mean-motion RESONANCES?
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 34c_moon_system_quantisation.sage
# ============================================================================

from sage.all import *

def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label

G   = 6.674e-11
AU  = 1.495978707e11
KMS = 1.0e3

# --- systems: (name, central mass kg, [(moon, a in metres), ...]) ------------
SUN = ("Sun / planets", 1.989e30, [
    ("Mercury",0.387*AU),("Venus",0.723*AU),("Earth",1.000*AU),("Mars",1.524*AU),
    ("Jupiter",5.203*AU),("Saturn",9.537*AU),("Uranus",19.191*AU),("Neptune",30.07*AU)])
JUP = ("Jupiter / Galileans", 1.898e27, [
    ("Io",4.218e8),("Europa",6.711e8),("Ganymede",1.0704e9),("Callisto",1.8827e9)])
SAT = ("Saturn / major regular", 5.683e26, [
    ("Mimas",1.8554e8),("Enceladus",2.3804e8),("Tethys",2.9467e8),("Dione",3.7742e8),
    ("Rhea",5.2707e8),("Titan",1.22187e9),("Iapetus",3.56084e9)])
URA = ("Uranus / major", 8.681e25, [
    ("Miranda",1.2939e8),("Ariel",1.909e8),("Umbriel",2.66e8),("Titania",4.363e8),
    ("Oberon",5.835e8)])
SYSTEMS = [SUN, JUP, SAT, URA]
# Neptune is EXCLUDED: Triton is a captured (retrograde) moon that disrupted the
# regular satellite system, so it is not a clean formation-ladder test.

RANDOM_RMS = 1.0/sqrt(12.0)      # ~0.289, uniform |resid| baseline


def fit_ladder(rs, n0max=12):
    """Best integer ground state n0 for r_n = A n^2; return (n0, ns, rms, A)."""
    best = None
    for n0 in range(1, n0max+1):
        ns   = [n0*sqrt(r/rs[0]) for r in rs]
        rms  = sqrt(sum((x-round(x))**2 for x in ns)/len(ns))
        if best is None or rms < best[2]:
            best = (n0, ns, float(rms), rs[0]/n0**2)
    return best


print("="*72)
print("34c  MOON-SYSTEM QUANTISATION -- is r~n^2 universal across the giants?")
print("="*72)

results = []
for name, M, moons in SYSTEMS:
    rs = [a for _, a in moons]
    n0, ns, rms, A = fit_ladder(rs)
    w = sqrt(G*M/A)                       # n=1 orbital speed = Nottale velocity
    results.append((name, M, rms, w, n0, ns, moons))
    print("\n--- %s  (M = %.3e kg) ---" % (name, M))
    print("    best n0 = %d ; RMS-in-n = %.3f (random ~%.3f) ; w = %.1f km/s"
          % (n0, rms, float(RANDOM_RMS), w/KMS))
    for (nm,_), nv in zip(moons, ns):
        print("      %-9s n = %6.3f  -> nearest %2d  (resid %+0.3f)"
              % (nm, nv, round(nv), nv-round(nv)))

# --- (1) each system admits a modest (not clean) ladder ---------------------
print("\n[1] Ladder quality per system")
for name, M, rms, w, n0, ns, moons in results:
    ok("%s: RMS-in-n = %.3f is in the numerology band (>0.05, not a clean "
       "quantisation)" % (name, rms), rms > 0.05)

# --- (1b) method validation + the n0/w degeneracy ---------------------------
print("\n[1b] Formula check and the n0-degeneracy of w")
a_merc = SUN[2][0][1]
w_sun_n0_3 = sqrt(G*SUN[1]/(a_merc/3**2))     # Nottale's canonical Mercury=3 anchor
print("    Sun with Mercury pinned at n0=3 (script 34 / Nottale): w = %.1f km/s"
      % (w_sun_n0_3/KMS))
print("    Sun at the min-RMS anchor n0=%d (broader scan): w = %.1f km/s"
      % (results[0][4], results[0][3]/KMS))
ok("formula validated: Mercury=3 anchor reproduces Nottale's ~144 km/s.",
   130*KMS < w_sun_n0_3 < 160*KMS)
ok("w is NOT uniquely determined even for the Sun: the min-RMS anchor (n0=%d) "
   "gives a different w than the n0=3 anchor -> the ground state is not pinned "
   "(under-constraint, in the fit itself)." % results[0][4],
   abs(results[0][3] - w_sun_n0_3) > 0.1*w_sun_n0_3)

# --- (2) is the quantisation velocity w universal? --------------------------
print("\n[2] Universality of the quantisation velocity w = sqrt(GM/A)")
ws = [w for _,_,_,w,_,_,_ in results]
spread = max(ws)/min(ws)
print("    w (km/s, min-RMS anchor): " + ", ".join(
    "%s=%.0f" % (r[0].split('/')[0].strip(), r[3]/KMS) for r in results))
print("    spread max/min = %.2fx" % spread)
ok("w is NOT universal across systems (spread > 2x) -> each system needs its OWN "
   "constant; a single hbar_g is not supported.", spread > 2.0)
# even taking the Sun at its LOWEST plausible w (n0=3, 144 km/s), Uranus is far below
ok("non-universality is robust to the anchor: even Sun@n0=3 (144) vs Uranus (%.0f) "
   "exceeds 2x." % (results[3][3]/KMS), w_sun_n0_3/results[3][3] > 2.0)

# --- (3) resonance confound: the Galileans are Laplace-locked ---------------
print("\n[3] Resonance confound (spacing set by dynamics, not quantisation)")
io, eu, ga, ca = [a for _,a in JUP[2]]
# Kepler: P ~ a^{3/2}; consecutive period ratios for the inner 3 Galileans
pr_eu_io = (eu/io)**1.5
pr_ga_eu = (ga/eu)**1.5
print("    Galilean period ratios: Europa/Io = %.3f , Ganymede/Europa = %.3f"
      % (pr_eu_io, pr_ga_eu))
ok("Io:Europa:Ganymede sit in the 4:2:1 LAPLACE resonance (period ratios ~2), "
   "so their spacing is dynamically locked -- NOT free evidence for quantisation.",
   abs(pr_eu_io-2.0) < 0.05 and abs(pr_ga_eu-2.0) < 0.05)

print("\n" + "-"*72)
print("VERDICT")
print("-"*72)
print("The moon systems do NOT rescue the quantised-orbit picture to a clean win:")
print("  * each giant's regular moons CAN be laid on an r~n^2 ladder, but only at")
print("    the same modest RMS (~0.14-0.21) as the planets -- numerology band, not <0.05;")
print("  * the derived quantisation velocity w is NOT universal: at the min-RMS anchor")
print("    Sun~239, Jupiter~139, Saturn~100, Uranus~33 km/s (spread ~7x); even taking")
print("    the Sun at its Mercury=3 value (144) vs Uranus (33) is >4x. A single")
print("    hbar_g does not fit all systems -- each carries its OWN fitted constant;")
print("  * w is not even pinned WITHIN the Sun: the ground state n0 is degenerate")
print("    (n0=3 -> 144 km/s, min-RMS n0=5 -> 239 km/s), so the 'constant' floats;")
print("  * the sharpest sub-system (the Galileans) has its spacing FIXED by the 4:2:1")
print("    Laplace mean-motion resonance -- a standard dynamical mechanism, so it")
print("    cannot be counted as independent evidence for quantisation.")
print("NET: adding the moon data (more constraint, not more parameters) leaves the")
print("verdict INCONCLUSIVE and, if anything, strengthens the under-constrained")
print("reading. A universal gravitational action is not supported by the satellites.")
print("(Honest note: Jupiter ~139 sitting near the Sun's Mercury=3 value ~144 is the")
print("one mild coincidence -- but Saturn/Uranus break it, and the n0 freedom lets w")
print("drift, so it is not evidence for a shared constant.)")
print("="*72)
print("34c COMPLETE.")
print("="*72)
