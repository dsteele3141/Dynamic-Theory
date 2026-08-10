#!/usr/bin/env sage
# Prediction P1 -- reduced radiation pressure: postdict the Nichols & Hull ratio
# (0.99433) from the 5D ratio p/xi = (1+n^2-(A0/w)^2)/(1+n^2+(A0/w)^2), and fix
# the DT constant a0. The shock-wave figure is a CONSISTENCY comparison, not an
# independent determination (see note below).
#
# NOTE (2026-07-27) -- what the datum actually fixes. The ratio depends only on the
# product A0 = a0 c k4, so one measurement cannot fix a0 and k4 separately; the
# split needs an outside input. The Book's own numbers show which way it ran:
# k4 = A0/(c a0) with the Ch.7 shock a0 = 3.65e7 gives 0.0037213, reproducing the
# printed k4 = 0.0037186 to 0.07%. So a0 came from the SHOCK data and k4 was
# back-solved from the radiation pressure, though the Book presents both as if they
# emerged together ("now we have an estimate for both a0 and k4"). Check [4] is
# therefore a consistency check on one recycled number: do NOT cite it as two
# independent experiments agreeing. k4 is the wave's wavenumber along the mass axis
# (hence m^3/kg, so that k4*gamma is dimensionless), not a coupling constant.
#
# Source: P. E. Williams, "The Dynamic Theory" (2009), Ch. 11 Eqs ~(11.74)-(11.80), pp.357-365.
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S3, Appendix A.2 (Book corpus, script 18, B-C4).

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


def rel(a, b):
    return abs(float(a) - float(b)) / abs(float(b))


print("=" * 70)
print("PREDICTION P1 -- reduced radiation pressure & the fixing of a0 (Book)")
print("=" * 70)

# --- Book / experimental inputs --------------------------------------------
c_light = 2.99792458e8     # m/s
k4 = 0.0037186             # m^3/kg            (Book, vacuum)
A0_rp = 40.72e12           # s^-1  = a0 c k4   (Book, from radiation pressure)
f_white = 540e12           # Hz                (Book: white light, 540 THz)
n_air = 1                  # index of refraction (air)
ratio_NH = 0.99433         # Nichols & Hull p/xi (Suhre 2000 report)
a0_shock = 3.65e7          # kg/m^4            (Book Ch.7, shock-wave fit)


def pratio(A0, w, n):
    x = (A0 / w)**2
    B = 1 + n**2
    return (B - x) / (B + x)


# --- (1) Forward postdiction -> Nichols & Hull 0.99433 ---------------------
print("\n[1] Forward: 5D ratio with the Book's a0 reproduces Nichols & Hull")
ratio_pred = pratio(A0_rp, f_white, n_air)
print("    p/xi (A0=40.72e12 s^-1, w=540 THz, n=1) = %.6f   (measured 0.99433)"
      % ratio_pred)
ok("predicted p/xi matches Nichols & Hull 0.99433 (to 1e-4).",
   abs(ratio_pred - ratio_NH) < 1e-4)

# --- (2) Inverse: recover A0 from the measured ratio -----------------------
print("\n[2] Inverse: solve the measured ratio for A0 (round trip)")
B = 1 + n_air**2
x_sol = B * (1 - ratio_NH) / (1 + ratio_NH)     # = (A0/w)^2
A0_sol = f_white * sqrt(x_sol)
print("    A0 from ratio = %.4g s^-1   (Book: 40.72e12 s^-1)" % float(A0_sol))
ok("inverse-solved A0 returns 40.72e12 s^-1 (within 1%).",
   rel(A0_sol, A0_rp) < 0.01)

# --- (3) a0 fixed from the radiation-pressure data -------------------------
print("\n[3] a0 = A0/(c k4) from the radiation-pressure determination")
a0_rp = A0_rp / (c_light * k4)
print("    a0 = %.4g kg/m^4   (Book states 3.65e7 kg/m^4)" % a0_rp)
ok("a0 = A0/(c k4) = 3.65e7 kg/m^4 (within 2%).", rel(a0_rp, 3.65e7) < 0.02)

# --- (4) Two independent experiments agree on a0 ---------------------------
print("\n[4] Consistency: radiation pressure vs shock waves")
print("    (NOT independent -- k4 was back-solved from a0; see the header NOTE)")
print("    a0 (radiation pressure) = %.4g kg/m^4" % a0_rp)
print("    a0 (shock waves, Ch.7)  = %.4g kg/m^4" % a0_shock)
ok("radiation-pressure and shock-wave figures agree (within 2%) -- consistency, "
   "NOT independence (see the header NOTE).",
   rel(a0_rp, a0_shock) < 0.02)

# --- (5) Correspondence: a0 -> 0 recovers ordinary radiation pressure ------
print("\n[5] Correspondence: a0 -> 0 (A0 -> 0) gives p/xi -> 1")
w = var('w', domain='positive')
A0s = var('A0s', domain='positive')
ratio_sym = (1 + n_air**2 - (A0s / w)**2) / (1 + n_air**2 + (A0s / w)**2)
ok("p/xi -> 1 as A0 -> 0 (ordinary radiation pressure recovered).",
   (limit(ratio_sym, A0s=0) == 1))

print("\n  NET: P1 is a machine-checked POSTDICTION of the Nichols & Hull ratio,")
print("  and it fixes the product A0 = a0 c k4 = 40.72e12 s^-1. With the Book's")
print("  vacuum k4 this gives the DT constant a0 ~ 3.65e7 kg/m^4, the constant the")
print("  Report-scoped SI leaves open -- consistent with, but not independent of,")
print("  the Ch.7 shock-wave figure. (Book-sourced; not in the 1980 Report.)")

print("\n" + "=" * 70)
print("P1 COMPLETE: reduced radiation pressure postdicts 0.99433; a0 fixed.")
print("=" * 70)
