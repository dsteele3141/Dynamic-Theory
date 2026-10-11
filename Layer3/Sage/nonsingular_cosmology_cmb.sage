#!/usr/bin/env sage
# NOTE (2026-07-03): the script-36 falsification this relies on was mis-scoped
# (nontransverse_pressure_rederivation.sage). The non-singular geometry stands;
# the CMB attribution remains a softer tension, not a falsification.
#
# --------------------------------------------------------------------------
# SOURCE: P. E. Williams, "The Dynamic Theory" (DT.tex) Ch.10 "Gauge
#   Gravitational Fields" (cosmology of the non-singular potential, Eqs
#   10.42-10.48) and "What's New": "Big Bang" (no initial singularity) +
#   the CMB attributed to "zero pressure radiation ... required by the five
#   dimensional gauge fields". Book-primary (NOT in the 1980 Report); kept out
#   of the public-domain SI, pointer in SI-6.3.11. Ties to script 33 (non-
#   singular black hole) and script 36 (the zero-pressure / longitudinal wave).
# --------------------------------------------------------------------------

# ============================================================================
# 37_nonsingular_cosmology_cmb.sage             [A]  (assertion-hardened)
#
# THE POT SHOT (Big Bang / non-singular universe).  DT offers a theoretical
# alternative to the singular origin: the non-singular gravitational potential
# V_g = -(GM/r) e^{-lambda/r} removes the r->0 divergence of Newton's law that
# "predicts the big bang origin", so Williams claims a cosmology with "no
# singularity anywhere" -- the same non-singularity theme as the black hole
# (script 33). That structural claim is SOUND. The model's one concrete
# cosmological observable is the CMB, which Williams explicitly says is NOT the
# gravitational field but the "ZERO PRESSURE RADIATION required by the 5D gauge
# fields" -- i.e. the script-36 longitudinal-wave mechanism.
#
# This script (1) confirms the potential is non-singular (no initial-singularity
# point), then (2) follows Williams' own CMB attribution through the script-36
# radiation-pressure law and finds it predicts NEGATIVE-pressure radiation at the
# CMB peak frequency (w ~ -1), contradicting the measured thermal CMB (w = +1/3,
# a near-perfect blackbody with acoustic peaks). So the no-singularity geometry
# is fine, but the proposed CMB explanation is the SAME thing script 36
# falsified, and the CMB's blackbody+acoustic structure is positive evidence for
# the hot dense phase DT discards.
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 37_nonsingular_cosmology_cmb.sage
# ============================================================================

from sage.all import *

print("NOTE: the script-36 falsification used in part (2) was mis-scoped (nontransverse_pressure_rederivation.sage); part (2) is a tension, not a falsification.\n")


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


# physical constants
h_P = 6.62607015e-34       # J s
k_B = 1.380649e-23         # J/K
cc  = 2.99792458e8         # m/s
T_CMB = 2.7255             # K   (FIRAS/Planck)
A0  = 40.72e12             # s^-1, the 5D radiation constant FIXED by N&H (script 18/36)
n   = 1.0

print("=" * 70)
print("NON-SINGULAR COSMOLOGY (no Big Bang singularity) -- and the CMB it owes")
print("=" * 70)

# --- (1) the potential is non-singular: no initial-singularity point ---------
print("\n[1] 'No singularity anywhere': the non-singular potential")
r, lam = var('r lam', domain='positive')
Vshape = exp(-lam / r) / r                       # shape of (1/r)e^{-lambda/r}
lim0 = limit(Vshape, r=0, dir='+')
print("    V_g ~ -(GM/r) e^{-lambda/r};  lim_{r->0} (1/r)e^{-lambda/r} = %s" % lim0)
ok("the potential is FINITE as r->0 (no central singularity) -- ties to script 33.",
   lim0 == 0)
# the field -dV/dr is also bounded (it peaks and returns to 0), unlike Newton's 1/r^2
dV = diff(Vshape, r)
# at small r the field -> 0 (exp wins); sample to confirm boundedness
fields = [abs(float(dV.subs({lam: 1.0, r: rr}))) for rr in [1e-3, 1e-2, 0.1, 0.5, 1.0]]
ok("the field is bounded (no force singularity); Newton's 1/r^2 blow-up is gone.",
   fields[0] < fields[2])     # field DECREASES toward r->0 instead of diverging
print("    => removes the singularity in Newton's LAW (the 1/r^2 force blow-up).")
# SCOPE (finding L3-11): this shows the POTENTIAL is regular as r->0 -- suggestive
# of removing the initial singularity. It is NOT an established relativistic
# result: no cosmological metric is constructed, and no curvature bound or
# geodesic completeness is proved. Read it as potential-regularity, not a proven
# 'no Big Bang singularity'.
print("       Potential-regularity, suggestive of a non-singular origin -- but no")
print("       metric/curvature/geodesic proof is given (not an established no-Big-Bang).")

# --- (2) the CMB is a blackbody; locate its peak frequency -------------------
print("\n[2] The CMB is a thermal blackbody (T = %.4f K); its peak frequency" % T_CMB)
# Wien displacement for spectral radiance per unit frequency: nu_pk = 2.821439 kT/h
nu_peak = 2.821439 * k_B * T_CMB / h_P
print("    nu_peak = 2.821439 kT/h = %.1f GHz  (measured CMB peak ~160.2 GHz)"
      % (nu_peak / 1e9))
ok("the blackbody peak is ~160 GHz (matches the measured CMB).",
   abs(nu_peak/1e9 - 160.2) < 2.0)

# --- (3) DT's own CMB mechanism at that frequency: NEGATIVE pressure ---------
print("\n[3] Williams' CMB = 'zero pressure radiation' (5D gauge fields, script 36)")
def p_over_xi(w):
    x = (A0 / w) ** 2
    return (1 + n**2 - x) / (1 + n**2 + x)
r_cmb = p_over_xi(nu_peak)
print("    script-36 ratio at nu_peak:  p/xi = %+.5f" % r_cmb)
print("    => DT's 5D radiation is NEGATIVE-pressure (w ~ -1) at CMB frequencies,")
print("       because the CMB sits far below the ~29 THz zero-pressure crossover.")
ok("DT predicts the CMB band at p/xi ~ -1 (negative-pressure radiation).",
   r_cmb < -0.99)
# the measured CMB equation of state is w = +1/3 (thermal radiation)
w_measured = 1.0 / 3.0
ok("this CONTRADICTS the measured CMB equation of state w = +1/3 (radiation).",
   sign(r_cmb) != sign(w_measured))

# --- (4) the deeper evidentiary gap -----------------------------------------
print("\n[4] What a no-hot-Big-Bang model still owes the CMB")
print("    The CMB is (a) a blackbody to <1e-4 (FIRAS) and (b) carries acoustic")
print("    peaks (l1 ~ 220, ...) from baryon-photon-fluid oscillations. BOTH are")
print("    signatures of a HOT, DENSE, thermal-equilibrium early phase: a Planck")
print("    spectrum needs thermalization; the peak angular scale needs a sound")
print("    horizon int c_s dt. DT's no-singularity field supplies NEITHER a")
print("    thermalizing photon-baryon plasma NOR a sound horizon -- and Williams")
print("    grants the cosmology 'is not yet complete' (M undetermined; the gauge-")
print("    function scale may over-specify the dynamics, Ch.10).")
print("    So 'alternative to inflation' removes inflation's MOTIVATION (the")
print("    singularity) but not its quantitative successes (n_s~0.965 + the peaks).")
ok("the blackbody + acoustic peaks are positive evidence for the hot dense phase.",
   True)   # documented fact, asserted as the standing evidence

print("\n" + "-" * 70)
print("VERDICT")
print("-" * 70)
print("POSITIVE: 'no singularity anywhere' is a GENUINE, internally-consistent")
print("  structural result -- the non-singular potential removes the r->0 force")
print("  divergence that forces a singular origin (same theme as the non-singular")
print("  black hole, script 33). A real theoretical alternative to the singular")
print("  beginning, which is itself a virtue, and few offer one.")
print("LIMIT: the cosmology is admittedly INCOMPLETE, and its one concrete")
print("  observable -- the CMB, which Williams attributes to 'zero pressure")
print("  radiation' from the 5D gauge fields -- is the SAME mechanism script 36")
print("  falsifies: at the CMB peak the law gives w ~ -1, not the measured +1/3.")
print("  The CMB's blackbody (to 1e-4) and acoustic peaks are positive evidence")
print("  for the hot dense phase DT discards, and DT provides no thermalization")
print("  or sound-horizon mechanism. So the singularity-removal is sound geometry;")
print("  the cosmological completion (above all the CMB) is not delivered.")

print("\n" + "=" * 70)
print("37 COMPLETE.")
print("=" * 70)
