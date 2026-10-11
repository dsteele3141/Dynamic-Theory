#!/usr/bin/env sage
# Low-Z (A<=10) nuclear masses vs the semi-empirical mass formula (SEMF):
# validate the SEMF on medium/heavy nuclei, show it is a weak light-nucleus
# baseline, so "beating the SEMF for A<=10" clears a low bar.
#
# Source: P. E. Williams, "The Dynamic Theory" (2009), Ch. 9 Eqs (9.86)-(9.93), p.276.
# Experimental binding energies: AME standard values; SEMF coefficients: Rohlf (1994).
# Full derivation, context and provenance:
#   Supplementary Materials (stand-alone document) — §S3, Appendix A.2 (Book corpus, script 17, B-C3).

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


# --- Semi-empirical (Bethe-Weizsaecker) binding energy [MeV] ----------------
# Rohlf (1994) coefficients.
aV, aS, aC, aA, aP = 15.75, 17.80, 0.711, 23.70, 11.18


def semf_binding(A, Z):
    N = A - Z
    delta = 0.0
    if (Z % 2 == 0) and (N % 2 == 0):
        delta = +aP / sqrt(float(A))
    elif (Z % 2 == 1) and (N % 2 == 1):
        delta = -aP / sqrt(float(A))
    B = (aV * A
         - aS * A**(2.0 / 3.0)
         - aC * Z * (Z - 1) / A**(1.0 / 3.0)
         - aA * (A - 2 * Z)**2 / A
         + delta)
    return float(B)


def rms(errs):
    return float(sqrt(sum(e**2 for e in errs) / len(errs)))


print("=" * 70)
print("NONSTANDARD MODEL C -- low-Z nuclear masses: the SEMF baseline")
print("=" * 70)

# --- (1) Validate the SEMF where it is designed to work --------------------
print("\n[1] SEMF validated on medium/heavy nuclei (where the liquid drop works)")
# (name, A, Z, experimental total binding energy [MeV], AME)
heavy = [("56Fe", 56, 26, 492.254), ("62Ni", 62, 28, 545.259),
         ("120Sn", 120, 50, 1020.545), ("208Pb", 208, 82, 1636.430)]
for name, A, Z, Bexp in heavy:
    Bsemf = semf_binding(A, Z)
    print("    %-6s  B_exp = %8.2f  B_SEMF = %8.2f  err = %+6.2f MeV"
          % (name, Bexp, Bsemf, Bsemf - Bexp))
heavy_errs = [semf_binding(A, Z) - Bexp for _, A, Z, Bexp in heavy]
ok("SEMF reproduces medium/heavy binding energies to a few MeV (RMS < 6 MeV).",
   rms(heavy_errs) < 6.0)

# --- (2) The SEMF is a POOR baseline for light nuclei ----------------------
print("\n[2] SEMF on light nuclei A<=10  (the regime of Williams' claim)")
light = [("2H", 2, 1, 2.22457), ("3H", 3, 1, 8.48182), ("3He", 3, 2, 7.71806),
         ("4He", 4, 2, 28.29567), ("6Li", 6, 3, 31.99452), ("7Li", 7, 3, 39.24454),
         ("9Be", 9, 4, 58.16504), ("10B", 10, 5, 64.75071)]
light_errs = []
for name, A, Z, Bexp in light:
    Bsemf = semf_binding(A, Z)
    light_errs.append(Bsemf - Bexp)
    print("    %-5s A=%2d Z=%d  B_exp = %7.3f  B_SEMF = %7.3f  err = %+7.3f MeV"
          % (name, A, Z, Bexp, Bsemf, Bsemf - Bexp))
rms_light = rms(light_errs)
print("    --> SEMF RMS error over these A<=10 nuclei = %.2f MeV" % rms_light)
print("        (cf. Williams' reported 2.9 MeV for his orbital model)")

ok("SEMF light-nucleus RMS is LARGE (> 3 MeV): a weak baseline for A<=10.",
   rms_light > 3.0)
ok("deuteron (2H) is badly mispredicted by the SEMF (|err| > 5 MeV).",
   abs(semf_binding(2, 1) - 2.22457) > 5.0)
# The SEMF is genuinely worse for light nuclei than for heavy ones:
ok("SEMF is worse for light nuclei than for medium/heavy (RMS_light > RMS_heavy).",
   rms_light > rms(heavy_errs))

# --- (3) Verdict / honesty -------------------------------------------------
print("\n[3] Verdict")
print("    - The SEMF RMS for A<=10 is %.1f MeV, so 'beating the SEMF' here is a" % rms_light)
print("      LOW bar: the liquid-drop model is calibrated for heavy nuclei and")
print("      is not a serious light-nucleus model.")
print("    - Williams' 2.9 MeV is an IN-SAMPLE fit (level energies taken from")
print("      experiment, p.276), not a parameter-free prediction; and his")
print("      Eqs (9.88)-(9.93) are not reproduced verbatim here.")
print("    - A fair test compares against a genuine light-nucleus model")
print("      (ab initio / no-core shell model), NOT the SEMF.  The DT claim is")
print("      PLAUSIBLE but, on the available text, NOT a demonstrated improvement.")

print("\n" + "=" * 70)
print("C COMPLETE: SEMF baseline established; the 'beats SEMF for A<=10' claim")
print("clears a low bar and rests on an in-sample fit.")
print("=" * 70)
