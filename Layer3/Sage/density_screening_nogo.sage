#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE: follow-up to script 31. Tests whether the density-screening escape
#   (drive dark energy from DT's gauge factor e^{-K_gamma gamma}, gamma = mass
#   density, rather than from coordinate time) can ACTUALLY work for dark energy,
#   or whether the "white-dwarf candle dilemma" is a structural NO-GO.
# --------------------------------------------------------------------------

# ============================================================================
# 32_density_screening_nogo.sage                [A]  (assertion-hardened)
#
# Is the density-screening reconstruction POSSIBLE for dark energy? The
# mechanism requires TWO things at once:
#   (i)  LLR passes  -> the local test body (Earth/Moon) must be SCREENED
#        (gauge response small at its density),
#   (ii) the candle works -> the Type-Ia WHITE DWARF's Chandrasekhar mass must
#        RESPOND to cosmic epoch (gauge response NOT small at the WD).
# But the screening response is MONOTONICALLY DECREASING in density (script 31:
# R(rho) ~ e^{-K rho}), and the density ORDERING is
#        rho_WD  >>  rho_local(Earth/Moon)  >>  rho_cosmic.
# The WD is the DENSEST object -> the MOST screened. So (i) and (ii) are mutually
# exclusive: screen the local body and the (denser) WD is screened even harder
# (candle dead); un-screen the WD and the (less dense) local body is un-screened
# too (LLR fails). A structural NO-GO for any LOCAL-density-based screening.
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 32_density_screening_nogo.sage
# ============================================================================

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


print("=" * 70)
print("DENSITY-SCREENING RECONSTRUCTION -- possible for dark energy? (NO-GO test)")
print("=" * 70)

# --- (1) the density ordering (kg/m^3) --------------------------------------
print("\n[1] Mass-density ordering of the relevant environments")
rho_WD = 1e9          # Chandrasekhar-mass white dwarf, mean (~1e6 g/cc) -- conservative (low)
rho_local = 3.3e3     # the LLR test body (Moon ~3340; Earth ~5500 kg/m^3)
rho_cosmic = 2.7e-27  # cosmic mean matter density (Omega_m rho_crit)
print("    rho_WD     = %.1e kg/m^3   (Type-Ia white dwarf)" % rho_WD)
print("    rho_local  = %.1e kg/m^3   (Earth/Moon -- the LLR test bodies)" % rho_local)
print("    rho_cosmic = %.1e kg/m^3   (cosmic mean)" % rho_cosmic)
ok("rho_WD >> rho_local >> rho_cosmic (the WD is the DENSEST object).",
   rho_WD > rho_local > rho_cosmic)

# --- (2) screening is monotonic decreasing in density (script 31) -----------
print("\n[2] Screening response R(rho) = exp(-kappa rho) is monotone DECREASING")
kappa = var('kappa', domain='positive')
rho = var('rho', domain='positive')
R = exp(-kappa * rho)
ok("dR/drho < 0 (denser -> more screened; from script 31's saturating e^{-K gamma}).",
   bool(diff(R, rho).subs(kappa=1, rho=1) < 0))

# --- (3) the two horns -- mutually exclusive --------------------------------
print("\n[3] The dilemma's two horns (kappa scaled so 'screened' means R < ~0.01)")

def Rnum(kap, r):
    return float(exp(-kap * r))

# HORN A: tune kappa so the LOCAL body is screened (R_local <= 0.01) -> LLR passes
kapA = float(log(100)) / rho_local                 # R_local = 0.01
RA_local, RA_WD = Rnum(kapA, rho_local), Rnum(kapA, rho_WD)
print("    HORN A (screen local: R_local=%.2f): R_WD = %.3g -> candle response ~0"
      % (RA_local, RA_WD))
ok("HORN A: screening the local body makes the (denser) WD response ~0 -> candle DEAD.",
   RA_WD < 1e-6)

# HORN B: tune kappa so the WD responds (R_WD >= 0.5) -> candle can work
kapB = float(log(2)) / rho_WD                       # R_WD = 0.5
RB_WD, RB_local = Rnum(kapB, rho_WD), Rnum(kapB, rho_local)
print("    HORN B (un-screen WD: R_WD=%.2f): R_local = %.6f -> local NOT screened"
      % (RB_WD, RB_local))
ok("HORN B: keeping the WD responsive leaves the local body un-screened (R_local~1) -> LLR FAILS.",
   RB_local > 0.99)

print("    => no single kappa screens the local body AND keeps the WD responsive:")
print("       the requirements are mutually exclusive (density ordering + monotonicity).")

# --- (4) the candle-free fallback also fails --------------------------------
print("\n[4] Fallback: drop the candle, keep only the local-Gdot-safe redshift distance")
chi2_DT_nocandle = 324.8       # script 27: DT log-z distance ONLY (no candle)
chi2_LCDM = 51.3               # script 27
chi2_EdS = 1469.0
print("    DT path-only (no candle): chi2 = %.0f vs LambdaCDM %.0f (EdS %.0f)"
      % (chi2_DT_nocandle, chi2_LCDM, chi2_EdS))
ok("the candle-free (local-safe) DT is a POOR fit -- chi2 far above LambdaCDM (>200 worse).",
   (chi2_DT_nocandle - chi2_LCDM) > 200)
print("    => the candle is load-bearing (it carries ~half the signal); removing it")
print("       to dodge the WD dilemma leaves DT a poor fit. No safe route recovers DE.")

print("\n  VERDICT (answer: is the density-screening reconstruction possible?):")
print("  For DARK ENERGY -- essentially NO. It is a structural no-go, not a caveat:")
print("  any LOCAL-density screening strong enough to pass LLR also screens the")
print("  (much denser) Type-Ia white dwarf, freezing the Chandrasekhar candle that")
print("  IS the dark-energy mechanism. And the only local-Gdot-safe piece (the")
print("  redshift distance, candle-free) fits the SN data poorly. The escape would")
print("  need a NON-LOCAL/cosmic-mean coupling that distinguishes the WD's bulk from")
print("  its environment -- which standard (self-screening) chameleon physics does")
print("  NOT provide and DT does not contain.")
print("  (For DARK MATTER the situation is different and fine: MOND-type modification")
print("   is ACCELERATION-thresholded at a0~cH0, naturally off in the solar system --")
print("   it never had the local-Gdot problem; see script 23.)")

print("\n" + "=" * 70)
print("32 COMPLETE.")
print("=" * 70)
