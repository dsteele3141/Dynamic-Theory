#!/usr/bin/env sage
# Nuclear-mass model recurrence (9.90-9.93) self-consistency, the neutron COM
# potential (9.94) matching the barrier form, and the virtual-mass (9.100)
# near-pole behaviour (fitted, not robust).
#
# Source: P. E. Williams, "The Dynamic Theory", Ch. 9 Eqs (9.87)-(9.105), pp.276-286.
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S3, Appendix A.2 (Book corpus, script 19, B-C3).

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


print("=" * 70)
print("NUCLEAR MODEL (recovered from page photos) -- clean-part verification")
print("=" * 70)

# --- (1) Nuclear-mass model recurrence, now well-posed (9.90-9.93) ----------
print("\n[1] Mass-model recurrence self-consistency (9.90-9.93)")
E1, E2, Ec = var('E1 E2 Ec')          # n=1, n=2 proton-orbit energies; core energy
E_2H_ground = 2 * E1 + Ec             # (9.90)
E_2H_excited = 2 * E2 + Ec            # (9.91)

# (9.92): E_2 extracted from the excited state must return E_2 (consistency).
E2_from_excited = (E_2H_excited - Ec) / 2
ok("(9.92) E_2 = [E(2,1)* - E_c]/2 is self-consistent (returns E_2).",
   (E2_from_excited - E2).simplify_full() == 0)

# (9.93): 3He energy = deuteron + one n=2 proton.
E_3He = E_2H_ground + (E_2H_excited - Ec) / 2          # (9.93)
ok("(9.93) E(3,1) = E(2,1) + E_2  (3He = deuteron + one n=2 proton).",
   (E_3He - (E_2H_ground + E2)).simplify_full() == 0)
ok("(9.93) expands to 2 E_1 + E_2 + E_c.",
   (E_3He - (2 * E1 + E2 + Ec)).simplify_full() == 0)

# Ground != excited unless E_1 == E_2.
ok("ground and excited 2H states differ exactly by 2(E_1 - E_2).",
   (E_2H_ground - E_2H_excited - 2 * (E1 - E2)).simplify_full() == 0)

# --- (2) Neutron COM potential (9.94) == the script-15 barrier form ---------
print("\n[2] Neutron COM potential (9.94) matches script 15")
r = var('r', domain='positive')
k = var('k', domain='positive')
lp, le = var('lp le', domain='positive')      # lam_p, lam_e
Vc_book = -(k / r) * (exp(-lp / r) - exp(-le / r))           # (9.94), as photographed
Vc_script15 = (k / r) * (exp(-le / r) - exp(-lp / r))         # script 15 magnitude form
ok("(9.94) V_c = -(k/r)[e^{-lam_p/r} - e^{-lam_e/r}] equals script-15 form.",
   (Vc_book - Vc_script15).simplify_full().is_zero())
# positive barrier for lam_p > lam_e:
ok("V_c > 0 for lam_p > lam_e (positive barrier; cf. Fig 9.9 ~530 MeV peak).",
   bool(Vc_book.subs(k=1, lp=1, le=1e-3, r=1e-3) > 0))

# --- (3) Virtual-mass near-pole: why m_N ~ 3.28e3 GeV is fine-tuned ----------
print("\n[3] Virtual-mass (9.100) denominator near-pole -> fitted, not robust")
me_mp = 1.0 / 1836.15                 # m_e/m_p
lam_p = 10.0                          # F  (proton scale length in the neutron context)


def denom(rr):
    return exp(-lam_p / rr) * (1 - lam_p / rr) + me_mp     # (9.100) denominator


# The denominator is +me/mp at r = lam_p and negative just below -> it has a zero
# (a pole of m_n) at some r* < lam_p.
d_at_lp = denom(lam_p)
d_below = denom(lam_p * 0.98)
print("    denom(r=lam_p)      = %+.5e" % float(d_at_lp))
print("    denom(r=0.98 lam_p) = %+.5e" % float(d_below))
ok("denominator is +m_e/m_p at r = lam_p.", abs(float(d_at_lp) - me_mp) < 1e-9)
ok("denominator changes sign just below lam_p (a pole of m_n exists there).",
   float(d_at_lp) * float(d_below) < 0)
# locate the pole and show |m_n| ~ 1/|denom| diverges monotonically approaching it
r_pole = find_root(denom, lam_p * 0.90, lam_p * 0.999999)
print("    pole at r* = %.6f F  (just below lam_p = %.1f F)" % (r_pole, lam_p))
approach = [abs(1.0 / denom(r_pole + d)) for d in (1e-2, 1e-4, 1e-6)]
print("    |m_n|~1/|denom| at r*+{1e-2,1e-4,1e-6} = %.3e, %.3e, %.3e"
      % tuple(approach))
ok("|m_n| ~ 1/|denom| grows monotonically as r -> r* (unbounded near the pole).",
   approach[0] < approach[1] < approach[2])
print("    => m_N ~ 3.28e3 GeV requires r tuned to the near-pole; it is a FITTED")
print("       value, not parameter-free (parallels the script-15 lifetime).")

print("\n  NET: the page photos make the nuclear-MASS model (9.88-9.93) clean and")
print("  self-consistent, and confirm the neutron barrier (9.94). The virtual-")
print("  MASS values (9.101/9.104/9.105) remain fitted (near-pole + a bare-lam_p")
print("  dimensional slip in 9.99/9.100). Full record: book-recovered-equations.txt.")

print("\n" + "=" * 70)
print("19 COMPLETE.")
print("=" * 70)
