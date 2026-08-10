#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE (primary): P. E. Williams, "The Dynamic Theory," 2011 Book.
#   Eq. (1.36), repeated as Eq. (10.6): the fifth velocity component
#       u4 = dy4/dt = d(y4)/dt + Div(y4 * u_bar) = 0
#   is "the statement required by the conservation of the fifth dimension";
#   the Eq. (6.11) discussion states that "the one-to-one correspondence
#   between energy and mass exists only for resting mass WHEN MASS IS
#   CONSERVED", and that requiring conservation of mass (gamma_dot = 0)
#   reduces the energy density to rest energy plus classical kinetic energy.
#   The 5-velocity norm on (+,-,-,-,-) gives |u4| < 1, hence a CEILING on the
#   rate at which mass may fail to be conserved.  a0 = 3.65e7 kg/m^4 is the
#   shock-calibrated value (Book Ch. 12 / p.417 route; corpus script 18).
# --------------------------------------------------------------------------

# ============================================================================
# 40_mass_energy_conversion_ceiling.sage        [A]  (assertion-hardened)
#
# IS DT's MASS-ENERGY CONVERSION CEILING VIOLATED BY REAL PROCESSES?
#
# THE IDENTIFICATION (this is the point of the script).  Write the continuity
# equation with a local sink S >= 0 for mass converted to non-mass energy
# (units kg m^-3 s^-1):
#       d(gamma)/dt + Div(gamma u_bar) = -S .
# Williams' u4 is exactly the left-hand side, in units of a0 (with q4=gamma/a0
# and q0 = c t):
#       u4 = (1/(a0 c)) [ d(gamma)/dt + Div(gamma u_bar) ] = -S/(a0 c) .
# So |u4| = S/(a0 c): u4 IS the local mass-destruction rate density, normalised
# by a0 c.  The (+,-,-,-,-) norm bounds |u4| < 1, so DT asserts a CEILING
#       S <= a0 c = 1.09e16 kg m^-3 s^-1
# on mass-energy conversion per unit volume -- the mass-sector analogue of
# "cannot cross c".  This script tests that ceiling.
#
# WHY THIS FRAMING AND NOT A BULK RATE.  Because u4 is the continuity RESIDUAL,
# a mass-CONSERVING flow gives u4=0 identically no matter how violently its
# density changes (section A proves this on two explicit flows, including the
# steady-shock jump condition gamma*u=k1).  Differencing a density over a
# timescale therefore does NOT estimate u4; only the sink S does.  Two earlier
# estimates in this project made exactly that error (a bulk-mean SN collapse
# rate, and a shock-front compression rate); both are retracted.
#
# RESULT: the ceiling is NOT violated by any continuum process checked. Ordinary
# conversion sits far below it (stellar fusion ~2e-32, laboratory annihilation
# ~2e-27, a 1 Mt thermonuclear burn ~1e-8).  The closest ACCESSIBLE system is
# inertial-confinement fusion at ~3e-4.  The closest system in nature is
# core-collapse supernova neutrino emission, which lands at u4 ~ 0.09-0.7 --
# i.e. it APPROACHES the ceiling to within an order of magnitude.  That is a
# lead, not a claim: the figure scales as R^-3 and is order-of-magnitude only.
# All figures in this header are reproduced by the run; the verdict block prints
# the computed values rather than restating them.
# A single-quantum annihilation, evaluated pointwise, formally gives "u4" ~ 1e10.
# That is NOT a violation but a DOMAIN limit: gamma is a continuum/thermodynamic
# mass density with a flux field Div(gamma u_bar), and neither exists inside one
# quantum event.  The script asserts this explicitly so the number cannot be
# quoted as a falsification.
#
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 40_mass_energy_conversion_ceiling.sage
# ============================================================================

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


# --- pinned constants --------------------------------------------------------
a0 = 3.65e7          # kg/m^4   DT gauge constant (shock-calibrated, script 18)
c  = 2.998e8         # m/s
CEIL = a0 * c        # kg/(m^3 s)  the u4 = 1 ceiling on mass-energy conversion
c2 = c**2

print("=" * 76)
print("40_mass_energy_conversion_ceiling.sage")
print("Is DT's ceiling on mass-energy conversion violated by real processes?")
print("=" * 76)
print("  a0 = %.3e kg/m^4   c = %.4e m/s" % (a0, c))
print("  CEILING  S_max = a0*c = %.4e kg/(m^3 s)   <->   u4 = 1" % CEIL)


# ===========================================================================
# (A) the residual vanishes for ANY mass-conserving flow (symbolic)
# ===========================================================================
print("\n[A] u4 = 0 identically for mass-conserving flow, however violent")

x, t, v, k1 = var('x t v k1', domain='real')

# (A1) travelling density wave gamma = f(x - v t) advected at speed v.
#      d(gamma)/dt is LARGE, yet the residual is exactly zero.
f = function('f')
gam1 = f(x - v * t)
u1 = v
resid1 = (diff(gam1, t) + diff(gam1 * u1, x)).simplify_full()
print("    (A1) advected profile gamma=f(x-vt), u=v:")
print("         d(gamma)/dt      = %s" % diff(gam1, t))
print("         Div(gamma u)     = %s" % diff(gam1 * u1, x))
print("         residual         = %s" % resid1)
ok("A1: residual is identically zero though d(gamma)/dt is non-zero "
   "(a compression rate is NOT a u4).", resid1 == 0)

# (A2) the steady-shock jump condition gamma*u = k1 (Williams, Book Ch. 12).
u_prof = function('u')(x)
gam2 = k1 / u_prof                      # mass conservation across the front
resid2 = (diff(gam2, t) + diff(gam2 * u_prof, x)).simplify_full()
print("    (A2) steady shock gamma*u=k1:  residual = %s" % resid2)
ok("A2: the steady shock front has ZERO continuity residual, so u4=0 inside it "
   "(retracts the earlier shock-front estimate).", resid2 == 0)

# (A3) the identification |u4| = S/(a0 c)
S = var('S', domain='positive')
A0, C = var('A0 C', domain='positive')
u4_of_S = S / (A0 * C)
ok("A3: with d(gamma)/dt + Div(gamma u) = -S, |u4| = S/(a0 c).",
   bool((u4_of_S * A0 * C - S).simplify_full() == 0))
print("         => only a genuine mass SINK S gives u4 != 0.")


# ===========================================================================
# (B) real conversion processes: S = (dm/dt)/V, u4 = S/(a0 c)
# ===========================================================================
print("\n[B] Genuine mass-energy conversion: u4 = S/(a0 c) for real systems")


def sphere_V(R):
    return 4.0 / 3.0 * pi.n() * R**3


def u4_of(E_joule, t_sec, V_m3, label, note=""):
    """mass converted = E/c^2; S = mass/(t V); u4 = S/(a0 c)."""
    dm = E_joule / c2
    S_ = dm / (t_sec * V_m3)
    u4_ = S_ / CEIL
    print("    %-34s S = %9.3e   u4 = %9.3e %s" % (label, S_, u4_, note))
    return u4_


# stellar fusion: the Sun's core, steady state
L_sun = 3.828e26                       # W
V_core = sphere_V(0.25 * 6.957e8)      # inner quarter-radius
u4_sun = u4_of(L_sun * 1.0, 1.0, V_core, "Sun's core (steady fusion)")

# laboratory positron annihilation in a small target
m_e = 9.109e-31
N_pos = 1.0e10                         # annihilations per second
E_pos = N_pos * 2 * m_e * c2           # J/s
u4_pos = u4_of(E_pos * 1.0, 1.0, 1.0e-9, "lab e+e- annihilation (1 mm^3)")

# a 1 Mt thermonuclear device: fusion burn
u4_bomb = u4_of(4.184e15, 1.0e-7, sphere_V(0.10), "1 Mt thermonuclear burn")

# inertial-confinement fusion: NIF ignition-scale hot spot
u4_nif = u4_of(3.15e6, 1.0e-10, sphere_V(30.0e-6), "ICF hot spot (NIF-scale)",
               "<- closest accessible")

# core-collapse supernova: neutrino burst from the proto-neutron star
E_sn = 3.0e46                          # J, gravitational binding energy released
u4_sn10 = u4_of(E_sn, 10.0, sphere_V(1.0e4), "SN core collapse (R=10 km, 10 s)",
                "<- closest in nature")
u4_sn20 = u4_of(E_sn, 10.0, sphere_V(2.0e4), "SN core collapse (R=20 km, 10 s)")

print("\n    ordering check and margins to the ceiling:")
for lab, val in [("Sun core", u4_sun), ("lab annihilation", u4_pos),
                 ("1 Mt burn", u4_bomb), ("ICF hot spot", u4_nif),
                 ("SN (R=20 km)", u4_sn20), ("SN (R=10 km)", u4_sn10)]:
    print("      %-18s u4 = %9.3e   margin to ceiling = %9.3e x"
          % (lab, val, 1.0 / val))

ok("B1: steady stellar fusion is ~30 orders below the ceiling.", u4_sun < 1e-25)
ok("B2: laboratory annihilation is ~27 orders below the ceiling.", u4_pos < 1e-20)
ok("B3: a 1 Mt thermonuclear burn stays below the ceiling.", u4_bomb < 1)
ok("B4: ICF is the closest ACCESSIBLE system and is still below the ceiling.",
   u4_nif < 1 and u4_nif > u4_bomb)
ok("B5: SN core collapse APPROACHES the ceiling to within an order of magnitude "
   "but does not exceed it.", u4_sn10 < 1 and u4_sn10 > 0.05)
ok("B6: no continuum process checked violates the ceiling.",
   max(u4_sun, u4_pos, u4_bomb, u4_nif, u4_sn10, u4_sn20) < 1)
# the SN figure is volume-sensitive: R^-3
ok("B7: the SN figure scales as R^-3, so it is order-of-magnitude only "
   "(R: 10->20 km moves u4 by 8x).",
   abs(u4_sn20 / u4_sn10 - 1.0 / 8.0) < 0.05)


# ===========================================================================
# (C) the single-quantum estimate is OUT OF DOMAIN, not a falsification
# ===========================================================================
print("\n[C] Pointwise single-event estimate: a DOMAIN limit, not a violation")
lam_C = 2.426e-12                       # electron Compton wavelength, m
V_q = lam_C**3
t_q = 1.0e-21                           # s, nuclear/annihilation timescale
dm_q = 2 * m_e
S_q = dm_q / (t_q * V_q)
u4_q = S_q / CEIL
print("    single e+e- annihilation, evaluated pointwise:")
print("      volume = lambda_C^3 = %.3e m^3, time = %.0e s" % (V_q, t_q))
print("      S = %.3e kg/(m^3 s)   ->  'u4' = %.3e" % (S_q, u4_q))
ok("C1: the pointwise number formally EXCEEDS the ceiling by ~10 orders.",
   u4_q > 1e9)
ok("C2: therefore it CANNOT be a u4 at all, since the (+,-,-,-,-) norm forces "
   "|u4|<1 -- a quantity computed outside the theory's domain, not a "
   "falsification of it.", u4_q > 1)
print("      REASON: gamma is a continuum/thermodynamic mass density and u4")
print("      contains the flux term Div(gamma u_bar); neither a density nor a")
print("      velocity field is defined inside one quantum event. DT is built on")
print("      the first law and an entropy-time, so its variables are")
print("      thermodynamic. The ceiling constrains CONTINUUM conversion rates.")
print("      Consequence: the ceiling is NOT testable by single-event physics;")
print("      it is testable where a bulk mass sink is resolvable in space and")
print("      time -- ICF and stellar collapse.")


# ===========================================================================
print("\n[VERDICT]")
print("  u4 IS the local mass-energy conversion rate, normalised: |u4| = S/(a0 c)")
print("  with S the mass-destruction rate per unit volume. Williams ties this to")
print("  E=mc^2 directly: the one-to-one mass-energy correspondence holds only")
print("  when mass is conserved (Book, Eq. 6.11 discussion), i.e. only at u4=0.")
print()
print("  The |u4|<1 bound therefore asserts a CEILING on mass-energy conversion,")
print("  S <= a0 c = %.3e kg/(m^3 s), the mass-sector analogue of 'cannot" % CEIL)
print("  cross c'. On the processes checked it is NOT violated (computed above):")
print("    stellar fusion        u4 = %9.3e     lab annihilation  u4 = %9.3e"
      % (u4_sun, u4_pos))
print("    1 Mt burn             u4 = %9.3e     ICF hot spot      u4 = %9.3e"
      % (u4_bomb, u4_nif))
print("    SN core collapse      u4 = %9.3e (R=10 km) to %9.3e (R=20 km)"
      % (u4_sn10, u4_sn20))
print("      <- the only case within an order of magnitude of the ceiling")
print()
print("  TWO HONEST EDGES.")
print("   (i) The SN figure is order-of-magnitude only (scales as R^-3, and the")
print("       burst duration and radius are both uncertain by factors of a few).")
print("       That it lands within an order of magnitude of the ceiling is a LEAD")
print("       worth a proper treatment, not a confirmation: a robust excess would")
print("       falsify the bound, and a robust saturation would be a prediction.")
print("  (ii) a0 was calibrated from shock data (Book Ch. 12), so the ceiling's")
print("       numerical value is not independent of that fit. A decisive test")
print("       needs a0 fixed by some other route.")

print("\n" + "=" * 76)
print("40_mass_energy_conversion_ceiling COMPLETE.")
print("=" * 76)
