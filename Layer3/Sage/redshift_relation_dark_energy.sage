#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE (primary): P. E. Williams, "The Dynamic Theory: A New View of
#   Space-Time-Matter", Ch. 3 "Red Shifts, Cosmology and Dark Stuff," Eqs
#   (3.1)-(3.6), document pp. 60-61: the unit of action depends on the gauge
#   function, giving a redshift that is EXPONENTIAL in the gravitational
#   potential and (via b = -H) in the emission-reception distance. Book primary.
# --------------------------------------------------------------------------

# ============================================================================
# 25_redshift_relation_dark_energy.sage         [A]  (assertion-hardened)
#
# Item 5 (the DT redshift relation) + a SELF-CONSISTENT re-run of the dark-energy
# test (item 4b / script 24). The point: script 24 used STANDARD-cosmology
# bookkeeping (FRW distances, EdS look-back) on a DT effect. DT's own redshift
# changes the distance<->z and time<->z mappings, which feeds back on the rate
# the evolving candle needs -- and hence on the |Gdot/G| caveat.
#
#   (1) DT REDSHIFT (Eq 3.6, pure-Hubble part, b=-H): 1+z = exp(H0 L/c), so
#       L_DT(z) = (c/H0) ln(1+z). Low-z -> Hubble's law z ~ H0 L/c (recovered);
#       high-z -> SHORTER distance than the FRW comoving distance ("distances
#       ascribed by redshift are over-stated", Williams p.61).
#   (2) CROSS-CHECK: the redshift-derived H ( H^-1 = 5.6e17 s ) matches the
#       INDEPENDENT lunar-orbit time-dependence b = 1.9e-18 /s (Williams p.61) --
#       the same gauge time-dependence at cosmological and lunar scales.
#   (3) SELF-CONSISTENT DARK ENERGY: with DT's luminosity distance
#       d_L^DT = (1+z)(c/H0)ln(1+z), the geometry ALONE absorbs ~half the
#       dark-energy dimming; the evolving candle (DT look-back t_lb = ln(1+z)/H0)
#       covers the rest, needing only xi ~ 0.25 (vs 0.8 in script 24).
#   (4) CAVEAT REVISITED: |Gdot/G| ~ xi H0 falls from ~0.8 H0 to ~0.25 H0, cutting
#       the tension with direct bounds (~1e-3 H0) from ~800x to ~250x. REDUCED
#       ~3x by item 5, but NOT eliminated -- the G-variation objection survives.
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 25_redshift_relation_dark_energy.sage
# ============================================================================

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


def rel(a, b):
    return abs(float(a) - float(b)) / abs(float(b))


LN10 = float(log(10))
c = 2.99792458e8
Mpc = 3.0857e22
H0 = 70e3 / Mpc                      # s^-1


print("=" * 70)
print("DT REDSHIFT RELATION (item 5) + self-consistent dark-energy re-test")
print("=" * 70)

# --- (1) DT redshift: exponential in distance -> L = (c/H0) ln(1+z) ----------
print("\n[1] DT redshift (Eq 3.6, Hubble part): 1+z = exp(H0 L/c)")
L = var('L', domain='positive')
z_of_L = exp(H0 * L / c) - 1
# low-z (small L): Hubble's law z ~ H0 L/c
series_lin = z_of_L.taylor(L, 0, 1)
ok("low-z limit recovers Hubble's law z ~ H0 L/c.",
   rel(series_lin.coefficient(L, 1), H0 / c) < 1e-9)


def L_DT(z):                          # DT distance from redshift [m]
    return (c / H0) * log(1 + z)


# high-z: DT distance shorter than FRW comoving distance (LCDM)
def inv_E_LCDM(zp):
    return 1.0 / sqrt(0.3 * (1 + zp)**3 + 0.7)


def D_comov_LCDM(z):                  # [m]
    return (c / H0) * numerical_integral(inv_E_LCDM, 0, z)[0]


for z in (0.5, 1.0):
    ratio = float(L_DT(z) / D_comov_LCDM(z))
    print("    z=%.1f : L_DT/D_comov(LCDM) = %.3f  (DT distance shorter)" % (z, ratio))
ok("DT redshift-distance is shorter than the FRW comoving distance at z=1.",
   float(L_DT(1.0)) < float(D_comov_LCDM(1.0)))

# --- (2) Cross-check: redshift H matches the lunar-orbit time-dependence -----
print("\n[2] Cross-check: redshift-derived H vs lunar-orbit b (same gauge dep.)")
H_redshift = 1.0 / 5.6e17             # s^-1  (Williams: H^-1 = 5.6e17 s)
b_lunar = 1.9e-18                     # s^-1  (Williams p.61, moon's orbit)
print("    H(redshift) = %.3g /s = %.0f km/s/Mpc ;  b(lunar) = %.3g /s"
      % (H_redshift, H_redshift * Mpc / 1e3, b_lunar))
ok("redshift H matches the lunar-orbit time-dependence within 15%.",
   rel(H_redshift, b_lunar) < 0.15)

# --- (3) Self-consistent dark energy: DT distance + evolving candle ----------
print("\n[3] Self-consistent re-run: DT luminosity distance + evolving candle")
# observed SN Hubble diagram ~ LCDM; DT must give mu_LCDM = 5log10(d_L^DT) + dm_candle
def dm_candle_needed(z):
    dL_lcdm = (1 + z) * D_comov_LCDM(z)
    dL_dt = (1 + z) * float(L_DT(z))
    return 5.0 * log(dL_lcdm / dL_dt) / LN10          # mag the candle must supply


def xi_needed(z):
    # dm_candle = (15/4) * xi * H0 * t_lb / ln10, with DT t_lb = ln(1+z)/H0
    return dm_candle_needed(z) / ((15.0 / 4.0) * log(1 + z) / LN10)


for z in (0.5, 1.0):
    print("    z=%.1f : geometry supplies most of the dimming; candle needs "
          "dm=%.3f mag -> xi=%.3f" % (z, dm_candle_needed(z), xi_needed(z)))
xi05, xi10 = xi_needed(0.5), xi_needed(1.0)
ok("self-consistent candle rate xi is much smaller than script 24's 0.8 (xi < 0.4).",
   xi05 < 0.4 and xi10 < 0.4)
ok("xi is still order ~0.2-0.3 (DT geometry absorbs ~half, candle the rest).",
   0.15 < xi05 < 0.4)

# --- (4) The |Gdot/G| caveat, revisited -------------------------------------
print("\n[4] Caveat revisited: required |Gdot/G| vs direct bounds")
xi_use = max(xi05, xi10)
tension_24 = 0.806 / 1e-3             # script-24 tension (~800x)
tension_25 = xi_use / 1e-3
print("    script 24 (standard bookkeeping): |Gdot/G| ~ 0.81 H0 -> ~%.0fx bounds" % tension_24)
print("    script 25 (DT redshift folded in): |Gdot/G| ~ %.2f H0 -> ~%.0fx bounds"
      % (xi_use, tension_25))
ok("item 5 REDUCES the tension by ~2-4x relative to script 24.",
   2.0 < tension_24 / tension_25 < 4.0)
ok("but the tension is NOT eliminated (still >100x direct bounds).",
   tension_25 > 100)

print("\n  NET: DT's redshift relation (item 5) is a real, self-consistent piece --")
print("  it recovers Hubble's law, cross-checks against the lunar-orbit time-")
print("  dependence, and its log distance-redshift absorbs ~half the dark-energy")
print("  dimming geometrically, so the evolving candle needs only xi~0.25 (not 0.8).")
print("  This CUTS the |Gdot/G| tension ~3x (from ~800x to ~250x direct bounds) but")
print("  does NOT remove it. Dark energy is more plausibly absorbed in the full DT")
print("  picture; the residual objection is the still-large G-variation rate.")

print("\n" + "=" * 70)
print("25 COMPLETE.")
print("=" * 70)
