#!/usr/bin/env sage
# Virtual-particle masses from the static Klein-Gordon equation (Eq 9.96):
# photon masslessness for the Coulomb potential (rigorous), the non-singular
# potential's mass massless only asymptotically, and the 7,254 MeV / LHC unit error.
#
# Source: P. E. Williams, "The Dynamic Theory" (2009), Ch. 9 Eqs (9.96)-(9.98), Ch. 13.
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S3, Appendix A.2 (Book corpus, script 16, B-C3).

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


def laplacian_radial(psi, r):
    """Spherically symmetric Laplacian (1/r^2) d/dr (r^2 dpsi/dr)."""
    return (diff(r**2 * diff(psi, r), r) / r**2).simplify_full()


print("=" * 70)
print("NONSTANDARD MODEL B2 -- virtual masses from static Klein-Gordon (Eq 9.96)")
print("=" * 70)

r = var('r', domain='positive')
lam = var('lam', domain='positive')

# --- (1) Photon: Coulomb potential => zero virtual mass --------------------
print("\n[1] Coulomb potential psi = 1/r  =>  virtual mass = 0 (the photon)")
psi_coul = 1 / r
lap_coul = laplacian_radial(psi_coul, r)
ok("laplacian(1/r) = 0 for r>0  =>  m^2 = 0  (massless photon).",
   lap_coul.is_zero())

# --- (2) Non-singular potential: massless only as r -> oo ------------------
print("\n[2] Non-singular potential psi = exp(-lam/r)/r  =>  m massless only asymptotically")
psi_ns = exp(-lam / r) / r
lap_ns = laplacian_radial(psi_ns, r)
ok("laplacian(exp(-lam/r)/r) != 0  (NOT an exact massless solution).",
   not lap_ns.is_zero())

# implied m^2 c^2 / hbar^2  =  - laplacian(psi)/psi
m2_coeff = (-lap_ns / psi_ns).simplify_full()
m2_expected = 2 * lam / r**3 - lam**2 / r**4
ok("implied m^2 c^2/hbar^2 = 2 lam/r^3 - lam^2/r^4.",
   (m2_coeff - m2_expected).simplify_full().is_zero())
ok("m^2 -> 0 as r -> oo  (photon recovered in the long-range/Coulomb limit).",
   (limit(m2_coeff, r=oo) == 0))
ok("m^2 > 0 at finite r (r > lam/2): non-singular potential is NOT exactly massless.",
   bool(m2_coeff.subs(lam=1, r=10) > 0))
print("    => sharpens Williams: 'also zero' holds only in the large-r limit,")
print("       not identically (m^2 is r-dependent and positive at finite r).")

# --- (3) Source-error catch: 7,254 MeV vs the real LHC energy --------------
print("\n[3] Source-error catch: the '7,254 MeV ~ LHC' claim (Ch.9 Eq 9.105 / Ch.13)")
m_proton_virtual_MeV = 7254.0          # Williams' predicted positron-in-proton virtual mass
lhc_williams_MeV = 7000.0              # Williams' stated 'LHC output' (= 7 GeV)
lhc_beam_real_MeV = 7.0e6              # actual LHC design beam energy: 7 TeV = 7e6 MeV

ok("Williams' prediction (7254 MeV) ~ his stated 'LHC' figure (7000 MeV): within 5%.",
   abs(m_proton_virtual_MeV - lhc_williams_MeV) / lhc_williams_MeV < 0.05)

ratio_to_real_beam = m_proton_virtual_MeV / lhc_beam_real_MeV
print("    7254 MeV / (7 TeV beam = 7e6 MeV) = %.3e" % ratio_to_real_beam)
ok("vs the REAL LHC beam energy (7 TeV), the prediction is ~1000x too small.",
   ratio_to_real_beam < 0.01)
print("    => the '7,254 MeV is right at the LHC energy' coincidence rests on")
print("       equating the LHC to 7,000 MeV instead of 7,000 GeV (7 TeV):")
print("       a 1000x unit error.  Flag for the SI-5 source-error catalogue.")

print("\n  NOTE: the virtual-mass formulas Eqs (9.99)-(9.105) are not reproduced")
print("  here; only the well-posed photon claim (Eq 9.96-9.98) is verified.")

print("\n" + "=" * 70)
print("B2 COMPLETE: photon masslessness verified; non-singular 'masslessness'")
print("sharpened to a long-range limit; the LHC coincidence is a unit error.")
print("=" * 70)
