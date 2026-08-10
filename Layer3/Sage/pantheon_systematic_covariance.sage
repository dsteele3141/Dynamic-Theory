#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE: DATA = Pantheon binned SN-Ia (Scolnic et al. 2018, ApJ 859:101):
#   lcparam_DS17f.txt (40 bins: zcmb, mb, dmb_stat) + sys_DS17f.txt (the 40x40
#   SYSTEMATIC covariance, calibration-dominated and z-correlated), both from
#   github.com/dscolnic/Pantheon. Local copy: pantheon_sys_DS17f.txt (this dir).
#   MODEL = DT (Williams Ch.3): log-z distance + evolving Chandrasekhar candle.
# --------------------------------------------------------------------------

# ============================================================================
# 29_pantheon_systematic_covariance.sage        [A]  (assertion-hardened)
#
# Re-runs the dark-energy model comparison (scripts 27/28) with the FULL Pantheon
# covariance C = C_sys + diag(dmb_stat^2) -- generalized least squares -- instead
# of statistical errors only. C_sys is dominated by photometric CALIBRATION and
# is strongly z-correlated, so it is exactly the systematic that does NOT bin
# down and that is degenerate with cosmology. Question: does the DT-vs-LambdaCDM
# residual (Delta chi2 ~ 28 with stat-only errors, script 27) SURVIVE once
# calibration systematics are included?
#
#   GLS chi2 (offset marginalised analytically):
#     r0 = mb - shape ;  chi2 = r0^T Cinv r0 - (1^T Cinv r0)^2 / (1^T Cinv 1)
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 29_pantheon_systematic_covariance.sage
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
N = len(DATA)

# --- load the systematic covariance matrix (try both Dropbox mount paths) ---
CANDS = [
 "/mnt/c/Users/dstee/Dropbox/___4Code/___1_GitHub_repos/12_DT-Williams/01_Three_Layers_and_Routes/03_layer_3/01_code/pantheon_sys_DS17f.txt",
 "/home/dsteele/Dropbox/___4Code/___1_GitHub_repos/12_DT-Williams/01_Three_Layers_and_Routes/03_layer_3/01_code/pantheon_sys_DS17f.txt",
 "pantheon_sys_DS17f.txt",
]
vals = None
for p in CANDS:
    try:
        with open(p) as fh:
            toks = fh.read().split()
        dim = int(float(toks[0]))
        vals = [float(t) for t in toks[1:1 + dim * dim]]
        assert dim == N and len(vals) == N * N
        break
    except Exception:
        vals = None
assert vals is not None, "could not load pantheon_sys_DS17f.txt"

Csys = matrix(RDF, N, N, vals)
Cfull = Csys + diagonal_matrix(RDF, [s**2 for s in dmb])
Cinv = Cfull.inverse()
one = vector(RDF, [1.0] * N)
mbv = vector(RDF, mb)
A_one = one * (Cinv * one)            # 1^T Cinv 1


def chi2_gls(shape):
    r0 = mbv - vector(RDF, shape)
    Cir0 = Cinv * r0
    return float(r0 * Cir0 - (one * Cir0)**2 / A_one)     # offset marginalised


# stat-only chi2 (for the before/after comparison)
wst = [1.0 / s**2 for s in dmb]
def chi2_stat(shape):
    r = [mb[i] - shape[i] for i in range(N)]
    off = sum(wst[i] * r[i] for i in range(N)) / sum(wst)
    return float(sum(wst[i] * (r[i] - off)**2 for i in range(N)))


def shape_FRW(Om):
    return [5.0 * log((1 + z) * numerical_integral(
        lambda zp: 1.0 / sqrt(Om * (1 + zp)**3 + (1 - Om)), 0, z)[0]) / LN10 for z in zs]


def shape_DT(xi):
    return [5.0 * log((1 + z) * log(1 + z)) / LN10 + (15.0 / 4.0) * xi * log(1 + z) / LN10
            for z in zs]


print("=" * 70)
print("PANTHEON with FULL systematic covariance -- does the DT residual survive?")
print("=" * 70)

sL = shape_FRW(0.3); sE = shape_FRW(1.0)
# best-fit DT under the FULL covariance
best = None; xi = 0.0
while xi <= 1.0001:
    c = chi2_gls(shape_DT(xi))
    if best is None or c < best[1]:
        best = (xi, c)
    xi += 0.005
xiD, c2D_full = best
sD = shape_DT(xiD)

c2L_stat, c2E_stat, c2D_stat = chi2_stat(sL), chi2_stat(sE), chi2_stat(shape_DT(0.235))
c2L_full, c2E_full = chi2_gls(sL), chi2_gls(sE)

print("\n[1] chi2 with STAT-only errors (script 27) vs FULL covariance (here)")
print("    model        stat-only      full-cov")
print("    EdS          %8.1f      %8.1f" % (c2E_stat, c2E_full))
print("    DT           %8.1f      %8.1f  (best xi: 0.235 stat / %.3f full)" % (c2D_stat, c2D_full, xiD))
print("    LambdaCDM    %8.1f      %8.1f" % (c2L_stat, c2L_full))

print("\n[2] The dark-energy detection is robust to systematics")
ok("EdS (no dark energy) stays catastrophic even with full covariance (chi2 > 200).",
   c2E_full > 200)
ok("dark-energy detection survives systematics: EdS - LambdaCDM (full) > 100.",
   (c2E_full - c2L_full) > 100)

print("\n[3] Does the DT-vs-LambdaCDM residual survive the calibration covariance?")
d_stat = c2D_stat - c2L_stat
d_full = c2D_full - c2L_full
print("    Delta chi2 (DT - LambdaCDM):  stat-only = %+.1f ;  full-cov = %+.1f" % (d_stat, d_full))
print("    -> the residual shrinks by a factor ~%.1f once calibration is included."
      % (d_stat / d_full if d_full > 0 else float('inf')))
ok("the DT-LambdaCDM residual SHRINKS when the systematic covariance is included.",
   d_full < d_stat)
ok("with full systematics, DT is statistically competitive with LambdaCDM (Delta chi2 < 9 ~ 3sigma).",
   d_full < 9.0)

print("\n  NET: the EdS rejection (dark energy / its mimic is real) is ROBUST to")
print("  the calibration-dominated systematic covariance. But the DT-vs-LambdaCDM")
print("  residual -- Delta chi2 = %.0f with stat-only errors -- shrinks to %.1f once" % (d_stat, d_full))
print("  the z-correlated calibration systematics are folded in, i.e. to < ~3 sigma.")
print("  So on the SN Hubble diagram DT and LambdaCDM are NOT cleanly separable:")
print("  the apparent residual was largely an artifact of using statistical errors")
print("  only. Confirms script 28's read -- the discriminator is the |Gdot/G| fork")
print("  (script 26), not the supernova residual.")

print("\n" + "=" * 70)
print("29 COMPLETE.")
print("=" * 70)
