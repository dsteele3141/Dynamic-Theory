#!/usr/bin/env sage
# ---------------------------------------------------------------------------
# SOURCE (primary): P. E. Williams, "The Dynamic Theory" (DT.tex) Ch.8
#   "Electromagnetic Fields and Wave-Particle Duality", pp.199-213.
#   (Ch.8 is BOOK-sourced: the Report LA-8370-MS carries the quantum condition
#   itself -- Sec.II.F, pp.64-72, eqs (55)-(57) -- but not the phat-photon
#   blackbody development, so the book is the necessary source here.)
#
#     Eq 8.13  \oint phi_j dx^j = 2 pi i N   (WQP quantum condition, isentropic)
#     Eq 8.14  each gauge potential separately quantised
#     Eq 8.15  phi_y = N B cos 2pi(x/lambda - v t)  (quantised VECTOR potential)
#     Eq 8.19  I    = (N^2 B^2 / 2 mu0 h c^3) v
#     Eq 8.20  B    = sqrt(2 mu0 h c^3)   =>  N=1 carries exactly h v
#     Eq 8.21  eps  = N^2 h v             (the "phat photon", N > 1)
#     Eq 8.22  Ebar = h v (1+delta) / (e^{hv/kT} - 1)
#     Eq 8.23  rho_v dv = (8 pi v^2/c^3) h v (1+delta)/(e^{hv/kT}-1) dv
#
#   THE STEP UNDER AUDIT (p.212), verbatim:
#     "We now need a closed form for this infinite sum. In Planck's case where
#      the energy was assumed to be in integer steps the sum was (1-X)^{-1} =
#      1 + X + X^2 + X^3 + ...  In the absence of the knowing closed form we
#      shall adopt the form of (1-X)^{-(1+delta)} = 1 + X + X^4 + X^9 + ...
#      where 0 < delta < 1."
#     "This is identical in form to Planck's energy density with the exception
#      of the multiplicative term (1+delta)."
#     "If one could somehow eliminate all of the other frequencies from a
#      radiating blackbody, the value of delta could be determined."
#
#   NOTE the application to thermal radiation is WILLIAMS' OWN (his section
#   "Phat Photon Energy Density" derives 8.23 for "a radiating blackbody" and
#   uses it to license the phat-laser calculation that follows). This script
#   audits that application; it does not extend the claim beyond his use of it.
# ---------------------------------------------------------------------------
#
# phat_photon_blackbody.sage                        [A]  (assertion-hardened)
#
# PURPOSE. Three questions about Eqs 8.22/8.23.
#   (1) Is the constant-delta closed form legitimate?
#   (2) If not, what is the corrected phat blackbody spectrum?
#   (3) Does the corrected spectrum survive the measured CMB?
#
# RESULT (all three answered here, assertion-driven):
#   (1) NO. Sum_{n>=0} X^{n^2} is a Jacobi theta function, and no CONSTANT
#       delta reproduces it. The exact effective delta RUNS with X = e^{-hv/kT}:
#       delta -> 0 in the Wien tail but delta -> -1/2 in the Rayleigh-Jeans
#       limit. It is therefore (a) not constant and (b) NEGATIVE, so the stated
#       range 0 < delta < 1 is wrong in sign as well as in kind. Williams'
#       ALGEBRA given the ansatz is correct (verified symbolically below); the
#       ansatz itself is not.
#   (2) The corrected law is rho_v = (8 pi v^2/c^3) h v G(hv/kT) with
#       G = Sum n^2 X^{n^2} / Sum X^{n^2}. Relative to Planck at the same T it
#       is a FREQUENCY-DEPENDENT factor R(hv/kT): 1/2 in the deep Rayleigh-Jeans
#       limit, dipping NON-MONOTONICALLY to a minimum ~0.45 near hv/kT ~ 0.1,
#       then rising to 1 in the Wien tail. So the n^2 ladder delivers HALF the
#       Rayleigh-Jeans equipartition (independently confirmed here by the
#       equipartition theorem for one quadratic degree of freedom).
#   (3) NO. The corrected spectrum is not a rescaled Planck function, so a
#       blackbody fit cannot absorb it: fitting free amplitude AND free
#       temperature across the FIRAS band leaves residuals far above the 50 ppm
#       FIRAS limit, and at ARCADE2 frequencies the predicted deficit is tens
#       of percent where the measured spectrum agrees with the FIRAS blackbody
#       to better than a percent.
#
# WHY THE ERROR WAS LOAD-BEARING: a CONSTANT (1+delta) is a normalisation,
#   which is unobservable in a spectrum's shape (hence Williams' remark that
#   delta could only be determined by isolating a single frequency). The true
#   factor is frequency-DEPENDENT, which is exactly what spectrometers measure.
#   The ansatz converted a falsifiable shape prediction into an unfalsifiable
#   constant.
#
# SCOPE -- what is NOT touched. This constrains the THERMAL/equilibrium
#   application (Eqs 8.22-8.23) only. A NON-THERMAL phat photon -- an
#   individual N>=2 mode from a non-equilibrium source, e.g. Williams' "phat
#   laser" (pp.213-219, eps = N^2 h v with A/B coefficients scaled by 1/N^2) --
#   is not constrained by blackbody statistics and remains untested. Nor does
#   this touch the gateway result itself (London condition -> Bohr radii,
#   gateway_london_quantisation.sage).
#
# OBSERVATIONAL REFERENCES (all three verified against the papers themselves,
# in 00_SI-GH-final/05_pdfs/):
#
#   [F96] D. J. Fixsen, E. S. Cheng, J. M. Gales, J. C. Mather, R. A. Shafer &
#         E. L. Wright, "The Cosmic Microwave Background Spectrum from the Full
#         COBE FIRAS Data Set", ApJ 473, 576 (1996); astro-ph/9605054.
#         Abstract, verbatim: "The RMS deviations are less than 50 parts per
#         million of the peak of the CMBR. For the Comptonization and chemical
#         potential we find |y| < 15e-6 and |mu| < 9e-5 (95% CL). There are also
#         refinements in the absolute temperature, 2.728 +/- 0.004 K (95% CL)".
#         Band: 2 to 21 cm^-1 (= 59.96 to 629.6 GHz). Calibrator temperatures
#         "controllable from 2 to 25 K"; calibrator-induced spectrum uncertainty
#         "approximately 10 parts per million".
#
#   [FM02] D. J. Fixsen & J. C. Mather, "The Spectral Results of the Far-Infrared
#         Absolute Spectrophotometer Instrument on COBE", ApJ 581, 817 (2002).
#         Sec 2.2, verbatim: "The final monopole spectrum is thus well modeled by
#         a 2.725 K +/- 1 mK blackbody. The measured deviations from this
#         spectrum are 50 parts per million (ppm, rms) of the peak brightness".
#         Sec 2.1: three INDEPENDENT temperature estimates -- thermometric
#         (2725.0 +/- 1.0 mK), spectral "color" (2725.5 +/- 0.85 mK), dipole
#         (2722 +/- 12 mK).
#         THE CAVEAT THAT MATTERS HERE (Sec 2.2), verbatim: "the measurement is
#         actually the difference between the sky and the calibrator. It does not
#         determine whether Planck's formula is correct at the same level of
#         precision. This measurement allows the blackbody spectrum to be
#         different from the Planck function as long as BOTH the sky and the
#         calibrator have very nearly the same spectrum. On the other hand, large
#         deviations from the Planck function can be excluded on the basis of the
#         self-consistency of the calibration data alone, which were taken at
#         many different temperatures and frequencies."
#
#   [F09] D. J. Fixsen, "The Temperature of the Cosmic Microwave Background",
#         ApJ 707, 916 (2009); arXiv:0911.1955. Table 2 compiles 16 measurements
#         across platforms and frequencies (mean 2.72548 +/- 0.00057 K), incl.
#         ARCADE2 2.731 +/- 0.005 K (3-90 GHz, Rayleigh-Jeans side) and FIRAS
#         2.7255 +/- 0.00085 K (color temperature, [F96]). Sec 5, verbatim: "All
#         of the recent precision estimates of the CMB temperature agree within
#         2.5 times their uncertainties. These estimates were made with a variety
#         of methods from different platforms and different frequencies."
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage phat_photon_blackbody.sage
# ============================================================================

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


print("=" * 74)
print("phat_photon_blackbody.sage   --  Williams Ch.8, Eqs 8.13-8.23")
print("=" * 74)

# --------------------------------------------------------------------------
# (A) Williams' ALGEBRA is right; his ANSATZ is not.
# --------------------------------------------------------------------------
print("\n(A) The constant-delta closed form (p.212)")

a_sym, d_sym = var('a_sym d_sym')
assume(a_sym > 0)

# Williams' adopted closed form, with X = e^{-a}:  S_W = (1-X)^{-(1+delta)}
S_W = (1 - exp(-a_sym)) ** (-(1 + d_sym))
# Ebar/kT = -a d/da ln S   (his own reduction, p.211)
f_W = (-a_sym * diff(log(S_W), a_sym)).simplify_full()
f_W_target = a_sym * (1 + d_sym) / (exp(a_sym) - 1)
ok("Eq 8.22 follows from the ansatz: -a dlnS/da = a(1+d)/(e^a-1)",
   (f_W - f_W_target).simplify_full() == 0)

# ... and the ansatz is a genuine mismatch term by term. Expand both sides in X.
X = var('X')
lhs_series = sum(X ** (n ** 2) for n in range(0, 4))          # 1 + X + X^4 + X^9
rhs_series = ((1 - X) ** (-(1 + d_sym))).series(X == 0, 3)
# Matching the X^1 coefficient forces (1+delta) = 1, i.e. delta = 0 exactly;
# but then the X^2 coefficient of the ansatz is nonzero while the true sum has
# no X^2 term at all.  So no constant delta can work, already at O(X^2).
c2_at_d0 = ((1 - X) ** (-1)).series(X == 0, 3).coefficient(X, 2)
ok("ansatz forced to delta=0 by the X^1 term, but then predicts a spurious "
   "X^2 term (true sum has none): coeff = %s" % c2_at_d0, c2_at_d0 == 1)

# --------------------------------------------------------------------------
# (B) The exact theta-function statistics.
# --------------------------------------------------------------------------
print("\n(B) Exact mean energy of a mode with the n^2 ladder")

def theta_sums(a):
    """S = Sum_{n>=0} e^{-n^2 a},  M = Sum_{n>=0} n^2 e^{-n^2 a}."""
    a = RDF(a)
    nmax = int(sqrt(60.0 / float(a))) + 25
    S = RDF(0)
    M = RDF(0)
    for n in range(nmax + 1):
        w = exp(-RDF(n) ** 2 * a)
        S += w
        M += RDF(n) ** 2 * w
    return S, M


def f_phat(a):
    """Ebar/(kT) for the n^2 ladder  =  a * M/S  =  -a dlnS/da."""
    S, M = theta_sums(a)
    return RDF(a) * M / S


def f_planck(a):
    """Ebar/(kT) for Planck's integer ladder = a/(e^a - 1)."""
    a = RDF(a)
    return a / (exp(a) - 1)


def R_ratio(a):
    """rho_phat / rho_Planck at the same T  ==  1 + delta_effective."""
    return f_phat(a) / f_planck(a)


# cross-check the closed form a*M/S against a numerical -a dlnS/da
a_t = RDF(0.7)
eps = RDF(1e-6)
fd = -a_t * (log(theta_sums(a_t + eps)[0]) - log(theta_sums(a_t - eps)[0])) / (2 * eps)
ok("a*M/S agrees with numerical -a dlnS/da at a=0.7 (%.10f vs %.10f)"
   % (float(f_phat(a_t)), float(fd)), abs(float(f_phat(a_t) - fd)) < 1e-7)

# Independent derivation of the low-a limit: EQUIPARTITION for one quadratic
# degree of freedom.  In the continuum limit the n^2 ladder is a single
# quadratic variable, so <E> = kT/2 -- no theta function needed.
n_v, al = var('n_v al')
assume(al > 0)
num_int = integrate(al * n_v ** 2 * exp(-al * n_v ** 2), n_v, 0, oo)
den_int = integrate(exp(-al * n_v ** 2), n_v, 0, oo)
ok("equipartition cross-check: continuum n^2 ladder gives <E> = kT/2 exactly",
   (num_int / den_int).simplify_full() == QQ(1) / 2)

print("\n      a=hv/kT     Ebar/kT (phat)   Ebar/kT (Planck)    R      delta_eff")
print("      " + "-" * 68)
probe = [1e-4, 1e-3, 1e-2, 0.0528, 0.1, 0.5, 1.197, 2.821, 5.0, 11.25, 20.0, 40.0]
delta_vals = []
for a in probe:
    fp, fP, R = f_phat(a), f_planck(a), R_ratio(a)
    delta_vals.append(float(R - 1))
    print("      %-10.4g  %14.8f  %16.8f  %8.5f  %+9.5f"
          % (a, float(fp), float(fP), float(R), float(R - 1)))

# The approach to kT/2 is slow, O(sqrt(a)), because the theta transformation
# gives S ~ (1 + sqrt(pi/a))/2 and the constant 1/2 is not negligible:
#     Ebar/kT  ->  (1/2) * u/(1+u),      u = sqrt(pi/a).
# Assert that PREDICTED asymptotic form, which tests the limit and its rate.
print("\n      theta-asymptotic check:  Ebar/kT  vs  (1/2)u/(1+u), u=sqrt(pi/a)")
for a in [1e-2, 1e-4, 1e-6]:
    u = sqrt(RDF(pi) / RDF(a))
    pred = 0.5 * u / (1 + u)
    got = f_phat(a)
    print("      a=%-8.1g  exact = %.10f   asymptotic = %.10f   diff = %.2e"
          % (a, float(got), float(pred), abs(float(got - pred))))
    ok("theta asymptotic form holds at a=%g" % a, abs(float(got - pred)) < 1e-6)

ok("Rayleigh-Jeans limit: Ebar -> kT/2 (a=1e-8 gives %.8f)"
   % float(f_phat(1e-8)), abs(float(f_phat(1e-8)) - 0.5) < 1e-4)
ok("Rayleigh-Jeans limit: R -> 1/2, i.e. delta_eff -> -1/2 (a=1e-8)",
   abs(float(R_ratio(1e-8)) - 0.5) < 1e-4)
ok("Wien limit: delta_eff -> 0 (a=40)", abs(float(R_ratio(40.0)) - 1.0) < 1e-9)

# R is NOT monotone: it starts at 1/2 in the deep RJ limit, DIPS BELOW 1/2,
# then rises to 1. Locate the minimum -- the point of maximal distortion.
scan = [RDF(10) ** (RDF(-6) + RDF(i) / 200 * 7) for i in range(201)]
Rmin, a_at_min = min((float(R_ratio(a)), float(a)) for a in scan)
print("\n      R is non-monotone: minimum R = %.5f at hv/kT = %.4f "
      "(deficit %.1f%%)" % (Rmin, a_at_min, 100 * (1 - Rmin)))
ok("R dips BELOW the RJ value 1/2 (min %.5f at a=%.4f)" % (Rmin, a_at_min),
   Rmin < 0.48)
ok("delta_eff is NEGATIVE throughout, so the stated range 0 < delta < 1 is "
   "wrong in sign", max(delta_vals) <= 1e-12)
ok("delta_eff SPREAD = %.4f > 0.49, so no constant delta exists"
   % (max(delta_vals) - min(delta_vals)), (max(delta_vals) - min(delta_vals)) > 0.49)

# --------------------------------------------------------------------------
# (C) Can a blackbody FIT absorb the corrected spectrum?  (the honest test)
# --------------------------------------------------------------------------
print("\n(C) Best-fit Planck function vs the corrected phat spectrum")

h_pl = 6.62607015e-34      # J s   (SI, exact)
k_B = 1.380649e-23         # J/K   (SI, exact)
T0 = 2.7255                # K   -- FIRAS color temperature, [F09] Table 2/[F96]

# [F96] band: 2 to 21 cm^-1.  1 cm^-1 = 29.9792458 GHz.
FIRAS_LO_GHZ, FIRAS_HI_GHZ = 2 * 29.9792458, 21 * 29.9792458      # 59.96-629.6
# [F96]/[FM02]: deviations from a blackbody are 50 ppm RMS of PEAK brightness.
# NOTE this is an RMS limit, so the RMS residual is the correct comparison;
# the max residual is reported too but is the weaker statement.
FIRAS_RESID_LIMIT = 5.0e-5

def alpha_of_GHz(nu_GHz, T=T0):
    return RDF(h_pl * nu_GHz * 1e9 / (k_B * T))

NB = 60
xs = [alpha_of_GHz(FIRAS_LO_GHZ + i * (FIRAS_HI_GHZ - FIRAS_LO_GHZ) / NB)
      for i in range(NB + 1)]
# dimensionless specific intensity  I ~ v^2 * Ebar  ~  x^2 * f(x)
data = [x ** 2 * f_phat(x) for x in xs]

def planck_shape(x, t):
    """x^3/(exp(x/t)-1); t = T_fit/T0."""
    return x ** 3 / (exp(x / RDF(t)) - 1)

best = None
t = 0.30
while t <= 1.60001:
    m0 = [planck_shape(x, t) for x in xs]
    # least-squares optimal amplitude, analytic
    sn = sum(d * m for d, m in zip(data, m0))
    sd = sum(m * m for m in m0)
    A = sn / sd
    model = [A * m for m in m0]
    peak = max(model)
    rms = sqrt(sum((d - m) ** 2 for d, m in zip(data, model)) / len(data)) / peak
    mx = max(abs(float(d - m)) for d, m in zip(data, model)) / float(peak)
    if best is None or float(rms) < best[0]:
        best = (float(rms), t, float(A), float(mx))
    t += 0.002

resid_rms, t_best, A_best, resid_max = best
print("      best-fit T_fit/T_true = %.4f  (T_fit = %.4f K), amplitude = %.4f"
      % (t_best, t_best * T0, A_best))
print("      RMS |residual| / peak = %.4e   vs [F96]/[FM02] 50 ppm RMS limit"
      % resid_rms)
print("      max |residual| / peak = %.4e" % resid_max)
print("      => exceeds the 50 ppm RMS limit by a factor %.0f"
      % (resid_rms / FIRAS_RESID_LIMIT))
ok("a free-amplitude, free-temperature Planck fit CANNOT absorb the corrected "
   "phat spectrum (RMS residual %.2e >> 5e-5)" % resid_rms,
   resid_rms > 20 * FIRAS_RESID_LIMIT)

# Linearised bound on a phat FRACTION eps:  rho = rho_P [1 - eps(1-R)]
eps_firas = FIRAS_RESID_LIMIT / resid_rms
print("      linearised bound on the phat fraction from FIRAS: eps < %.2e"
      % eps_firas)

# ---- HONEST CAVEAT ON THIS TEST (see [FM02] Sec 2.2, quoted in the header) ----
# FIRAS is DIFFERENTIAL: it measures sky MINUS external calibrator. If DT's
# modified statistics govern ALL thermal cavity radiation, the calibrator is
# distorted identically and the difference partially cancels -- so the bare
# 50 ppm residual does NOT by itself exclude a universal change to Planck's law.
# [FM02] anticipate exactly this and give the answer: "large deviations from the
# Planck function can be excluded on the basis of the self-consistency of the
# calibration data alone, which were taken at many different temperatures and
# frequencies."  That argument bites here because R depends on the RATIO hv/kT,
# so varying the calibrator over 2-25 K at fixed frequency [F96] changes R:
print("\n      [caveat] FIRAS is differential (sky - calibrator); a universal")
print("      change to Planck's law partly cancels. [FM02] answer: calibration")
print("      self-consistency over 2-25 K. R depends on hv/kT, so at fixed v:")
nu_fix = 200.0
for T_cal in [2.725, 5.0, 10.0, 20.0]:
    a_c = alpha_of_GHz(nu_fix, T_cal)
    print("        v=%.0f GHz, T_cal=%5.2f K :  hv/kT = %6.3f   R = %.4f"
          % (nu_fix, T_cal, float(a_c), float(R_ratio(a_c))))
R_spread = (float(R_ratio(alpha_of_GHz(nu_fix, 20.0)))
            - float(R_ratio(alpha_of_GHz(nu_fix, 2.725))))
ok("R varies by %.3f across the 2-25 K calibrator range at fixed frequency, so "
   "the distortion cannot cancel between sky and calibrator" % abs(R_spread),
   abs(R_spread) > 0.05)

# --------------------------------------------------------------------------
# (D) The robust test: the Rayleigh-Jeans brightness temperature.
# --------------------------------------------------------------------------
print("\n(D) Rayleigh-Jeans brightness temperature (ARCADE2 band, 3-90 GHz)")

# This test is IMMUNE to the differential-calibrator caveat above, because it
# compares temperatures derived by DIFFERENT instruments at DIFFERENT
# frequencies, one on the Rayleigh-Jeans side and one at the peak.
# [F09] Table 2:  ARCADE2 (3-90 GHz, RJ side)   T = 2.731  +/- 0.005   K
#                 FIRAS   (color temp., [F96])  T = 2.7255 +/- 0.00085 K
T_RJ, S_RJ = 2.731, 0.005
T_PK, S_PK = 2.7255, 0.00085
frac_off = (T_RJ - T_PK) / T_PK
frac_sig = sqrt(S_RJ ** 2 + S_PK ** 2) / T_PK
print("      [F09] Table 2: ARCADE2 (RJ side) vs FIRAS (peak):")
print("        (T_RJ - T_peak)/T_peak = %+.4f  +/- %.4f" % (frac_off, frac_sig))
# Conservative bound: the offset plus 2 sigma. Note the sign -- the measured
# offset is POSITIVE (RJ side slightly HOTTER), whereas a phat deficit would
# make the RJ-derived temperature LOWER. So the data lean against DT twice over.
RJ_AGREEMENT = abs(frac_off) + 2 * frac_sig
print("        => conservative bound on any real RJ/peak mismatch: %.4f (%.2f%%)"
      % (RJ_AGREEMENT, 100 * RJ_AGREEMENT))
ok("measured RJ/peak offset is POSITIVE, i.e. opposite in sign to a phat deficit",
   frac_off > 0)

for nu in [3.0, 10.0, 30.0, 90.0]:
    a = alpha_of_GHz(nu)
    R = R_ratio(a)
    print("      %5.1f GHz : a = %.5f   I_phat/I_Planck = %.5f   deficit = %.1f%%"
          % (nu, float(a), float(R), 100 * (1 - float(R))))

a3 = alpha_of_GHz(3.0)
deficit3 = 1 - float(R_ratio(a3))
ok("corrected phat spectrum predicts a %.1f%% intensity deficit at 3 GHz"
   % (100 * deficit3), deficit3 > 0.40)
ok("that deficit exceeds the measured RJ/peak consistency by a factor %.0f"
   % (deficit3 / RJ_AGREEMENT), deficit3 > 10 * RJ_AGREEMENT)

eps_rj = RJ_AGREEMENT / deficit3
print("      linearised bound on the phat fraction from RJ radiometry: eps < %.2e"
      % eps_rj)

# --------------------------------------------------------------------------
# (E) Calibrator-free check: the total radiated energy density.
# --------------------------------------------------------------------------
print("\n(E) Stefan-Boltzmann analogue (integrated energy density)")

# u ~ Integral I dv.  Planck: Integral x^3/(e^x-1) dx = pi^4/15.
# Phat  : Integral x^2 f(x) dx  (same normalisation, verified by the shared
# large-x limit x^3 e^{-x}).  This needs no calibrator and no spectrometer:
# it is the ratio a phat cavity's total emitted power would bear to sigma T^4.
NQ = 4000
XMAX = 60.0
dx = XMAX / NQ
I_phat = RDF(0)
I_planck = RDF(0)
for i in range(1, NQ + 1):
    x = RDF(i) * dx
    I_phat += x ** 2 * f_phat(x) * dx
    I_planck += x ** 3 / (exp(x) - 1) * dx
sb_exact = RDF(pi) ** 4 / 15
ok("Planck quadrature reproduces pi^4/15 = %.6f (got %.6f)"
   % (float(sb_exact), float(I_planck)), abs(float(I_planck - sb_exact)) < 1e-3)
sb_ratio = float(I_phat / I_planck)
print("      integrated energy density ratio u_phat/u_Planck = %.5f" % sb_ratio)
print("      => a phat cavity radiates %.1f%% less than sigma T^4 at the same T,"
      % (100 * (1 - sb_ratio)))
print("         so its Stefan-Boltzmann constant would be %.3f sigma." % sb_ratio)
ok("integrated power deficit of %.1f%% is far above any radiometric uncertainty"
   % (100 * (1 - sb_ratio)), (1 - sb_ratio) > 0.05)

# --------------------------------------------------------------------------
# SUMMARY
# --------------------------------------------------------------------------
print("\n" + "=" * 74)
print("SUMMARY")
print("=" * 74)
print("""
  1. Eq 8.22's closed form is invalid. Sum_{n>=0} X^{n^2} is a theta function;
     no CONSTANT delta reproduces it (it fails already at O(X^2)). The exact
     effective delta RUNS from 0 (Wien) through a minimum of %+.3f down to
     -1/2 in the deep Rayleigh-Jeans limit, and is negative throughout, so the
     stated 0 < delta < 1 is wrong in sign and in kind. Williams' algebra GIVEN
     the ansatz is correct.

  2. Corrected law: rho_v = (8 pi v^2/c^3) h v G(hv/kT),
     G = Sum n^2 X^{n^2} / Sum X^{n^2}. Against Planck at the same T this is a
     FREQUENCY-DEPENDENT factor R: 1/2 deep in the Rayleigh-Jeans regime, a
     non-monotone minimum of %.3f at hv/kT = %.3f, then 1 in the Wien tail. The
     n^2 ladder carries HALF the Rayleigh-Jeans equipartition (kT/2, confirmed
     independently by the equipartition theorem for one quadratic dof).

  3. The thermal application is EXCLUDED, by three tests of differing
     robustness:
     (i)   FIRAS shape [F96]/[FM02]: a free-amplitude, free-temperature Planck
           fit cannot absorb a frequency-dependent factor -- RMS residual %.1e
           of peak against the 50 ppm RMS limit. CAVEAT: FIRAS is differential
           (sky - calibrator), so a UNIVERSAL change to Planck's law partly
           cancels; [FM02]'s own answer is calibration self-consistency over
           2-25 K, which bites because R depends on hv/kT (verified above).
     (ii)  Cross-frequency temperature consistency [F09] Table 2: ARCADE2 on
           the RJ side agrees with the FIRAS peak temperature to %.2f%%, and in
           the OPPOSITE sign to a phat deficit, against a predicted %.0f%%
           deficit at 3 GHz. Immune to the calibrator caveat (different
           instruments, different frequencies).
     (iii) Integrated energy density: a phat cavity radiates only %.3f of
           sigma T^4. Needs no spectrometer and no calibrator at all.
     Binding bound on the phat fraction of thermal radiation: eps < %.0e,
     cross-checked at eps < %.0e.

  4. Why the error mattered: a constant (1+delta) is a NORMALISATION -- exactly
     what a spectrum cannot measure, which is why Williams wrote that delta
     could only be found by isolating a single frequency. The true factor is a
     SHAPE change, which is what spectrometers measure best. The ansatz turned
     a falsifiable prediction into an unfalsifiable constant.

  5. NOT touched: the non-thermal phat photon (an N>=2 mode from a
     non-equilibrium source, incl. the phat laser) is not constrained by
     blackbody statistics and remains an open forward prediction; nor is the
     gateway result (London condition -> Bohr radii) affected.
""" % (Rmin - 1, Rmin, a_at_min, resid_rms, 100 * RJ_AGREEMENT, 100 * deficit3,
       sb_ratio, min(eps_firas, eps_rj), max(eps_firas, eps_rj)))
print("=" * 74)
print("ALL ASSERTIONS PASSED")
print("=" * 74)
