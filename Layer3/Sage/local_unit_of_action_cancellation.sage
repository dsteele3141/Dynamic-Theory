#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE (primary): P. E. Williams, "The Dynamic Theory: A New View of
#   Space-Time-Matter", Ch. 3: the variable unit of action Eq (3.2)-(3.3)
#       hbar(t) = hbar0 * exp[ (W/R)(1 + b t) e^{-lambda/R} ],  W = -GM/c^2, b = -H0,
#   and the time-dependent LOCAL gravity Eq (3.52) (TOV / orbit):
#       dp/dr = -G M (1 - H0 tau) rho / r^2    (also Eq 10.66 for orbits).
# --------------------------------------------------------------------------

# ============================================================================
# 30_local_unit_of_action_cancellation.sage     [A]  (assertion-hardened)
#
# THE DECISIVE CALCULATION for the |Gdot/G| fork: does DT's VARIABLE UNIT OF
# ACTION (Eq 3.2/3.3) CANCEL the time-dependence of LOCAL gravity (Eq 3.52) in a
# local measurement (e.g. lunar laser ranging), so the drift is unobservable
# locally (the "gauge escape")? Or does it leave a full-rate residual (the
# "local-G" reading, which LLR/BBN/CMB exclude)?
#
# The crux is the STRUCTURE of Eq 3.3: the time-factor (1 + b t) enters
# MULTIPLIED by the gravitational potential W/R = -Phi/c^2. Hence:
#   * unit-of-action drift:  d ln hbar/dt = (Phi/c^2) H0 e^{-lambda/R}  ~ (Phi/c^2) H0
#       -> POTENTIAL-SUPPRESSED (Phi/c^2 ~ 1e-8...1e-11 locally).
#   * gravitational-binding drift (Eq 3.52): d ln(G M_eff)/dt = -H0   (FULL rate).
# A local gravitational observable read against atomic clocks/rulers (which scale
# as powers of hbar) drifts at  ~ H0 * (1 - O(Phi/c^2)) ~ H0 : the cancellation
# is incomplete by ~Phi/c^2, i.e. it FAILS by 8+ orders of magnitude.
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 30_local_unit_of_action_cancellation.sage
# ============================================================================

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


c = 2.99792458e8
G = 6.674e-11
H0_s = 70e3 / 3.0857e22                 # /s
SEC_YR = 3.155815e7
H0_yr = H0_s * SEC_YR

print("=" * 70)
print("LOCAL CANCELLATION TEST -- does the variable unit of action (Eq 3.2/3.3)")
print("hide the gravitational time-dependence (Eq 3.52) from a local measurement?")
print("=" * 70)

# --- (0) Symbolic: confirm the potential-suppression of the hbar drift ------
print("\n[0] Symbolic structure of Eq 3.3")
t, H0, Phi_c2, lam, R = var('t H0 Phi_c2 lam R', domain='positive')
# Eq 3.3 exponent with W/R = -Phi/c^2 and b = -H0:
ln_hbar = (-Phi_c2) * (1 - H0 * t) * exp(-lam / R)        # ln(hbar/hbar0)
rate_hbar = diff(ln_hbar, t)                              # d ln hbar / dt
ok("d ln(hbar)/dt = +(Phi/c^2) H0 e^{-lam/R}  (potential-SUPPRESSED).",
   (rate_hbar - Phi_c2 * H0 * exp(-lam / R)).simplify_full() == 0)
# Eq 3.52: G M_eff = G M (1 - H0 tau) -> full-rate drift -H0
gm = (1 - H0 * t)
ok("d ln(G M_eff)/dt = -H0/(1-H0 t) -> -H0 at t=0 (FULL rate, no suppression).",
   (diff(gm, t) / gm).subs(t=0) == -H0)

# --- (1) Local potentials Phi/c^2 (the suppression factor) ------------------
print("\n[1] Gravitational potential Phi/c^2 at relevant local sites")
sites = {
    "Earth surface (GM_E/R_E)":   3.986e14 / (6.371e6 * c**2),
    "Moon's orbit (GM_E/r_Moon)": 3.986e14 / (3.844e8 * c**2),
    "Sun at Earth (GM_S/AU)":     1.327e20 / (1.496e11 * c**2),
}
for name, p in sites.items():
    print("    %-28s Phi/c^2 = %.2e" % (name, p))
Phi_max = max(sites.values())           # most generous (largest) -> best case for cancellation
print("    most generous (largest) Phi/c^2 = %.2e (Sun at Earth)" % Phi_max)
ok("the largest local Phi/c^2 is tiny (< 1e-7).", Phi_max < 1e-7)

# --- (2) The two drift rates, in units of H0 --------------------------------
print("\n[2] Drift rates (units of H0)")
rate_grav = 1.0                          # |d ln(GM_eff)/dt| / H0  (Eq 3.52, full)
rate_units = Phi_max                     # |d ln(hbar)/dt| / H0  ~ Phi/c^2 (Eq 3.3)
print("    gravitational binding (Eq 3.52): |rate|/H0 = %.3g" % rate_grav)
print("    unit of action       (Eq 3.3) : |rate|/H0 = %.3g  (e^{-lam/R}~1 macroscopically)"
      % rate_units)
ok("the unit-of-action drift is >1e6 times SMALLER than the gravitational drift.",
   rate_grav / rate_units > 1e6)

# --- (3) Residual LOCAL observable: does it cancel? -------------------------
print("\n[3] Local observable (orbit measured in atomic units): residual drift")
# atomic time/length scales ~ hbar^p, p = O(1) (e.g. atomic time ~ hbar^3); take p=3
p_atom = 3.0
residual = abs(rate_grav - p_atom * rate_units)          # in units of H0
print("    inferred |Gdot/G|_local / H0 = |1 - %g*(Phi/c^2)| = %.6f" % (p_atom, residual))
ok("the residual local drift is ~H0 (cancellation incomplete by ~Phi/c^2 ~ 1e-8).",
   abs(residual - 1.0) < 1e-6)
print("    => cancellation FAILS by a factor ~1/(Phi/c^2) ~ %.0e." % (1.0 / Phi_max))

# --- (4) Versus the lunar-laser-ranging bound -------------------------------
print("\n[4] Confront the LLR bound")
gdot_local_yr = residual * H0_yr
llr = 1.0e-13                            # /yr (Hofmann+ 2018)
print("    DT predicts local |Gdot/G| ~ %.2e /yr ; LLR bound ~ %.0e /yr -> exceeds by ~%.0fx"
      % (gdot_local_yr, llr, gdot_local_yr / llr))
ok("DT's local Gdot/G (on its own Eqs 3.2+3.52) exceeds the LLR bound by >100x.",
   gdot_local_yr / llr > 100)

print("\n  VERDICT (the calculation settles the fork):")
print("  On Williams' OWN equations the variable unit of action does NOT cancel the")
print("  gravitational time-dependence locally: Eq 3.3 ties the unit-of-action drift")
print("  to the gravitational potential (Phi/c^2 ~ 1e-8 locally), while Eq 3.52 drifts")
print("  at the full rate H0. The residual is ~H0 -- a LOCALLY OBSERVABLE Gdot/G that")
print("  LLR excludes by ~%.0fx. So the fork resolves to the LOCAL-G reading, and the" % (gdot_local_yr / llr))
print("  gauge escape FAILS on DT's own machinery: DT's dark-energy time-dependence is")
print("  excluded by local G-variation bounds.")
print("  (Caveat: this is forced by Eq 3.3's structure -- the time factor enters x W/R.")
print("   A gauge escape would need an un-suppressed, potential-INDEPENDENT hbar(t),")
print("   which Eq 3.3 does NOT provide. So the escape is not available as DT is written.)")

print("\n" + "=" * 70)
print("30 COMPLETE.")
print("=" * 70)
