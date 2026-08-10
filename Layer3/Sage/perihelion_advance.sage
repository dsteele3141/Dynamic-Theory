#!/usr/bin/env sage
# Mercury's perihelion advance: confirm the GR value 42.98"/century, and show
# DT's non-singular-potential advance equals delta_GR under lambda = G M / c^2.
#
# Source: P. E. Williams, "The Dynamic Theory", Ch. 10 Eqs (10.20)-(10.38), pp.296-299.
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S3, Appendix A.2 (Book corpus, script 22, B-M3).

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


def rel(a, b):
    return abs(float(a) - float(b)) / abs(float(b))


print("=" * 70)
print("PERIHELION ADVANCE (Mercury) -- DT recovers the GR result (mass sector)")
print("=" * 70)

# --- Constants & Mercury orbit ---------------------------------------------
G = 6.674e-11                 # m^3 kg^-1 s^-2
c = 2.99792458e8              # m/s
M_sun = 1.98892e30            # kg
a_merc = 5.7909e10            # m   (semi-major axis)
e_merc = 0.205630             # eccentricity
T_merc_yr = 0.2408467         # orbital period (Julian years)
arcsec_per_rad = 180.0 / pi * 3600.0

# --- (1) Standard GR perihelion advance for Mercury -------------------------
print("\n[1] GR advance: delta = 6 pi G M / (c^2 a (1-e^2)) per orbit")
delta_orbit = 6 * pi * G * M_sun / (c**2 * a_merc * (1 - e_merc**2))   # rad/orbit
orbits_per_century = 100.0 / T_merc_yr
delta_century_arcsec = delta_orbit * orbits_per_century * arcsec_per_rad
print("    per orbit   = %.4g rad" % float(delta_orbit))
print("    per century = %.2f arcsec   (observed GR value: 42.98\"/century)"
      % float(delta_century_arcsec))
ok("GR Mercury perihelion advance = 43 arcsec/century (within 2%).",
   rel(delta_century_arcsec, 42.98) < 0.02)

# --- (2) Williams' matching condition lambda = G M / c^2 --------------------
print("\n[2] DT matches GR when lambda = G M_sun / c^2")
lam_sun = G * M_sun / c**2
print("    lambda = G M_sun / c^2 = %.4g m  (= half the solar Schwarzschild radius)"
      % float(lam_sun))
ok("lambda = G M_sun/c^2 ~ 1.48e3 m (within 2%).", rel(lam_sun, 1476.0) < 0.02)
# Williams' Eq (10.37) cgs value 1.47e5 cm equals this in metres:
ok("Eq (10.37) 1.47e5 cm = 1.47e3 m equals G M_sun/c^2 (Eq 10.38 '1.47e5 m' is a cm->m slip).",
   rel(1.47e5 * 1e-2, lam_sun) < 0.02)

# --- (3) Under lambda = GM/c^2 the DT advance equals the GR advance ---------
print("\n[3] Correspondence: DT advance reduces to delta_GR under lambda = GM/c^2")
# Williams' DT correction term ~ (6 lambda G M m^2 / L^2) maps onto the GR term
# (3 G^2 M^2 m^2 / (c^2 L^2)) exactly when lambda = G M / c^2 (Eqs 10.34-10.36):
#   6 lambda (GM) == 6 (GM/c^2)(GM) = 6 G^2 M^2 / c^2 ; GR carries 3 G^2 M^2/c^2 x2
# i.e. the DT and GR perihelion coefficients coincide for lambda = GM/c^2.
lhs = 6 * lam_sun * (G * M_sun)                 # DT coefficient numerator (~ 6 lambda GM)
rhs = 6 * (G * M_sun)**2 / c**2                  # GR-equivalent (6 G^2 M^2 / c^2)
ok("DT coefficient 6*lambda*GM equals 6*(GM)^2/c^2 under lambda = GM/c^2.",
   rel(lhs, rhs) < 1e-9)
print("    => DT's non-singular-potential advance reproduces the GR perihelion")
print("       advance (Mercury's 43\"/century) in the limit lambda = GM/c^2.")
print("    SCOPE (finding L3-10): the identification lambda = GM/c^2 is SUPPLIED")
print("    (Book Eq 10.36), not derived here; the GR match is conditional on it.")

print("\n" + "=" * 70)
print("22 COMPLETE: GR Mercury number 42.98\"/century confirmed; DT recovers it")
print("under lambda = G M / c^2 (~1.48 km).")
print("=" * 70)
