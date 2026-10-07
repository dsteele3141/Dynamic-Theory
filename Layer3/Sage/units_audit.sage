#!/usr/bin/env sage
# Dimensional audit of DT's mass-sector constants with sympy.physics.units.
#
# Checks that every relation the corpus USES among a0, K_gamma, H0, u4, k4, A0,
# k and the MOND acceleration is dimensionally consistent, and pins down two
# notation collisions so they cannot silently propagate:
#   * "a0" is BOTH the DT gauge constant (kg/m^4, Book Ch.7 / script 18) and
#     the MOND acceleration (m/s^2, Book Eq 3.35) -- different dimensions;
#   * "u4" is BOTH the fifth velocity component (dimensionless, Book Eq 1.36)
#     and the fourth power of a 1D flow speed (m^4/s^4, Book Eq 12.53).
# It also settles that the Eq 2.10 vs Eq 2.21 a0*c*K_gamma tension (~2e21) is a
# NUMERICAL gap, not a dimensional one: both sides are rates (1/s).
#
# Source: P. E. Williams, "The Dynamic Theory", Eqs (1.36), (2.10), (2.21),
# (3.33)-(3.35), (12.53), Ch.7 (a0 shock fit). Uses only dimensions, no values
# beyond the dimensionless force ratio.
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S3, Appendix A.

from sage.all import *
from sympy import S as sS, sqrt as ssqrt
from sympy.physics.units import Dimension
# NB: Sage preparses integer literals; sympy Dimensions need sympy numbers on
# the LEFT of an operator, hence sS.One / sS.Half / ssqrt below.
from sympy.physics.units.definitions.dimension_definitions import (
    length as L, mass as M, time as T, current as I)
from sympy.physics.units.systems.si import dimsys_SI


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


def dims(D):
    return {str(k): v for k, v in dimsys_SI.get_dimensional_dependencies(D).items()}


def same(A, B):
    return dims(A) == dims(B)


def dimensionless(D):
    return dims(D) == {}


one = Dimension(sS.One)

# --- base quantities ---------------------------------------------------------
c       = L / T                       # speed of light
H0      = sS.One / T                       # Hubble rate
G       = L**3 / (M * T**2)           # Newton
gamma   = M / L**3                    # mass density = DT's fifth coordinate
a0_g    = M / L**4                    # DT gauge constant (shock fit, 3.65e7)
a0_mond = L / T**2                    # MOND acceleration (1.2e-10)
charge  = I * T
voltage = M * L**2 / (T**3 * I)
eps0    = charge**2 * T**2 / (M * L**3)
mass    = M

print("=" * 72)
print("UNITS AUDIT -- DT mass-sector constants (sympy.physics.units, SI)")
print("=" * 72)

# --- [1] gauge sector ----------------------------------------------------------
print("\n[1] Gauge constant a0 (kg/m^4) and K_gamma = H0/(a0 c)   (Eq 2.10)")
K_g = H0 / (a0_g * c)
print("    [a0 c]    =", dims(a0_g * c))
print("    [K_gamma] =", dims(K_g))
ok("a0*c is a rate of change of mass density (the dgamma/dt ceiling).",
   same(a0_g * c, gamma / T))
ok("K_gamma has dimensions m^3/kg.", same(K_g, L**3 / M))
ok("K_gamma*gamma is dimensionless (the gauge exponent e^{-K_gamma gamma} is legal).",
   dimensionless(K_g * gamma))

# --- [2] u4 -------------------------------------------------------------------
print("\n[2] Fifth velocity component u4 (Eq 1.36)")
ok("u4 = H0 gamma/(a0 c) is dimensionless.", dimensionless(H0 * gamma / (a0_g * c)))
ok("u4 = (dgamma/dt)/(a0 c) is dimensionless (ceiling u4 = 1 <-> dgamma/dt = a0 c).",
   dimensionless((gamma / T) / (a0_g * c)))
ok("y4 = gamma/a0 is a length, so u4 = (1/c) dy4/dt is dimensionless.",
   dimensionless((gamma / a0_g) / T / c))

# --- [3] Eq 2.10 vs Eq 2.21 ----------------------------------------------------
print("\n[3] The a0*c*K_gamma tension: Eq 2.10 (= H0) vs Eq 2.21 (= H0/sqrt(F_ratio))")
F_ratio = charge**2 / (eps0 * G * mass**2)
ok("F_ratio = e^2/(4 pi eps0 G m^2) is dimensionless.", dimensionless(F_ratio))
ok("Eq 2.10 side a0 c K_gamma is a rate (1/s).", same(a0_g * c * K_g, sS.One / T))
ok("Eq 2.21 side H0/sqrt(F_ratio) is a rate (1/s).", same(H0 / ssqrt(F_ratio), sS.One / T))
print("    => the ~2e21 gap is a pure number (sqrt(F_ratio) for two electrons);")
print("       it is NOT a units error, and its size depends on which masses enter")
print("       F_ratio (electron vs proton changes it by ~1e3; force_ratio.sage [2]).")

# --- [4] radiation pressure (P1) and nuclear anchor ------------------------------
print("\n[4] P1 (A0 = a0 c k4) and the nuclear anchor K_gamma = k/(a0 e/4 pi eps0)")
k4 = L**3 / M
A0 = a0_g * c * k4
ok("k4 has the same dimensions as K_gamma (a wavenumber along the mass axis).",
   same(k4, K_g))
ok("A0 = a0 c k4 is a frequency (compared with w = 540 THz).", same(A0, sS.One / T))
ok("A0/w is dimensionless.", dimensionless(A0 / (sS.One / T)))
kC = charge / eps0                  # e/(4 pi eps0) carries V*m
ok("e/(4 pi eps0) has dimensions V*m.", same(kC, voltage * L))
ok("K_gamma = k/(a0 e/4 pi eps0), k in volts, has dimensions m^3/kg.",
   same(voltage / (a0_g * kC), L**3 / M))

# --- [5] MOND sector -------------------------------------------------------------
print("\n[5] MOND acceleration a0 (m/s^2), Eqs 3.33-3.35")
r_c = (G * mass / a0_mond)**sS.Half
ok("r_c = sqrt(G M/a0) is a length.", same(r_c, L))
ok("tau0dot = c/(r_c H0) is dimensionless.", dimensionless(c / (r_c * H0)))
ok("Tully-Fisher v^4 = G M a0 is consistent.", same((L / T)**4, G * mass * a0_mond))
ok("a0/(c H0) is dimensionless (the 0.176 vs 1/2pi comparison is legal).",
   dimensionless(a0_mond / (c * H0)))

# --- [6] notation collisions -------------------------------------------------------
print("\n[6] Notation collisions (pinned so they cannot propagate)")
ok("gauge a0 (kg/m^4) and MOND a0 (m/s^2) are DIFFERENT quantities.",
   not same(a0_g, a0_mond))
ok("substituting the gauge a0 into Tully-Fisher breaks it (mixing is detectable).",
   not same((L / T)**4, G * mass * a0_g))
ok("substituting the MOND a0 into K_gamma breaks the gauge exponent.",
   not dimensionless(H0 / (a0_mond * c) * gamma))
u4_velocity = one
u4_eq1253   = (L / T)**4
ok("u4 (Eq 1.36, velocity component) and u^4 (Eq 12.53, speed^4) differ.",
   not same(u4_velocity, u4_eq1253))

# --- [7] mutation tests: the audit must catch wrong relations ----------------------
print("\n[7] Mutation tests")
ok("wrong K_gamma = H0 a0/c would make the gauge exponent dimensionful.",
   not dimensionless(H0 * a0_g / c * gamma))
ok("wrong A0 = a0 k4/c is not a frequency.", not same(a0_g * k4 / c, sS.One / T))

print("\n  NET: every mass-sector relation the corpus uses is dimensionally")
print("  consistent. The Eq 2.10/2.21 tension is numerical, not dimensional.")
print("  The two 'a0' and the two 'u4' are distinct quantities; scripts keep")
print("  each to one meaning, and any mixing would fail the checks above.")
print("\n" + "=" * 72)
print("units_audit COMPLETE.")
print("=" * 72)
