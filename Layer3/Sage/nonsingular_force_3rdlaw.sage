#!/usr/bin/env sage
# Non-singular ("neo-coulombic") potential and Newton's-third-law violation
# for unlike particles.
#
# Source: P. E. Williams, "The Dynamic Theory" (2009), Ch. 2 Eqs (2.33)-(2.37).
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S3, Appendix A.2 (Book corpus, script 12, B-C1/C2).

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


print("=" * 70)
print("NONSTANDARD MODEL A1 -- non-singular force & Newton's-3rd-law violation")
print("=" * 70)

# Symbols (all separations / scale lengths positive).
r = var('r', domain='positive')
k = var('k', domain='positive')
lam = var('lam', domain='positive')

# --- (1) Force from the non-singular potential -----------------------------
print("\n[1] Force F = -dphi/dr from phi = k exp(-lam/r)/r")
phi = k * exp(-lam / r) / r
F = (-diff(phi, r)).simplify_full()
F_williams = k * (1 - lam / r) * exp(-lam / r) / r**2
ok("F(r) = k (1 - lam/r) exp(-lam/r) / r^2  (matches Eq 2.33/2.34 form)",
   (F - F_williams).simplify_full().is_zero())

# --- (2) Force vanishes exactly at r = lam ---------------------------------
print("\n[2] Character-change radius: F(lam) = 0")
ok("F(r=lam) = 0 identically (the (1 - lam/r) factor vanishes).",
   F_williams.subs(r=lam).simplify_full().is_zero())

# --- (3) Sign flip across r = lam ------------------------------------------
print("\n[3] Sign flip: repulsive (r>lam) -> attractive (r<lam)")
# Evaluate the sign-carrying factor (1 - lam/r) at lam = 1.
factor = (1 - lam / r)
out_lt = factor.subs(lam=1, r=1/2)     # r < lam
out_gt = factor.subs(lam=1, r=2)       # r > lam
ok("(1 - lam/r) < 0 for r < lam   (force attractive below lam).", out_lt < 0)
ok("(1 - lam/r) > 0 for r > lam   (force repulsive baseline above lam).", out_gt > 0)

# --- (4) Non-singularity + unique stationary point -------------------------
print("\n[4] Non-singular potential: phi -> 0 at both ends; max at r = lam")
lim0 = limit(phi, r=0, dir='plus')
liminf = limit(phi, r=oo)
ok("phi -> 0 as r -> 0+   (NON-SINGULAR; exp beats 1/r).", (lim0 == 0))
ok("phi -> 0 as r -> oo.", (liminf == 0))
stat = solve(diff(phi, r) == 0, r)
stat_r = [s.rhs() for s in stat]
ok("phi has its (only) stationary point exactly at r = lam.", stat_r == [lam])

# --- (5) Coulomb correspondence --------------------------------------------
print("\n[5] Correspondence: lam -> 0 recovers Coulomb")
F_coulomb = limit(F_williams, lam=0)
ok("lim_{lam->0} F(r) = k / r^2  (Coulomb force recovered).",
   (F_coulomb - k / r**2).simplify_full().is_zero())

# --- (6) Newton's-third-law violation for UNLIKE particles -----------------
print("\n[6] Newton's third law: holds at atomic range, VIOLATED at nuclear range")
lam_p = var('lam_p', domain='positive')
lam_e = var('lam_e', domain='positive')
assume(lam_p > lam_e)                      # proton scale length > electron's

# Force ON the proton is set by the ELECTRON field (uses lam_e), and vice versa
# (Eqs 2.33-2.34).  Work with the lam-dependent magnitude factor g(r; lam):
def gfac(L):
    return (1 - L / r) * exp(-L / r) / r**2

F_on_p = gfac(lam_e)       # proton feels electron's (small-lam) field
F_on_e = gfac(lam_p)       # electron feels proton's (large-lam) field
ratio = (F_on_p / F_on_e)

# (6a) atomic / large-separation limit -> action = reaction restored
lim_ratio = limit(ratio, r=oo)
ok("|F_p|/|F_e| -> 1 as r -> oo  (3rd law restored at atomic separations).",
   (lim_ratio == 1))

# (6b) at r = lam_p the electron force vanishes, proton force does not
Fe_at = F_on_e.subs(r=lam_p).simplify_full()
Fp_at = F_on_p.subs(r=lam_p).simplify_full()
ok("F_on_e = 0 at r = lam_p  (electron indifferent to proton).",
   Fe_at.is_zero())
ok("F_on_p != 0 at r = lam_p  (proton still attracted)  => 3rd law VIOLATED.",
   not Fp_at.is_zero())

# Numeric illustration with Williams' values: lam_p = 1 F, lam_e = 1e-3 F.
print("\n  Numeric (Williams: lam_p = 1 Fermi, lam_e = 1e-3 Fermi):")
subs_num = {lam_p: 1, lam_e: 1e-3}
for rv in [10, 1, 0.5]:
    fp = float(F_on_p.subs(subs_num).subs(r=rv))
    fe = float(F_on_e.subs(subs_num).subs(r=rv))
    asym = (fp / fe) if fe != 0 else float('inf')
    print("    r = %5.2f F : F_on_p = %+.4e   F_on_e = %+.4e   ratio = %s"
          % (rv, fp, fe, ("%.3f" % asym) if fe != 0 else "inf (F_e=0)"))
forget()

print("\n" + "=" * 70)
print("A1 COMPLETE: one non-singular potential -> short-range attraction +")
print("exact 3rd-law violation for unlike particles.  No new force introduced.")
print("=" * 70)
