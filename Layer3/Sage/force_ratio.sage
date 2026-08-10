#!/usr/bin/env sage
# Electric/gravitational force ratio: reproduce the classical ~10^40 ratio
# e^2/(4 pi eps0 G m^2), show its mass-dependence, and tie it to the Hubble
# constant via a0 c K_gamma = H0 / sqrt(F_ratio).
#
# Source: P. E. Williams, "The Dynamic Theory", Ch. 2 Eqs (2.18)-(2.21), Ch. 7 pp.194-195.
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S3, Appendix A.2 (Book corpus, script 21, B-M2).

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


def rel(a, b):
    return abs(float(a) - float(b)) / abs(float(b))


print("=" * 70)
print("ELECTRIC / GRAVITATIONAL FORCE RATIO -- derived & tied to H0 (mass sector)")
print("=" * 70)

# --- Constants -------------------------------------------------------------
e = 1.602176634e-19           # C
eps0 = 8.8541878128e-12       # F/m
G = 6.674e-11                 # m^3 kg^-1 s^-2
m_e = 9.1093837015e-31        # kg
m_p = 1.67262192369e-27       # kg
c = 2.99792458e8              # m/s
Mpc = 3.0857e22               # m
H0 = 70.0e3 / Mpc             # s^-1  (70 km/s/Mpc)


def fratio(m1, m2):
    return e**2 / (4 * pi * eps0 * G * m1 * m2)


# --- (1) Classical ratio for two electrons = 4.17e42 (Eq 2.21) -------------
print("\n[1] Classical electric/gravitational ratio, two electrons")
R_ee = fratio(m_e, m_e)
print("    e^2/(4 pi eps0 G m_e^2) = %.4g   (Williams Eq 2.21: 4.17e42)" % float(R_ee))
ok("two-electron force ratio = 4.17e42 (within 1%).", rel(R_ee, 4.17e42) < 1e-2)

# --- (2) The "~10^40" is mass-dependent ------------------------------------
print("\n[2] Mass-dependence of the ratio")
R_pp = fratio(m_p, m_p)
R_ep = fratio(m_e, m_p)
print("    two protons   : %.3g  (~10^36)" % float(R_pp))
print("    electron-proton: %.3g  (~10^39, the canonical '~10^40')" % float(R_ep))
ok("protons ~ 1.2e36.", rel(R_pp, 1.24e36) < 0.05)
ok("electron-proton ~ 2.3e39.", rel(R_ep, 2.27e39) < 0.05)

# --- (3) DT ties the ratio to H0: a0 c K_gamma = H0 / sqrt(F_ratio) ---------
print("\n[3] DT identity: a0 c K_gamma = H0 / sqrt(F_ratio)  (Eq 2.21)")
print("    H0 = 70 km/s/Mpc = %.4g /s" % float(H0))
a0cKg = H0 / sqrt(R_ee)
print("    a0 c K_gamma = H0 / sqrt(4.17e42) = %.4g /s   (Williams: ~1.12e-39)"
      % float(a0cKg))
ok("sqrt(F_ratio) = 2.042e21 (Williams' divisor).", rel(sqrt(R_ee), 2.042e21) < 1e-2)
ok("a0 c K_gamma ~ 1.12e-39 /s (within 5%, given H0 ~ 70 km/s/Mpc).",
   rel(a0cKg, 1.12e-39) < 0.05)

print("\n  NET: DT REPRODUCES the classical force ratio (correspondence) and, by")
print("  identifying it with H0^2/(a0 c K_gamma)^2, ties the ~10^40 hierarchy to")
print("  the Hubble constant via the gauge function's time/mass dependences. It")
print("  is a relation among (force ratio, H0, a0cK_gamma), not an ab-initio")
print("  derivation of 10^40 -- but it removes the 'unexplained input' framing.")

print("\n" + "=" * 70)
print("21 COMPLETE.")
print("=" * 70)
