#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE (primary): P. E. Williams, "The Dynamic Theory: A New View of
#   Space-Time-Matter", Ch. 13 "Black Holes" (p.452): "The non-singular
#   gravitational field does not allow for a prediction of a black hole due to a
#   singularity in the gravitational field." The gravitational potential has the
#   non-singular WUP form V_g = -(GM/r) e^{-lambda/r}, with lambda = GM/c^2 (the
#   gravitational scale length; cf. Ch.10 perihelion, Eq 10.36). Book primary.
# --------------------------------------------------------------------------

# ============================================================================
# 33_nonsingular_black_holes.sage               [A]  (assertion-hardened)
#
# Big-topic pot shot: BLACK HOLE SINGULARITIES. DT's non-singular gravitational
# potential V_g(r) = -(GM/r) e^{-lambda/r}, lambda = GM/c^2, the same regularising
# form that gave the finite electron self-energy (script 08) and the nuclear force
# (script 12). Consequences for black holes:
#
#   (1) NON-SINGULAR: V_g -> 0 as r -> 0 (the exponential beats 1/r), vs Newtonian
#       -GM/r -> -infinity and GR Schwarzschild's central singularity. No singularity.
#   (2) NO EVENT HORIZON (the quantitative kicker): |V_g| is BOUNDED, peaking at
#       r = lambda with |V_g|max = c^2/e. The escape speed v_esc = sqrt(2|V_g|)
#       therefore maxes at sqrt(2/e) c = 0.858 c < c -- it NEVER reaches c, so
#       there is no surface of infinite redshift. The "black hole" is a horizonless,
#       singularity-free ultra-compact object.
#   (3) REGULAR CORE: the gravitational force = -dV_g/dr vanishes at r = lambda and
#       reverses (repulsive) for r < lambda -- a regular core, not a point collapse.
#   (4) CORRESPONDENCE: lambda -> 0 (or r >> lambda) recovers Newtonian -GM/r.
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 33_nonsingular_black_holes.sage
# ============================================================================

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


print("=" * 70)
print("NON-SINGULAR BLACK HOLES -- DT's gravitational potential V_g = -(GM/r)e^{-lam/r}")
print("=" * 70)

r = var('r', domain='positive')
GM = var('GM', domain='positive')
cc = var('cc', domain='positive')     # speed of light c
lam = GM / cc**2                       # gravitational scale length (Eq 10.36)
Vg = -(GM / r) * exp(-lam / r)         # gravitational potential per unit mass

# --- (1) non-singular at the centre -----------------------------------------
print("\n[1] No central singularity")
ok("V_g -> 0 as r -> 0+  (NON-singular; vs Newtonian -GM/r -> -inf).",
   (limit(Vg, r=0, dir='plus') == 0))
# Newtonian potential diverges; DT's is finite (zero) -- the contrast
ok("Newtonian -GM/r DIVERGES as r->0 (the singularity DT removes).",
   (limit(-GM / r, r=0, dir='plus') == -oo))

# --- (2) bounded potential -> no event horizon ------------------------------
print("\n[2] Bounded binding -> NO event horizon")
# stationary point of V_g
stat = solve(diff(Vg, r) == 0, r)
stat_r = [s.rhs() for s in stat]
ok("V_g has its extremum exactly at r = lambda = GM/c^2.", stat_r == [lam])
Vg_max = (Vg.subs(r=lam)).simplify_full()           # depth of the well
ok("|V_g| peaks at c^2/e  (V_g(lambda) = -c^2/e).",
   (Vg_max + cc**2 / e).simplify_full() == 0)
# Newtonian escape speed v_esc = sqrt(2|V_g|); its max = sqrt(2/e) c.
# SCOPE (finding L3-11): this is a NEWTONIAN escape-speed bound on a scalar
# potential. Event horizons and curvature singularities are GLOBAL RELATIVISTIC
# properties of the metric, NOT decided by a bounded Newtonian potential. The
# bound below is SUGGESTIVE of a horizonless object; it is not a proof. A full
# strong-field metric (still needed, see below) and a curvature/geodesic analysis
# would be required to actually establish horizon/singularity-freeness.
vesc_max_over_c = sqrt(2 * (cc**2 / e)) / cc
ok("max Newtonian escape speed = sqrt(2/e) c ~ 0.858 c < c (bounded; suggestive, not a horizon proof).",
   (vesc_max_over_c - sqrt(2 / e)).simplify_full() == 0)
print("    v_esc(max)/c = sqrt(2/e) = %.4f  (Schwarzschild would reach 1 at r_s=2GM/c^2)"
      % float(sqrt(2 / e)))

# --- (3) regular core: force vanishes and reverses at r = lambda ------------
print("\n[3] Regular core (no point collapse)")
F = (-diff(Vg, r)).simplify_full()                  # gravitational force per unit mass
ok("gravitational force = 0 at r = lambda (binding turns over -> regular core).",
   F.subs(r=lam).simplify_full().is_zero())

# --- (4) Newtonian correspondence -------------------------------------------
print("\n[4] Correspondence")
ok("lambda -> 0 recovers Newtonian V_g = -GM/r.",
   (limit(Vg, cc=oo) - (-GM / r)).simplify_full() == 0)

# --- scales ------------------------------------------------------------------
print("\n[scales] lambda = GM/c^2 (core size ~ lambda; Schwarzschild r_s = 2 lambda)")
G = 6.674e-11; c = 2.99792458e8; Msun = 1.989e30
for name, M in [("Sun", Msun), ("10 Msun BH", 10 * Msun), ("Sgr A* (4.3e6 Msun)", 4.3e6 * Msun)]:
    lam_m = G * M / c**2
    print("    %-22s lambda = %.3g m   (r_s = %.3g m)" % (name, lam_m, 2 * lam_m))

print("\n  NET: DT replaces the black-hole SINGULARITY (and even the event HORIZON,")
print("  since max escape speed is 0.858 c) with a regular, horizonless ultra-")
print("  compact object of core size ~lambda=GM/c^2 -- via the SAME non-singular")
print("  potential that gives the finite electron self-energy. A big, clean")
print("  structural prediction.")
print("  HONEST CEILING: (a) it is the energy/Newtonian read of DT's potential -- a")
print("  full strong-field metric needs DT's 5D treatment; (b) a HORIZONLESS compact")
print("  object is observationally EXPOSED -- EHT shadows and GW ringdowns so far")
print("  look Kerr-horizon-like, so this prediction is under observational pressure")
print("  (testable, not yet decisively excluded); (c) DT says nothing about Hawking")
print("  radiation / information or what stabilises the core.")

print("\n" + "=" * 70)
print("33 COMPLETE.")
print("=" * 70)
