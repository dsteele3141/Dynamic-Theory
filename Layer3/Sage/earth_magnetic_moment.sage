#!/usr/bin/env sage
# WITHDRAWN (2026-10-08) by blackett_coupling_bodies.sage: the match uses
# beta = sqrt(eps0 G), but Coulomb->Newton needs sqrt(4 pi eps0 G) (Earth off 3.5x);
# read as the 5D gravitational field it is GR frame dragging. Kept as the record of
# the original claim; see INDEX.md.
#
# Earth's magnetic moment: a spinning neutral mass carries mu = (beta/2) I omega
# with beta = sqrt(eps0 G), a parameter-free postdiction (no a0, no fit) within
# ~6-15% of the measured dipole.
#
# Source: P. E. Williams, "The Dynamic Theory", Ch. 10 Eqs (10.19)+, pp.294-295.
# Full derivation, context and provenance:
#   Supplementary Materials (stand-alone document) — §S3, Appendix A.2 (Book corpus, script 20, B-M1).

from sage.all import *

print("WITHDRAWN (see blackett_coupling_bodies.sage): the match uses beta = sqrt(eps0 G); Coulomb->Newton needs sqrt(4 pi eps0 G).\n")


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


def rel(a, b):
    return abs(float(a) - float(b)) / abs(float(b))


print("=" * 70)
print("EARTH MAGNETIC MOMENT -- parameter-free Layer-3 (mass-sector) postdiction")
print("=" * 70)

# --- Constants -------------------------------------------------------------
eps0 = 8.8541878128e-12       # F/m
G = 6.674e-11                 # m^3 kg^-1 s^-2

# --- (1) Effective gravitational charge-to-mass ratio beta ------------------
print("\n[1] beta = sqrt(eps0 G)  (Eq 10.19 value)")
beta = sqrt(eps0 * G)
print("    beta = %.5g C/kg   (Williams: 2.4296e-11)" % float(beta))
ok("beta = sqrt(eps0 G) = 2.4296e-11 C/kg (within 0.5%).", rel(beta, 2.4296e-11) < 5e-3)
# the printed sqrt(4 pi eps0 G) would be ~8.6e-11, which does NOT match the value:
ok("printed sqrt(4 pi eps0 G) != the stated value (so the 4pi is a misprint).",
   rel(sqrt(4 * pi * eps0 * G), 2.4296e-11) > 0.5)

# --- (2)-(3) Earth's magnetic moment, Williams' inputs ----------------------
print("\n[2] Earth (Williams' values): M, I, omega")
M_w = 5.983e24                # kg
I_w = 9.71e37                 # kg m^2
om_w = 7.29e-5                # rad/s  (book prints 7.29e5; book typo)
q_eff = beta * M_w
print("    q_eff = beta M = %.4g C   (Williams: 1.454e14)" % float(q_eff))
ok("q_eff = beta M_earth = 1.454e14 C (within 1%).", rel(q_eff, 1.454e14) < 1e-2)

mu_w = (q_eff / (2 * M_w)) * I_w * om_w        # = (beta/2) I omega
print("\n[3] mu = (beta/2) I omega")
print("    mu = %.3g amp-m^2   (Williams: 8.6e22; measured 8.1e22)" % float(mu_w))
ok("mu = 8.6e22 amp-m^2 (reproduces Williams, within 3%).", rel(mu_w, 8.6e22) < 3e-2)
ok("mu agrees with the measured 8.1e22 amp-m^2 (within 10%).", rel(mu_w, 8.1e22) < 0.10)

# --- (4) Robustness with modern Earth values --------------------------------
print("\n[4] Robustness: modern Earth (I, omega, M)")
M_m, I_m, om_m = 5.972e24, 8.034e37, 7.2921e-5
mu_m = (beta / 2) * I_m * om_m
print("    mu(modern) = %.3g amp-m^2  (measured ~8.0e22)" % float(mu_m))
ok("modern-input mu is the same order and within 15% of the measured value.",
   rel(mu_m, 8.0e22) < 0.15)

print("\n  NET: a spinning neutral body's magnetic moment, with beta = sqrt(eps0 G)")
print("  built from G and eps0 alone, reproduces Earth's measured dipole moment to")
print("  ~6-15%. PARAMETER-FREE (no a0, no fit) -- a clean mass-sector postdiction")
print("  the Report-scoped corpus did not record.")
print("  CAVEAT (finding L3-10): 'parameter-free' is CONDITIONAL on the beta")
print("  adjudication -- Eq 10.19 PRINTS beta=sqrt(4 pi eps0 G) but its stated")
print("  value is sqrt(eps0 G); we take the value (the one matching data). A source")
print("  correction, not a prediction from the literal printed equation.")

print("\n" + "=" * 70)
print("20 COMPLETE.")
print("=" * 70)
