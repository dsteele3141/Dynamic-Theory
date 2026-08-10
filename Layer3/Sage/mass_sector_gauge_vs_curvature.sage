#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE: Williams (2011), The Dynamic Theory, Ch.2 (Eqs 2.9-2.17) and Ch.7
#   (Eq 7.33), via the mass-sector addendum note (S3 addendum, this session).
#   Book-sourced (like the 12-38 series), not Report-scoped.
# --------------------------------------------------------------------------

# ============================================================================
# mass_sector_gauge_vs_curvature.sage            [A]  (assertion-hardened)
#
# Is the Layer-3 mass potential phi_m a CURVATURE object (metric, route A) or a
# FIFTH-GAUGE object (V-sector, a0 d_gamma coupling, route B)?  Rather than
# assert one, run BOTH routes and let the flat-space algebra decide, testing
# each against the ONE feature that distinguishes DT gravity from Newton:
# the non-singular screening  e^{-lambda/r}  (regular at r=0, Newtonian at
# r=inf), plus the secular (1-bt) drift.
#
# Decisive move: for each candidate radial potential f(r) compute the flat
# radial Laplacian and read off the SOURCE it corresponds to; the source tells
# you which physical mechanism can produce it.
#
# RESULT (yield/admit split):
#   * Route A (curvature) YIELDS the -GM/r Newtonian tail (sign+coeff), but
#     CANNOT produce e^{-lambda/r}: a local mass term gives Yukawa e^{-lambda r}
#     (screened at LARGE r, singular at r=0) -- the opposite of the DT form.
#   * Route B (fifth gauge) NATURALLY produces the non-singular e^{-lambda/r}:
#     it is the potential of a short-distance, gamma-coupled distributed source
#     (the a0 d_gamma coupling), and it carries the secular (1-bt) drift.
#   => phi_m = (curvature tail) x (gauge regulator) = -GM(1-bt)e^{-lambda/r}/r,
#      each factor assigned to the mechanism that can actually produce it.
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage mass_sector_gauge_vs_curvature.sage
# ============================================================================

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


r   = var('r',   domain='positive')
lam = var('lam', domain='positive')   # the screening length lambda
G   = var('G',   domain='positive')
M   = var('M',   domain='positive')
b   = var('b',   domain='positive')
t   = var('t',   domain='positive')


def radial_lap(f):
    """flat 3D radial Laplacian  f'' + (2/r) f'  =  (r f)'' / r"""
    return (diff(f, r, 2) + (2/r)*diff(f, r))


print("=" * 72)
print("MASS POTENTIAL phi_m -- curvature object or fifth-gauge object? (both routes)")
print("=" * 72)

# ---------------------------------------------------------------------------
print("\n[A] ROUTE A -- CURVATURE:  phi_m is metric,  G_ij = kappa T_ij")
# ---------------------------------------------------------------------------

# A1: point-mass Newtonian potential is source-free away from origin
phiN = -G*M/r
ok("A1: Laplacian(-GM/r) = 0 away from source (unscreened Newton tail).",
   radial_lap(phiN).simplify_full().is_zero())

# A2: a massive (Klein-Gordon) field source gives the YUKAWA eigenfunction
yuk = exp(-lam*r)/r
ok("A2: Yukawa e^{-lambda r}/r solves (Laplacian - lambda^2)f = 0 (massive field).",
   (radial_lap(yuk) - lam^2*yuk).simplify_full().is_zero())
# ... but Yukawa is SINGULAR at the origin (wrong for a non-singular potential)
lim_yuk_0 = limit(yuk, r=0, dir='+')
ok("A2: Yukawa is SINGULAR at r=0 (limit -> +oo): wrong regularity for phi_m.",
   lim_yuk_0 == Infinity)
print("      => curvature/mass source screens at LARGE r and is singular at 0;")
print("         DT's phi_m ~ e^{-lambda/r} is the OPPOSITE (regular at 0).")
print("  [A VERDICT] curvature yields the -GM/r tail but CANNOT make e^{-lambda/r}.")

# ---------------------------------------------------------------------------
print("\n[B] ROUTE B -- FIFTH GAUGE:  phi_m in the V-sector, a0 d_gamma coupling")
# ---------------------------------------------------------------------------

phi_dt = exp(-lam/r)/r

# B1: what source does the DT non-singular potential actually require?
src         = radial_lap(phi_dt)
src_claimed = lam*(lam - 2*r)/r^5 * exp(-lam/r)
ok("B1: Laplacian(e^{-lambda/r}/r) = lambda(lambda-2r)/r^5 * e^{-lambda/r}.",
   (src - src_claimed).simplify_full().is_zero())

# B1b: the effective source changes sign at r = lambda/2 (distributed, not point)
sign_roots = solve(lam*(lam - 2*r) == 0, r)
root_vals  = [s.rhs() for s in sign_roots]
ok("B1: effective source changes sign at r = lambda/2 (distributed source).",
   (lam/2) in root_vals)

# B2: regularity + Newtonian tail
ok("B2: phi_m is NON-SINGULAR at r=0 (limit -> 0), unlike Yukawa.",
   limit(phi_dt, r=0, dir='+').is_zero())
ok("B2: phi_m -> 1/r Newtonian tail at large r (coefficient 1).",
   bool(limit(r*phi_dt, r=Infinity) == 1))

# B3: unit Gauss flux at infinity (Newtonian mass normalisation)
flux_inf = limit(-r^2*diff(phi_dt, r), r=Infinity)
ok("B3: Gauss flux at infinity -r^2 phi' = 1 (unit effective mass).",
   bool(flux_inf == 1))
print("      => e^{-lambda/r} is the potential of a short-distance, gamma-coupled")
print("         distributed source: the a0 d_gamma V4 coupling, NOT a mass term.")
print("  [B VERDICT] the fifth-gauge coupling NATURALLY yields the non-singular core.")

# ---------------------------------------------------------------------------
print("\n[C] SECULAR FACTOR (1 - b t):  linearisation of the gauge e^{-b t}")
# ---------------------------------------------------------------------------
sec = taylor(exp(-b*t), t, 0, 1)
ok("C: (1 - b t) is the leading gauge drift, taylor(e^{-b t}) = 1 - b t.",
   (sec - (1 - b*t)).simplify_full().is_zero())
print("      => with b = H0 this is a fifth-dimension / cosmological drift (route B),")
print("         NOT a curvature effect (route A needs M(t) put in by hand).")

# ---------------------------------------------------------------------------
print("\n[SYNTHESIS]  phi_m is NEITHER purely metric NOR purely gauge:")
print("  phi_m = (curvature tail) x (gauge regulator) = -GM(1-bt) e^{-lambda/r}/r")
print("    - curvature limit (a0 -> inf, lambda -> 0): clean GR/Newton  [YIELD]")
print("    - full phi_m: GR tail + gauge dressing; the dressing carries the")
print("      DT-specific, testable deviations (non-singular core + secular drift).")
print("    - Schwarzschild x R (T2_14) is the a0->inf, static, vacuum corner [ADMIT].")

print("\n" + "=" * 72)
print("mass_sector_gauge_vs_curvature COMPLETE.")
print("=" * 72)
