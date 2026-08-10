#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE: diagnostic on the Pantheon binned SN-Ia fit (scripts 27/29). Asks
#   whether the two highest-z bins (z~1.23, 1.61) -- which sit below the model
#   curves in 02_results/dark_energy_hubble.png -- are a real misfit or an
#   instrumental/systematic effect. DATA: Pantheon binned (Scolnic+ 2018).
# --------------------------------------------------------------------------

# ============================================================================
# 35_highz_residual_diagnostic.sage             [A]  (assertion-hardened)
#
# The two z~1 bins are the rarest, HST-observed SNe with the largest calibration
# systematics. This checks: (a) are their error bars the largest? (b) how many
# sigma are they off LambdaCDM/DT? (c) do they DRIVE the DT-vs-LambdaCDM residual
# (which script 29 showed collapses under the full systematic covariance)?
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 35_highz_residual_diagnostic.sage
# ============================================================================

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


LN10 = float(log(10))
DATA = [
 (0.0140,14.57001926,0.0311),(0.0194,15.2279603507,0.02645),(0.0264,15.934102317,0.0231),
 (0.0329,16.4217829558,0.0235),(0.0396,16.836418956,0.02845),(0.0475,17.2346439906,0.0334),
 (0.0560,17.5758459622,0.03215),(0.0640,17.9104543501,0.0439),(0.0721,18.1780074589,0.03865),
 (0.0811,18.5543855764,0.04225),(0.0889,18.7006554037,0.03635),(0.1001,19.0388242428,0.03515),
 (0.1071,19.1720185353,0.03355),(0.1195,19.3711295152,0.0260),(0.1278,19.5555026238,0.02635),
 (0.1396,19.8185930766,0.02335),(0.1519,19.9445025196,0.0237),(0.1635,20.0642537602,0.02585),
 (0.1778,20.3389008923,0.01965),(0.1906,20.5047456137,0.02205),(0.2067,20.6854007995,0.0214),
 (0.2216,20.8610322507,0.0233),(0.2405,21.0518440051,0.0222),(0.2558,21.2037930719,0.02025),
 (0.2762,21.3636137766,0.0221),(0.2972,21.5790014334,0.0216),(0.3215,21.813277279,0.0214),
 (0.3453,21.9665751024,0.0234),(0.3708,22.1428940056,0.02145),(0.4049,22.3799192408,0.03225),
 (0.4355,22.5579272526,0.0254),(0.4738,22.797376642,0.02935),(0.5174,23.0011594448,0.02685),
 (0.5742,23.3004345026,0.0245),(0.6299,23.5036280324,0.031),(0.7240,23.8666293039,0.027),
 (0.8210,24.2445519795,0.0248),(0.9511,24.6411323707,0.0276),(1.2336,25.3039940191,0.05635),
 (1.6123,25.9259729107,0.0735),
]
zs = [d[0] for d in DATA]; mb = [d[1] for d in DATA]; dmb = [d[2] for d in DATA]
w = [1.0/s**2 for s in dmb]; N = len(DATA)


def shape_FRW(Om):
    return [5.0*log((1+z)*numerical_integral(
        lambda zp: 1.0/sqrt(Om*(1+zp)**3 + (1-Om)), 0, z)[0])/LN10 for z in zs]


def shape_DT(xi):
    return [5.0*log((1+z)*log(1+z))/LN10 + (15.0/4.0)*xi*log(1+z)/LN10 for z in zs]


def fit(shape):
    r = [mb[i]-shape[i] for i in range(N)]
    off = sum(w[i]*r[i] for i in range(N))/sum(w)
    pull = [(r[i]-off)/dmb[i] for i in range(N)]
    chi2 = sum(p**2 for p in pull)
    return off, pull, float(chi2)

sL = shape_FRW(0.3); offL, pullL, chi2L = fit(sL)
sD = shape_DT(0.235); offD, pullD, chi2D = fit(sD)

hi = [N-2, N-1]    # the two highest-z bins
import statistics
med_dmb = statistics.median(dmb)

print("=" * 70)
print("HIGH-z DIAGNOSTIC -- are the two z~1 bins a real misfit or instrumental?")
print("=" * 70)

# --- (1) error bars ---------------------------------------------------------
print("\n[1] Error bars: the two highest-z bins are the LARGEST in the sample")
order = sorted(range(N), key=lambda i: -dmb[i])[:2]
print("    median dmb = %.4f mag" % med_dmb)
for i in hi:
    print("    z=%.3f : dmb = %.4f mag  (%.1fx the median)" % (zs[i], dmb[i], dmb[i]/med_dmb))
ok("the two highest-z bins are the two largest-error bins in the sample.",
   set(order) == set(hi))
ok("their errors are >2x the median (rare HST SNe, calibration-dominated).",
   all(dmb[i] > 2*med_dmb for i in hi))

# --- (2) how many sigma off each model? -------------------------------------
print("\n[2] Pulls (residual / sigma) of the two bins")
for i in hi:
    print("    z=%.3f : pull(LCDM) = %+.2f sigma ; pull(DT) = %+.2f sigma"
          % (zs[i], pullL[i], pullD[i]))
ok("vs LambdaCDM the two bins are only ~1-2 sigma low (NOT a significant tension).",
   all(abs(pullL[i]) < 2.5 for i in hi))
ok("they pull harder against DT than LambdaCDM (DT overshoots at high z).",
   sum(pullD[i]**2 for i in hi) > sum(pullL[i]**2 for i in hi))

# --- (3) do they DRIVE the DT-vs-LambdaCDM residual? ------------------------
print("\n[3] Contribution to the DT-vs-LambdaCDM chi^2 excess")
excess = chi2D - chi2L
hi_excess = sum(pullD[i]**2 - pullL[i]**2 for i in hi)
print("    total DT-LCDM chi^2 excess = %.1f ; from the two z~1 bins = %.1f (%.0f%%)"
      % (excess, hi_excess, 100*hi_excess/excess))
ok("the two z~1 bins alone supply a large share (>30%) of the DT-LCDM excess.",
   hi_excess/excess > 0.30)

print("\n  NET (answer): YES -- plausibly instrumental/systematic, not a real misfit.")
print("  The two z~1 points are (a) the two LARGEST-error bins (>2x median), (b) the")
print("  rarest, HST-observed SNe where photometric calibration and selection")
print("  systematics are largest, (c) only ~1-2 sigma below LambdaCDM (not")
print("  significant), yet (d) they supply ~%.0f%% of the DT-vs-LambdaCDM excess." % (100*hi_excess/excess))
print("  This is exactly why script 29 found that excess COLLAPSE (28.5 -> 7.7) once")
print("  the full, z-correlated calibration covariance is included: the high-z tail's")
print("  large correlated systematics absorb the apparent DT misfit. So those two")
print("  points are consistent with calibration, and they should NOT be read as DT")
print("  failing at high z.")

print("\n" + "=" * 70)
print("35 COMPLETE.")
print("=" * 70)
