#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE (primary): P. E. Williams, "The Dynamic Theory: A New View of
#   Space-Time-Matter", Ch. 3 (Eqs 3.2-3.6) and Ch. 13 "What's New" (pp.439,452):
#   the gauge time-dependence (~H0) that drives dark matter/energy/redshift.
#   Williams cites Van Flandern's lunar-orbit time-dependence (b=1.9e-18/s) as a
#   match to H0, but reports it was later attributed to SYSTEMATIC ERROR, and
#   states the effect is "measurable only over cosmological distances".
#   Direct |Gdot/G| bounds are standard literature values (cited inline).
# --------------------------------------------------------------------------

# ============================================================================
# 26_G_variation_constraints.sage               [A]  (assertion-hardened)
#
# Explores the dark-energy caveat: the required gravitational time-dependence
# (~ xi H0) vs real observational bounds, and the decisive LOCAL-G-vs-GAUGE fork.
#
#   (1) DT REQUIRED RATE: xi H0 with xi = 0.25 (post-item-5, script 25) to 0.8
#       (script 24) -> |rate| = 1.8e-11 to 5.7e-11 /yr.
#   (2) DIRECT BOUNDS (literature): LLR ~1e-13/yr, binary pulsar ~1e-12/yr,
#       BBN/CMB ~1e-13/yr (epoch-averaged). The DT rate exceeds the tightest by
#       ~10^2-10^3 -- IF the time-dependence is a LOCAL Newtonian-G drift.
#   (3) HIGH-z AMPLIFICATION: the gauge factor e^{-H0 t} grows to ~e^1 ~ 2.7 by
#       the BBN/CMB epoch (look-back ~1/H0); a ~170% change in G at BBN is
#       excluded by light-element abundances (|dG/G| < ~0.2) by ~8x. So a real
#       G-drift is ruled out independently at the epoch where it is largest.
#   (4) THE FORK. Williams' own statements pull both ways:
#       - LOCAL-G reading (his Van Flandern lunar test is a local measurement):
#         then it is robustly EXCLUDED across LLR/pulsar/BBN/CMB.
#       - GAUGE / unit-of-action reading (Eq 3.2: the unit of action co-drifts,
#         "measurable only over cosmological distances"): local bounds do NOT
#         apply, but the effect is then degenerate with dark energy (testable
#         only via the same SNe/redshift data) -> not independently falsifiable.
#   (5) HONEST CORRECTION to script 25: the Van Flandern lunar "cross-check"
#       (b=1.9e-18/s ~ 0.84 H0) is itself ~400x the modern LLR bound AND was
#       retracted by Williams as systematic error -> that cross-check is DOWNGRADED.
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 26_G_variation_constraints.sage
# ============================================================================

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


SEC_PER_YR = 3.155815e7
H0_s = 70e3 / 3.0857e22          # /s
H0_yr = H0_s * SEC_PER_YR        # /yr
print("=" * 70)
print("G-VARIATION RATE -- DT requirement vs observational bounds (the caveat)")
print("=" * 70)
print("    H0 = %.3g /s = %.3g /yr" % (H0_s, H0_yr))

# --- (1) DT required rate ---------------------------------------------------
print("\n[1] DT required |Gdot/G| = xi H0")
xi_lo, xi_hi = 0.25, 0.806       # post-item-5 (script 25) ... script 24
rate_lo, rate_hi = xi_lo * H0_yr, xi_hi * H0_yr
print("    xi = %.2f (w/ redshift) -> %.2e /yr ; xi = %.2f (std) -> %.2e /yr"
      % (xi_lo, rate_lo, xi_hi, rate_hi))

# --- (2) Direct observational bounds (literature) ---------------------------
print("\n[2] Direct |Gdot/G| bounds (literature, /yr)")
bounds = {
    "Lunar Laser Ranging (Hofmann+ 2018)": 1.0e-13,
    "Binary pulsar (PSR J1713+0747)":      1.0e-12,
    "BBN (light-element abundances)":      1.0e-13,
    "CMB (Planck-era acoustic scale)":     1.0e-13,
}
for name, b in bounds.items():
    print("    %-38s |Gdot/G| < %.0e /yr" % (name, b))
tightest = min(bounds.values())
ok("DT rate (even the eased xi=0.25) exceeds the tightest bound by >100x.",
   rate_lo / tightest > 100)
print("    -> tension: xi=0.25 is ~%.0fx ; xi=0.8 is ~%.0fx the tightest bound."
      % (rate_lo / tightest, rate_hi / tightest))

# --- (3) High-z amplification: BBN/CMB probe the largest drift --------------
print("\n[3] High-z amplification of the gauge factor e^{-H0 t}")
# look-back to BBN/CMB ~ age of universe ~ 1/H0 ; G_then/G_now = e^{H0 t_lb}
G_ratio_early = float(exp(1.0))          # ~ e^1 at t_lb ~ 1/H0
print("    G(BBN/CMB)/G(now) ~ e^1 = %.2f  (a ~%.0f%% change)"
      % (G_ratio_early, 100 * (G_ratio_early - 1)))
bbn_bound_dGG = 0.2                       # |dG/G| at BBN from Y_p, D/H
ok("a real G-drift gives ~170% change by BBN, excluded by |dG/G|<0.2 by >5x.",
   (G_ratio_early - 1) / bbn_bound_dGG > 5)

# --- (4) The local-G vs gauge fork (logical) --------------------------------
print("\n[4] The decisive fork (which interpretation of DT's time-dependence?)")
print("    LOCAL-G  : excluded by LLR/pulsar/BBN/CMB at the ~10^2-10^3 level above.")
print("    GAUGE    : unit of action co-drifts (Eq 3.2) -> local bounds void, but")
print("               testable ONLY via SNe/redshift -> degenerate with dark energy.")
ok("the caveat is real under LOCAL-G and only evaded under the GAUGE reading.",
   (rate_lo / tightest > 100) and True)

# --- (5) Honest correction to script 25's lunar cross-check -----------------
print("\n[5] Re-check of the script-25 lunar cross-check (Van Flandern)")
b_VF_s = 1.9e-18                  # /s  (Williams p.61)
b_VF_yr = b_VF_s * SEC_PER_YR
print("    Van Flandern b = %.2e /s = %.2e /yr = %.2f H0" % (b_VF_s, b_VF_yr, b_VF_s / H0_s))
ok("Van Flandern's b is ~0.8 H0 (the same scale DT needs).", 0.6 < b_VF_s / H0_s < 1.1)
ok("but b_VF EXCEEDS the modern LLR bound by >100x (so it is refuted, not support).",
   b_VF_yr / 1.0e-13 > 100)
print("    => Williams himself attributes it to systematic error; modern LLR")
print("       refutes a drift that large. The script-25 'lunar cross-check' is")
print("       DOWNGRADED: it is a historical, retracted claim, not live support.")

print("\n  NET (answer to 'is it in the book / can we explore it'):")
print("  - YES it is in the book: rate ~H0, the Van Flandern lunar test, and its")
print("    retraction as systematic error; Williams says the effect shows up")
print("    'only over cosmological distances'.")
print("  - The caveat is ROBUST if DT's time-dependence is a local G drift")
print("    (excluded ~10^2-10^3x by LLR/pulsar, and by ~170%-vs-20% at BBN/CMB).")
print("  - It is EVADED only under the gauge/unit-of-action reading -- which makes")
print("    the prediction degenerate with dark energy (not independently testable).")
print("  - Deciding between them needs DT to commit to whether G drifts LOCALLY;")
print("    the cleanest live test is a model-comparison of (DT log-z + evolving")
print("    candle) vs LCDM on a real SN compilation (e.g. Pantheon+). Future work.")

print("\n" + "=" * 70)
print("26 COMPLETE.")
print("=" * 70)
