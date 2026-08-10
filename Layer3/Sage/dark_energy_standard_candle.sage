#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE (primary): P. E. Williams, "The Dynamic Theory: A New View of
#   Space-Time-Matter", Ch. 3 "Red Shifts, Cosmology and Dark Stuff," Eqs
#   (3.37)-(3.56), document pp. 71-76: the time-dependent gravitational field
#   makes the Type-Ia Chandrasekhar mass (hence the standard-candle luminosity)
#   epoch-dependent, so the inferred cosmic acceleration ("dark energy") can be
#   an artifact. Book primary (not in the 1980 Report).
# --------------------------------------------------------------------------

# ============================================================================
# 24_dark_energy_standard_candle.sage           [A]  (assertion-hardened)
#
# "Make dark energy disappear": does an epoch-dependent SN-Ia standard candle,
# from DT's time-dependent gravity, reproduce the observed magnitude residual
# WITHOUT a cosmological constant? Test, honestly.
#
#   physics: peak luminosity L ~ M_Ch ~ G^{-3/2} (Chandrasekhar). DT: G weakens
#   with time, so PAST (high-z) SNe had a DIFFERENT M_Ch -> different L. The
#   apparent "dimming" attributed to dark energy can instead be intrinsic.
#
#   (1) THE SIGNAL. Compute the magnitude residual that dark energy explains:
#       mu_LCDM(z) - mu_EdS(z) (flat 0.3/0.7 vs decelerating Omega_M=1). ~0.4 mag
#       at z=0.5, ~0.6 at z=1 (positive = high-z appears fainter).
#   (2) DT CANDLE. With G(z)/G0 = exp(xi H0 t_lb(z)) (weakening; larger in the
#       past) and L ~ G^{-3/2}: intrinsic dimming Delta m = (15/4) log10(G_past/G0)
#       -- correct SIGN (past fainter).
#   (3) FIT + SHAPE. The single rate xi that cancels the signal is ORDER UNITY and
#       nearly the SAME at z=0.5 and z=1 (a genuine redshift-shape match): one
#       H0-scale parameter absorbs the dark-energy Hubble-diagram residual.
#   (4) HONEST BOUNDS. (a) it trades Omega_Lambda for a fitted G-rate (one
#       parameter for one). (b) the required rate ~ H0 implies |Gdot/G| ~ H0,
#       which EXCEEDS direct laboratory/solar-system bounds (~1e-3 H0) by >100x
#       -- the strongest objection. (c) Williams' own (1-H0 tau)^4 law (Eq 3.55)
#       is far too steep and OVERSHOOTS the signal severalfold.
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 24_dark_energy_standard_candle.sage
# ============================================================================

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


LN10 = float(log(10))


# --- (1) The dark-energy magnitude signal: mu_LCDM - mu_EdS -----------------
def inv_E_LCDM(zp):
    return 1.0 / sqrt(0.3 * (1 + zp)**3 + 0.7)


def inv_E_EdS(zp):
    return 1.0 / sqrt((1 + zp)**3)


def dm_signal(z):
    # comoving integral ratio; the (1+z) prefactor of d_L cancels in the ratio
    I_l = numerical_integral(inv_E_LCDM, 0, z)[0]
    I_e = numerical_integral(inv_E_EdS, 0, z)[0]
    return 5.0 * log(I_l / I_e) / LN10        # magnitudes


print("=" * 70)
print("DARK ENERGY -- can a time-dependent Chandrasekhar candle absorb it?")
print("=" * 70)

print("\n[1] The signal dark energy explains: mu_LCDM(z) - mu_EdS(z)")
sig05, sig10 = dm_signal(0.5), dm_signal(1.0)
print("    Delta m(z=0.5) = %.3f mag ;  Delta m(z=1.0) = %.3f mag  (high-z fainter)"
      % (sig05, sig10))
ok("the dark-energy residual is positive (high-z fainter), ~0.2-0.6 mag at z=0.5.",
   0.2 < sig05 < 0.6)


# --- (2)-(3) DT evolving candle: L ~ M_Ch ~ G^{-3/2}, G weakening at rate xi*H0
def H0_tlb(z):
    # EdS look-back time in units of 1/H0:  (2/3)[1 - (1+z)^{-3/2}]
    return (2.0 / 3.0) * (1 - (1 + z)**(-1.5))


def dm_DT(z, xi):
    # G_past/G0 = exp(xi * H0 t_lb); L ~ G^{-3/2} => Delta m = (15/4) log10(G_past/G0)
    return (15.0 / 4.0) * (xi * H0_tlb(z)) / LN10


print("\n[2] DT candle dims the PAST (correct sign): Delta m = (15/4) log10(G_past/G0)")
ok("DT predicts high-z dimming (Delta m > 0) for a past-stronger G.", dm_DT(0.5, 1.0) > 0)

print("\n[3] Rate xi that cancels the signal, and its redshift-shape consistency")
xi_05 = sig05 / dm_DT(0.5, 1.0)
xi_10 = sig10 / dm_DT(1.0, 1.0)
print("    xi(z=0.5) = %.3f ;  xi(z=1.0) = %.3f   (order unity = H0 scale)"
      % (xi_05, xi_10))
ok("the cancelling rate xi is ORDER UNITY (between 0.3 and 3).", 0.3 < xi_05 < 3.0)
ok("a SINGLE xi fits both z=0.5 and z=1.0 (within 15%): a real shape match.",
   abs(xi_05 - xi_10) / xi_05 < 0.15)
print("    => one H0-scale rate reproduces the dark-energy residual across z.")

print("\n[4] Honest bounds")
# (b) the required Gdot/G ~ xi H0 vs the direct observational bound ~1e-3 H0
gdot_over_H0 = xi_05                      # |Gdot/G| in units of H0 (rate ~ xi H0)
bound_over_H0 = 1e-3                      # direct |Gdot/G| bounds ~ 1e-3 H0
print("    required |Gdot/G| ~ %.2f H0 ; direct bound ~ %.0e H0 -> exceeds by %.0fx"
      % (gdot_over_H0, bound_over_H0, gdot_over_H0 / bound_over_H0))
ok("the required G-variation exceeds direct |Gdot/G| bounds by >100x (key objection).",
   gdot_over_H0 / bound_over_H0 > 100)


# (c) Williams' own (1-H0 tau)^4 law overshoots the signal severalfold
def dm_williams_pow4(z):
    # L ~ M_Ch ~ (1+H0 t_lb)^4 in the past;  Delta m = -2.5 log10[(1+H0 t_lb)^4]
    return abs(-2.5 * 4 * log(1 + H0_tlb(z)) / LN10)

dmw = dm_williams_pow4(0.5)
print("    Williams (1-H0 tau)^4 (Eq 3.55): |Delta m(0.5)| = %.2f mag vs signal %.2f"
      % (dmw, sig05))
ok("Williams' power-4 law overshoots the signal by >2x (Eq 3.54->3.55 too steep).",
   dmw / sig05 > 2.0)

print("\n  NET: the mechanism is SOUND and right-order -- an epoch-dependent")
print("  Chandrasekhar candle (L ~ G^{-3/2}, G weakening at ~H0) reproduces the")
print("  dark-energy magnitude residual in sign, size, AND redshift shape with one")
print("  order-unity rate -> dark energy CAN be an evolving-candle artifact in DT.")
print("  BUT: it trades Omega_Lambda for a fitted G-rate; that rate (~H0) is ~10^3x")
print("  above direct |Gdot/G| bounds (the key objection); and Williams' specific")
print("  (1-H0 tau)^4 law overshoots. Verdict: plausible in-framework, but in")
print("  tension with independent G-variation limits -- NOT as clean as the")
print("  rotation-curve/MOND result. Full write-up: mass-sector-postdictions.txt.")

print("\n" + "=" * 70)
print("24 COMPLETE.")
print("=" * 70)
