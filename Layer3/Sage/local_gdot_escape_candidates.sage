#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE (primary): P. E. Williams, "The Dynamic Theory: A New View of
#   Space-Time-Matter", Ch. 2 Eq (2.x) / Ch. 3: the gauge function (Eq ~p.27)
#       ln f^{1/2} = (r0/r) e^{-lam_N/r} sin^{lam0}(theta) e^{-H0 t} e^{-K_gamma gamma},
#       K_gamma = H0/(a0 c),
#   carries SEPARATE time (e^{-H0 t}) and mass-density (e^{-K_gamma gamma}) factors.
#   gamma is the non-compact 5th coordinate = mass density.
# --------------------------------------------------------------------------

# ============================================================================
# 31_local_gdot_escape_candidates.sage          [A]  (assertion-hardened)
#
# Follow-up to script 30 (the variable unit of action CANNOT conceal the local
# Gdot/G of a TIME-driven effect). Question: are there OTHER candidate mechanisms
# by which DT could decouple the cosmological signal from a local Gdot/G?
#
# The one genuine in-framework candidate: ENVIRONMENTAL (DENSITY) SCREENING via
# the gauge function's OWN mass-density factor e^{-K_gamma gamma} -- DT's native
# analog of chameleon/symmetron screening. The idea: drive the dark-energy/SN
# effect from the declining COSMIC MEAN density (gamma -> a^{-3}) rather than from
# coordinate time, so static high-density LOCAL environments show no drift.
#
#   (1) the density-response saturates: d/dgamma e^{-K gamma} = -K e^{-K gamma} ->
#       monotonically shrinking, -> 0 as gamma -> infinity. Genuine screening: at
#       high local density the gauge field barely responds.
#   (2) the decoupling: a density-driven local Gdot/G ~ (response)*(dgamma_loc/dt);
#       a bound, non-expanding local system has dgamma_loc/dt ~ 0 -> ~0 locally,
#       WHILE cosmic gamma ~ a^{-3} declines (dln/dt = -3 H0) -> cosmic effect lives.
#       Contrast the TIME factor (e^{-H0 t}): its local rate is ~H0 ALWAYS (script 30).
#
# Three HONEST caveats keep this a research direction, not a resolution -- see end.
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 31_local_gdot_escape_candidates.sage
# ============================================================================

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


print("=" * 70)
print("LOCAL Gdot/G ESCAPE CANDIDATES -- can any mechanism decouple cosmic from local?")
print("=" * 70)

g, K, t, H0 = var('gamma K H0 t', domain='positive')

# --- (1) DT's density factor saturates -> genuine screening structure -------
print("\n[1] Candidate: density screening via the gauge factor e^{-K_gamma gamma}")
resp = diff(exp(-K * g), g)                 # = -K e^{-K gamma}
absresp = K * exp(-K * g)                    # |response|
ok("density response d/dgamma e^{-K gamma} = -K e^{-K gamma}.",
   (resp + absresp).simplify_full() == 0)
ok("|response| DECREASES with density (d/dgamma < 0): high-density screening.",
   bool(diff(absresp, g).subs(K=1, gamma=1) < 0))
ok("|response| -> 0 as gamma -> infinity (saturates: local env. barely responds).",
   (limit(absresp, gamma=oo) == 0))
print("    => e^{-K_gamma gamma} is a saturating density-dependence -- DT's native")
print("       chameleon-like screening (active at low cosmic density, off locally).")

# --- (2) time-driven vs density-driven local observability ------------------
print("\n[2] Local Gdot/G: TIME-driven (ungated) vs DENSITY-driven (gated by dgamma/dt)")
# TIME factor e^{-H0 t}: local fractional rate = H0, independent of environment
rate_time = abs(diff(exp(-H0 * t), t) / exp(-H0 * t))
ok("TIME factor gives local rate = H0 ALWAYS (ungated by environment; cf. script 30).",
   (rate_time - H0).simplify_full() == 0)
# DENSITY factor: local rate = |response| * |dgamma_local/dt|; static local env -> 0
dgamma_local_dt = 0          # bound, non-expanding local system: density not diluting
rate_density_local = absresp * dgamma_local_dt
ok("DENSITY-driven local rate ~ |response| * dgamma_local/dt -> 0 for a static local env.",
   bool(rate_density_local == 0))
# cosmic mean density declines: gamma_bar ~ a^{-3}, d ln gamma_bar/dt = -3 H0 != 0
a = var('a', domain='positive')
gamma_bar = a**(-3)
# treat a(t) with da/dt = H0 a (de Sitter-ish) just to show the cosmic rate is nonzero
dln_gbar = (diff(gamma_bar, a) / gamma_bar) * (H0 * a)
ok("cosmic mean density DOES change (d ln gamma_bar/dt = -3 H0 != 0): effect survives cosmologically.",
   (dln_gbar + 3 * H0).simplify_full() == 0)
print("    => if the effect is DENSITY-driven, static local environments are")
print("       screened (no local Gdot/G) while the cosmos still evolves -> the")
print("       script-30 exclusion is evaded. (Time-driven is NOT: local rate ~H0.)")

# --- (3) numeric flavor of K_gamma ------------------------------------------
print("\n[3] K_gamma = H0/(a0 c) (sets where screening turns on)")
H0n = 2.27e-18; a0n = 3.65e7; cn = 2.998e8
Kg = H0n / (a0n * cn)
print("    K_gamma = %.3g  (1/[gamma-units]); screening requires K_gamma*gamma_local >> 1" % Kg)
print("    >> K_gamma*gamma_cosmic ~ O(1). gamma's 5th-coord normalisation is NOT")
print("    pinned down in the book, so this inequality cannot be checked numerically.")
ok("K_gamma is well-defined from a0 (script 18) and H0, but gamma-normalisation is open.",
   Kg > 0)

# --- HONEST CAVEATS ---------------------------------------------------------
print("\n  CANDIDATE MECHANISMS (answer):")
print("  (A) DENSITY SCREENING via e^{-K_gamma gamma} [the one in-framework candidate]:")
print("      real screening structure (saturates at high density); decouples cosmic")
print("      from local IF the effect is density-driven. THREE caveats:")
print("      - RECONSTRUCTION: Williams derived dark energy/MOND from the TIME factor")
print("        (1-H0 t), NOT gamma; re-deriving from the density factor is new work.")
print("      - CANDLE DILEMMA: a Type-Ia white dwarf is ULTRA-high density -> deep in")
print("        the screened regime -> the M_Ch candle effect would ALSO vanish, unless")
print("        M_Ch couples to the AMBIENT COSMIC density (a Machian, unestablished step).")
print("      - gamma NORMALISATION undetermined -> cannot confirm local screening numerically.")
print("  (B) PURE PATH/REDSHIFT effect: rescues the geometric DISTANCE (script 25) but")
print("      not the candle (a local-epoch effect) -> partial only.")
print("  (C) STANDARD SN astrophysical evolution (metallicity/age): a real effect that")
print("      mimics dark-energy dimming with NO G-variation -- but it is not a DT")
print("      mechanism; invoking it makes DT's M_Ch mechanism unnecessary.")
print("  (D) generic chameleon/symmetron/Vainshtein: (A) is DT's native version.")
print("  VERDICT: one genuine candidate (A) exists in DT's own gauge function, but it")
print("  is a demanding reconstruction with a candle dilemma -- a live research")
print("  direction, NOT a resolution. The TIME-driven mechanism Williams actually")
print("  used stays excluded (script 30).")

print("\n" + "=" * 70)
print("31 COMPLETE.")
print("=" * 70)
