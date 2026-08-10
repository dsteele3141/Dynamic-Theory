#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE: P. E. Williams, "The Dynamic Theory" (DT.tex) Ch.11 "Five Dimensional
#   Waves" (Eqs 11.24, 11.74-11.130) and the "What's New" sections "Five
#   Dimensional Waves" / "Zero Pressure Radiation". Book-primary (NOT in the
#   1980 Report); kept out of the public-domain SI, pointer in SI-6.3.11.
#   Builds directly on script 18 (P1, which fixed A0 = a0 c k4 = 40.72e12 /s
#   from the Nichols & Hull radiation-pressure experiment, optical, n=1).
# --------------------------------------------------------------------------

# ============================================================================
# 36_electrogravitic_wave_polarization.sage     [A]  (assertion-hardened)
#
# THE POT SHOT (5D / "electrogravitic" waves).  DT's eight 5D field equations
# give wave equations in TEN field components, not Maxwell's transverse-only
# two. Beyond the ordinary transverse light wave there is a NEW NON-TRANSVERSE
# mode -- the vector components lie ALONG the propagation direction (Williams:
# "Perhaps it should be called an electrogravitic wave ... made up of electric
# and gravitational components"). So DT predicts an EXTRA, longitudinal wave
# polarization beyond the transverse modes of Maxwell (2) and GR (2 tensor).
#
# A longitudinal mode is a SHARP, TESTABLE departure, and DT makes it numeric:
# the radiation-pressure-to-energy-density ratio becomes FREQUENCY DEPENDENT,
#       p/xi = (1 + n^2 - (A0/w)^2) / (1 + n^2 + (A0/w)^2),   A0 = a0 c k4,
# with A0 = 40.72e12 /s FIXED (script 18) by Nichols & Hull at optical w.
# Williams embraces the consequence in a section titled "Zero Pressure
# Radiation": there is a frequency where p/xi = 0. This script follows that
# curve OUTWARD from the optical fit and asks what it predicts elsewhere.
#
# RESULT: with A0 fixed, p/xi crosses zero at ~29 THz (lambda ~ 10 um, mid-IR)
# and goes NEGATIVE for all longer wavelengths -- far-IR, microwave, radio, and
# the CMB (p/xi -> -1, i.e. w = -1). That is excluded: microwave/radio
# radiation pressure is measured POSITIVE (it underwrites power standards and
# optical tweezers), and the CMB is radiation with w = +1/3 (acoustic peaks).
# So the longitudinal-mode prediction, taken with its OWN fitted constant, is
# FALSIFIED at long wavelength -- a clean negative result on DT's own equation.
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 36_electrogravitic_wave_polarization.sage
# ============================================================================

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


# --- DT constants (Book, via script 18) -------------------------------------
c    = 2.99792458e8        # m/s
A0   = 40.72e12            # s^-1  = a0 c k4, FIXED by Nichols & Hull (script 18)
n    = 1.0                 # vacuum / air refractive index (the N&H condition)
w_NH = 540.0e12            # s^-1, white light used by Nichols & Hull
ratio_NH = 0.99433         # measured p/xi (Suhre 2000)


def p_over_xi(w, nn=n):
    """DT 5D radiation-pressure-to-energy-density ratio (Eq 11.74-form)."""
    x = (A0 / w) ** 2
    return (1 + nn**2 - x) / (1 + nn**2 + x)


print("=" * 70)
print("ELECTROGRAVITIC (longitudinal) WAVE -- a frequency-dependent radiation")
print("pressure, followed from the optical fit outward")
print("=" * 70)

# --- (0) the extra polarization exists in the field content -----------------
print("\n[0] DT's wave content vs Maxwell / GR")
print("    Maxwell light: 2 transverse polarizations.  GR waves: 2 tensor.")
print("    DT: 8 field eqs -> 10 components, incl. a NON-TRANSVERSE mode whose")
print("    vector lies ALONG k (Williams' 'electrogravitic wave').  -> extra")
print("    longitudinal polarization carrying the gravitational V-component.")

# --- (1) correspondence: A0 -> 0 recovers ordinary radiation pressure -------
print("\n[1] Correspondence limit")
r_corr = (1 + n**2 - 0) / (1 + n**2 + 0)
print("    A0 -> 0  =>  p/xi -> %.4f  (ordinary transverse radiation)" % r_corr)
ok("A0 -> 0 recovers the ordinary p/xi = 1 (no longitudinal reduction).",
   abs(r_corr - 1.0) < 1e-12)

# --- (2) reproduce the Nichols & Hull optical fit (ties to script 18) -------
print("\n[2] Optical anchor (Nichols & Hull, w = 540 THz, n = 1)")
r_opt = p_over_xi(w_NH)
print("    predicted p/xi = %.5f   vs measured %.5f" % (r_opt, ratio_NH))
ok("with A0 = 40.72e12/s the optical ratio reproduces N&H 0.99433 (<1e-4).",
   abs(r_opt - ratio_NH) < 1e-4)
ok("the optical reduction is tiny but real (longitudinal fraction ~0.6%).",
   0.99 < r_opt < 1.0)

# --- (3) Williams' 'Zero Pressure Radiation' frequency ----------------------
print("\n[3] The zero-pressure frequency (Williams' own 'Zero Pressure Radiation')")
# p/xi = 0  <=>  (A0/w)^2 = 1 + n^2
w0  = A0 / sqrt(1 + n**2)
lam0 = c / float(w0)
print("    p/xi = 0 at w0 = A0/sqrt(1+n^2) = %.3e /s  (%.1f THz)" % (float(w0), float(w0)/1e12))
print("    -> wavelength lambda0 = c/w0 = %.2e m  (%.1f um, mid-infrared)" % (lam0, lam0*1e6))
ok("there is a finite zero-pressure frequency (Williams' claim) ~29 THz.",
   abs(p_over_xi(w0)) < 1e-9)
ok("the zero-pressure wavelength is in the mid-IR (~10 um), not exotic.",
   5e-6 < lam0 < 20e-6)

# --- (4) below it: NEGATIVE radiation pressure, down to w = -1 --------------
print("\n[4] Longer wavelengths: the ratio goes NEGATIVE and -> -1")
probes = [
    ("mid-IR  30 THz",   30.0e12),
    ("far-IR   3 THz",    3.0e12),
    ("CMB peak 160 GHz",  160.2e9),
    ("microwave 10 GHz",  10.0e9),
    ("radio    100 MHz",  100.0e6),
]
for name, w in probes:
    print("    %-18s p/xi = %+.4f" % (name, p_over_xi(w)))
ok("for w < w0 the predicted radiation pressure is NEGATIVE.",
   p_over_xi(3.0e12) < 0 and p_over_xi(10.0e9) < 0)
ok("toward low frequency p/xi -> -1 (equation of state w = -1).",
   abs(p_over_xi(100.0e6) - (-1.0)) < 1e-3)
ok("the CMB (160 GHz) is predicted at p/xi ~ -1, NOT the radiation +1/3.",
   p_over_xi(160.2e9) < -0.99)

# --- (5) the falsification -------------------------------------------------
print("\n[5] Confrontation with measurement")
print("    Measured radiation pressure is POSITIVE across the spectrum:")
print("      - microwave/radio pressure underwrites laser-power standards and")
print("        radiometry; cavity & antenna forces are positive and classical;")
print("      - the CMB is radiation with w = +1/3 (acoustic-peak cosmology),")
print("        not w = -1.")
print("    DT (with its own Nichols&Hull-fixed A0) predicts p/xi < 0 for every")
print("    lambda > ~10 um.  These disagree by O(1) -- a falsification, not a")
print("    tension.")
# encode the contradiction as the test: DT sign vs the empirical (positive) sign
dt_sign_microwave = sign(p_over_xi(10.0e9))
empirical_sign    = +1
ok("DT's long-wavelength pressure sign CONTRADICTS the measured (+) sign.",
   dt_sign_microwave != empirical_sign)

print("\n" + "-" * 70)
print("VERDICT")
print("-" * 70)
print("POSITIVE: DT makes a genuine, sharp, NEW prediction -- a non-transverse")
print("  electrogravitic wave (an extra longitudinal polarization beyond the")
print("  transverse modes of Maxwell and GR) with a specific, frequency-")
print("  dependent radiation pressure.  This is falsifiable physics, not vague")
print("  -- and Williams owned the consequence ('Zero Pressure Radiation').")
print("LIMIT: taken literally with its own optical-fit constant A0, the curve")
print("  predicts zero radiation pressure at ~10 um and NEGATIVE pressure")
print("  (down to w=-1) at all longer wavelengths, including the CMB -- which")
print("  is excluded by measured positive microwave/radio radiation pressure")
print("  and the CMB's w=+1/3.  So EITHER A0 is not the universal constant the")
print("  theory treats it as (the optical fit doesn't extrapolate), OR the")
print("  longitudinal-mode radiation pressure is wrong.  A clean negative")
print("  result on DT's own equation, in the same spirit as the dark-energy")
print("  Gdot/G no-go.")
print("NOTE (2nd channel): a longitudinal/electrogravitic GW polarization is")
print("  also constrained directly -- LIGO/Virgo polarization tests favour pure")
print("  tensor modes, and GW170817 pins |v_GW - c|/c < 1e-15; DT's separate")
print("  longitudinal propagation constant would have to evade both.")

print("\n" + "=" * 70)
print("36 COMPLETE.")
print("=" * 70)
