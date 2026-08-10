#!/usr/bin/env sage
# ---------------------------------------------------------------------------
# SOURCE (primary): P. E. Williams, "The Dynamic Theory" (DT.tex) Ch.11
#   "Five Dimensional Waves":
#     Eq 11.72  p   = (1/24pi)[E^2 + B^2 + 3 V4^2 - V^2]      (radiation pressure)
#     Eq 11.29  xi  = (1/8pi )[E^2 + B^2 + V^2 + V4^2]        (energy density)
#     Eq 11.73  p=0 <=>  V^2 = E^2 + B^2 + 3 V4^2             (zero-pressure cond.)
#     Eq 11.74  p/xi = 1 - w^2/(a0 c k4)^2                    ("Zero pressure radiation")
#     Eq p.365  p/xi = (1+n^2 - (A0/w)^2)/(1+n^2 + (A0/w)^2)  ("ONLY transverse ... V4=0")
#   Mode DEFINITION, "Against the Odds" (Williams 2009):
#     p.44  "I didn't feel I could call them longitudinal waves ... For this reason
#           I prefer to call this set of solutions the NON-TRANSVERSE waves. They
#           consist of an electric component directed in the direction of wave
#           propagation, a gravitational component OPPOSING the electric component,
#           and a SCALAR gravitational component that has no directivity."
#     p.170 "there is no gravity wave independent of electromagnetic waves ... the
#           gravity wave does not exist by itself ... a good reason the gravity wave
#           experiments have come up negative."
# ---------------------------------------------------------------------------
#
# 36b_nontransverse_pressure_rederivation.sage        [A]  (assertion-hardened)
#
# PURPOSE: audit the SCOPE of 36_electrogravitic_wave_polarization.sage.
#
#   Script 36 filed a "CLEAN FALSIFICATION": it called Williams' mode a
#   LONGITUDINAL / electrogravitic wave, used the radiation-pressure ratio
#       p/xi = (1+n^2 - (A0/w)^2)/(1+n^2 + (A0/w)^2)                 (Eq p.365)
#   -- which Williams introduces with the words "When only TRANSVERSE waves are
#   considered where V4 is zero" -- extrapolated it to long wavelength, got a
#   NEGATIVE pressure at the CMB (p/xi -> -1), and called that a falsification.
#
#   Williams, however, (i) explicitly REFUSED the word "longitudinal" for this
#   mode because it contains a directionless SCALAR component V4, and (ii) the
#   mode has its electric vector ALONG k, so its magnetic field B ~ k x E VANISHES.
#   So the formula script 36 used describes the WRONG field configuration
#   (magnetic energy present, scalar absent).
#
#   This script re-derives the pressure for the mode AS WILLIAMS DEFINES IT
#   (B = 0 ; scalar V4 != 0) and tests whether the falsification survives.
#
# RESULT: it does NOT.  (a) The mode carries no magnetic field, so the "1+n^2"
#   the script used is spurious; (b) the scalar V4 enters the pressure as +3V4^2,
#   dropped by the script; (c) Williams' OWN two pressure formulae (Eq 11.74 vs
#   Eq p.365) give OPPOSITE signs at the CMB, so the source does not even predict
#   the sign of the radiation pressure there.  No clean external falsification.
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 36b_nontransverse_pressure_rederivation.sage
# ============================================================================

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


print("=" * 74)
print("36b  RE-DERIVATION: radiation pressure of the NON-TRANSVERSE mode")
print("     (audit of the script-36 'clean falsification')")
print("=" * 74)

# ---------------------------------------------------------------------------
# [1] The mode carries NO magnetic field:  B ~ k x E, and E || k  =>  B = 0.
#     (Williams DT.tex:11909  B = (k c x E)/(2 pi nu).)
# ---------------------------------------------------------------------------
print("\n[1] Magnetic content of the mode (B proportional to k x E)")
var('Ex Ez kz', domain='real')
khat   = vector([0, 0, kz])          # propagation along z
E_long = vector([0, 0, Ez])          # NON-TRANSVERSE: E along k  (Williams' mode)
E_tran = vector([Ex, 0, 0])          # ordinary transverse wave:  E perpendicular k

B_long = khat.cross_product(E_long)  # ~ B of the non-transverse mode
B_tran = khat.cross_product(E_tran)  # ~ B of the transverse wave

print("    non-transverse (E || k):  k x E =", B_long)
print("    transverse     (E _|_ k):  k x E =", B_tran)
ok("non-transverse mode has B = 0 (E parallel k => k x E = 0).",
   B_long == vector([0, 0, 0]))
ok("the ordinary transverse wave does have B != 0.",
   B_tran != vector([0, 0, 0]))

# ---------------------------------------------------------------------------
# [2] Pressure numerator: what script 36 computed vs the actual mode.
#     Eq 11.72:  24pi p = E^2 + B^2 + 3 V4^2 - V^2   (sign of pressure = sign of this)
# ---------------------------------------------------------------------------
print("\n[2] Pressure numerator  (24*pi*p),  Eq 11.72")
var('E B V V4 n', domain='positive')
N_full   = E**2 + B**2 + 3*V4**2 - V**2                 # Williams, general
N_script = (N_full.subs(B=n*E, V4=0)).simplify_full()   # script 36: B^2=n^2 E^2, V4=0
N_mode   = (N_full.subs(B=0)).simplify_full()           # actual mode: B=0, V4 kept
print("    script-36 numerator :  N_script =", N_script, "   (= (1+n^2)E^2 - V^2)")
print("    actual-mode numerator:  N_mode   =", N_mode,   "   (=  E^2 + 3V4^2 - V^2)")
diff = (N_mode - N_script).simplify_full()
print("    N_mode - N_script     =", diff)
ok("mode and script differ by exactly (3 V4^2 - n^2 E^2) -- the scalar the "
   "script dropped and the magnetic term it wrongly added.",
   (diff - (3*V4**2 - n**2*E**2)).simplify_full() == 0)
ok("they are NOT the same field configuration (difference is not identically 0).",
   diff != 0)

# ---------------------------------------------------------------------------
# [3] Zero-pressure condition (Eq 11.73) for the mode vs for the script.
# ---------------------------------------------------------------------------
print("\n[3] Zero-pressure condition  V^2 = E^2 + B^2 + 3 V4^2   (Eq 11.73)")
V2_mode   = (E**2 + B**2 + 3*V4**2).subs(B=0)            # mode:   V^2 = E^2 + 3 V4^2
V2_script = (E**2 + B**2 + 3*V4**2).subs(B=n*E, V4=0)   # script: V^2 = (1+n^2) E^2
print("    mode   :  V^2 =", V2_mode.simplify_full())
print("    script :  V^2 =", V2_script.simplify_full())
ok("the mode's zero-pressure balance carries the +3 V4^2 term the script omits.",
   (V2_mode - V2_script - (3*V4**2 - n**2*E**2)).simplify_full() == 0)

# ---------------------------------------------------------------------------
# [4] Williams' OWN two p/xi formulae disagree on the SIGN at long wavelength.
# ---------------------------------------------------------------------------
print("\n[4] The source's two radiation-pressure ratios (constants from script 18)")
A0    = 40.72e12          # s^-1  = a0 c k4  (Nichols & Hull optical fit, script 18)
nref  = 1.0              # vacuum
w_cmb = 160.2e9          # s^-1  CMB spectral peak (~160 GHz)

def f_1174(w):           # Eq 11.74  ("Zero pressure radiation" section)
    return 1 - (w/A0)**2

def f_p365(w, nn=nref):   # Eq p.365  ("only transverse waves, V4 = 0")  == script 36
    x = (A0/w)**2
    return (1 + nn**2 - x)/(1 + nn**2 + x)

print("    at the CMB peak (%.1f GHz):" % (w_cmb/1e9))
print("       Eq 11.74  p/xi = %+.6f" % f_1174(w_cmb))
print("       Eq p.365  p/xi = %+.6f   (this is the value script 36 used)" % f_p365(w_cmb))
ok("script 36's formula (Eq p.365) is NEGATIVE at the CMB (reproduces its claim).",
   f_p365(w_cmb) < 0)
ok("Williams' OWN 'zero-pressure' Eq 11.74 is POSITIVE at the CMB.",
   f_1174(w_cmb) > 0)
ok("=> the two source formulae give OPPOSITE signs at the CMB: the theory does "
   "not even fix the sign of the radiation pressure there.",
   f_1174(w_cmb) * f_p365(w_cmb) < 0)

w2 = 2*A0
print("    at w = 2*A0 (away from the CMB):")
print("       Eq 11.74  p/xi = %+.6f" % f_1174(w2))
print("       Eq p.365  p/xi = %+.6f" % f_p365(w2))
ok("the sign disagreement is not a CMB artifact: opposite signs at w = 2*A0 too.",
   f_1174(w2) * f_p365(w2) < 0)

# ---------------------------------------------------------------------------
# [5] Verdict
# ---------------------------------------------------------------------------
print("\n" + "-" * 74)
print("VERDICT")
print("-" * 74)
print("The script-36 'clean falsification' does NOT survive re-derivation:")
print("  * the mode carries NO magnetic field (E || k => B = 0), so the '1+n^2'")
print("    in the formula script 36 used is a transverse artifact absent here;")
print("  * the mode's defining SCALAR component V4 enters the pressure as +3 V4^2")
print("    (Eq 11.72) and was dropped by script 36;")
print("  * Williams' own Eq 11.74 and Eq p.365 give OPPOSITE-sign radiation")
print("    pressure at the CMB, so the source does not fix the sign to falsify.")
print("Williams also states the gravity wave 'does not exist by itself' (AtO p.170),")
print("so a NULL longitudinal-GW result (LIGO/GW170817) is EXPECTED, not a")
print("constraint against DT -- script 36's 'second channel' is misapplied.")
print("What remains is the SOFTER, already-tracked tension: Williams' CMB-as-")
print("zero-pressure-radiation (w ~ 0) vs the measured acoustic-peak w = +1/3 and")
print("the unexplained thermal spectrum (script 37).  That is not a clean")
print("falsification of a *predicted wave*.")

print("\n" + "=" * 74)
print("36b COMPLETE.")
print("=" * 74)
