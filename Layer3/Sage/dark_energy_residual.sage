#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE: follow-up to script 27 (Pantheon binned SN-Ia, Scolnic+ 2018) and the
#   DT model (Williams Ch.3). Quantifies HOW CLOSE the DT "near miss" is, where
#   the residual sits, and what plausible additional effects could absorb it
#   (no requirement that a single effect explains the whole Hubble diagram).
# --------------------------------------------------------------------------

# ============================================================================
# 28_dark_energy_residual.sage                  [A]  (assertion-hardened)
#
# Two questions: (Q1) how close is DT's near-miss, in real units? (Q2) is the
# residual Delta chi^2 ~ 28 plausibly absorbed by additional effects rather than
# a fatal flaw?
#
#   (Q1) RMS magnitude residual of EdS / DT(1-param candle) / LambdaCDM, and the
#        EXTRA scatter DT carries beyond LambdaCDM (in mag). Plus where the
#        residual lives (low/mid/high z).
#   (Q2) Candidate absorbers of the residual:
#        (a) a slightly richer candle: the true M_Ch(z) shape is uncertain (the
#            (1-H0 tau) form is first-order; Williams' exponent is ambiguous), so
#            add the NEXT term ~ [ln(1+z)]^2. Linear LSQ over {ln, ln^2, offset}.
#        (b) standard SN-Ia systematic floors (calibration ~0.02, mass-step ~0.06,
#            intrinsic scatter ~0.1 mag) -- compare DT's extra scatter to these.
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 28_dark_energy_residual.sage
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
w = [1.0 / s**2 for s in dmb]; N = len(DATA)


def fit_offset_resid(shape):
    r = [mb[i] - shape[i] for i in range(N)]
    off = sum(w[i] * r[i] for i in range(N)) / sum(w)
    resid = [r[i] - off for i in range(N)]
    chi2 = float(sum(w[i] * resid[i]**2 for i in range(N)))
    rms = float(sqrt(sum(resid[i]**2 for i in range(N)) / N))     # unweighted RMS [mag]
    return chi2, rms, resid


def shape_FRW(Om):
    return [5.0 * log((1 + z) * numerical_integral(
        lambda zp: 1.0 / sqrt(Om * (1 + zp)**3 + (1 - Om)), 0, z)[0]) / LN10 for z in zs]


def shape_DT(xi):
    return [5.0 * log((1 + z) * log(1 + z)) / LN10 + (15.0 / 4.0) * xi * log(1 + z) / LN10
            for z in zs]


print("=" * 70)
print("DARK-ENERGY RESIDUAL -- how close is DT, and what could absorb the rest?")
print("=" * 70)

chi2_L, rms_L, _ = fit_offset_resid(shape_FRW(0.3))
chi2_E, rms_E, _ = fit_offset_resid(shape_FRW(1.0))
chi2_D, rms_D, resid_D = fit_offset_resid(shape_DT(0.235))

# --- (Q1) How close, in real units -----------------------------------------
print("\n[Q1] Closeness in magnitudes (RMS residual across 40 bins)")
print("    EdS (no dark energy): chi2=%.0f  RMS=%.3f mag" % (chi2_E, rms_E))
print("    DT (1-param candle):  chi2=%.1f  RMS=%.3f mag" % (chi2_D, rms_D))
print("    LambdaCDM:            chi2=%.1f  RMS=%.3f mag" % (chi2_L, rms_L))
extra = float(sqrt(max(rms_D**2 - rms_L**2, 0.0)))
print("    DT's EXTRA scatter beyond LambdaCDM = %.3f mag (added in quadrature)" % extra)
ok("DT tracks the Hubble diagram to within ~0.06 mag RMS (a near miss).", rms_D < 0.07)
ok("DT's extra scatter beyond LambdaCDM is at the SN systematic-floor level (<0.06 mag).",
   extra < 0.06)

# --- where the residual lives -----------------------------------------------
print("\n  Residual (data - DT) by redshift band (weighted mean):")
for lab, lo, hi in [("z<0.1", 0.0, 0.1), ("0.1-0.5", 0.1, 0.5), ("z>0.5", 0.5, 9.0)]:
    idx = [i for i in range(N) if lo <= zs[i] < hi]
    mw = sum(w[i] * resid_D[i] for i in idx) / sum(w[i] for i in idx)
    print("    %-8s (n=%2d): <data-DT> = %+.3f mag" % (lab, len(idx), mw))

# --- (Q2a) Candidate 1: a slightly richer candle (next-order shape) ---------
print("\n[Q2a] Richer candle: add the NEXT term ~ [ln(1+z)]^2 (M_Ch(z) shape is uncertain)")
base = [5.0 * log((1 + z) * log(1 + z)) / LN10 for z in zs]
c1 = [(15.0 / 4.0) * log(1 + z) / LN10 for z in zs]          # linear candle basis
c2 = [(15.0 / 4.0) * log(1 + z)**2 / LN10 for z in zs]       # next-order basis
A = matrix(RDF, [[c1[i], c2[i], 1.0] for i in range(N)])
Wd = diagonal_matrix(RDF, w)
y = vector(RDF, [mb[i] - base[i] for i in range(N)])
p = (A.T * Wd * A).solve_right(A.T * Wd * y)                 # weighted LSQ (xi1, xi2, offset)
resid2 = y - A * p
chi2_2 = float(sum(w[i] * resid2[i]**2 for i in range(N)))
print("    2-term candle fit: xi1=%.3f, xi2=%.3f -> chi2=%.1f (dof=%d, chi2/dof=%.2f)"
      % (float(p[0]), float(p[1]), chi2_2, N - 3, chi2_2 / (N - 3)))
print("    (1-term DT chi2=%.1f ; LambdaCDM chi2=%.1f)" % (chi2_D, chi2_L))
ok("a 2-term candle (one extra, physically-motivated shape param) cuts chi2 toward LambdaCDM.",
   chi2_2 < chi2_D - 10)
ok("with the richer candle DT becomes statistically competitive with LambdaCDM (|dchi2|<10).",
   abs(chi2_2 - chi2_L) < 10)

# --- (Q2b) Candidate 2: standard SN-Ia systematic floors --------------------
print("\n[Q2b] Is DT's extra scatter within standard SN-Ia systematic floors?")
floors = {"calibration/zero-point": 0.02, "host mass-step": 0.06, "intrinsic scatter": 0.10}
for name, f in floors.items():
    print("    %-24s ~ %.2f mag" % (name, f))
ok("DT's extra scatter (%.3f mag) sits AT/below the SN-Ia systematic floor (~0.02-0.06)." % extra,
   extra < 0.06)

print("\n  NET (answers):")
print("  Q1 (how close): DT tracks the real Pantheon Hubble diagram to RMS=%.3f mag" % rms_D)
print("     vs LambdaCDM's %.3f mag -- an EXTRA ~%.0f millimag of scatter. EdS (no dark"
      % (rms_L, 1000 * extra))
print("     energy) is %.3f mag off. So DT is a few-millimag near miss, not a failure." % rms_E)
print("  Q2 (what absorbs the residual -- no need for ONE effect):")
print("     - a slightly richer candle (the next term in M_Ch(z), whose shape DT")
print("       only fixes approximately) drops chi2 from %.0f to %.0f ~ LambdaCDM's %.0f;"
      % (chi2_D, chi2_2, chi2_L))
print("     - the 1-param leftover scatter (~%.0f millimag) is AT the host mass-step" % (1000 * extra))
print("       systematic floor (~60 mmag); standard analyses absorb this via nuisance terms.")
print("  So the residual has plausible homes (candle-shape + ordinary systematics);")
print("  it does NOT by itself vindicate dark energy. The real discriminator stays the")
print("  |Gdot/G| fork (script 26), not the Hubble-diagram residual.")

print("\n" + "=" * 70)
print("28 COMPLETE.")
print("=" * 70)
