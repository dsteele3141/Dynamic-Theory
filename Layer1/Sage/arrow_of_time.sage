#!/usr/bin/env sage
# Arrow of time - proper time = entropy = stability-metric arc-length
#
# Source: P. E. Williams, "Physics - Against the Odds" (book p.434, "The Arrow
#   of Time"), building on the Report-scoped T1.6 result (Eqs 16-19). The arrow
#   synthesis is book-primary; the underlying signature/metric is Report-scoped.
# Full derivation, context and provenance:
#   Supplementary_Material.pdf - §S1 (Appendix A.2, script 38).
#
# PLACEMENT: this is a LAYER-1 / FOUNDATIONAL topic (the arrow of time lives at
#   the 2nd law + stability metric, above the L1->L2 junction); conceptually it
#   belongs with T1.6 in Layer 1.
#
# DEMONSTRATION of the DT identification, not an independent derivation. Step
# (3) ASSIGNS dtau = dS (the identification under test) and shows the monotone
# consequence; it does not prove the identification. Step (4) records an honest
# caveat (the arrow's origin stays open). The load-bearing fact it relies on
# (entropy arc-length is the timelike coordinate, T1.6) is carried by Lean.
#
# THE POT SHOT (arrow of time).  Standard physics has a gap: microdynamics is
# time-symmetric, so the thermodynamic arrow needs a SEPARATE "past hypothesis"
# (a low-entropy boundary condition) plus coarse-graining, and the alignment of
# the thermodynamic / cosmological / psychological arrows is its own puzzle.
# DT collapses the gap by IDENTIFICATION: in the stability metric (T1.6) the
# arc-length IS the entropy IS proper time. The 2nd law (entropy never
# decreases) is then literally the statement that proper time goes forward --
# the temporal arrow and the thermodynamic arrow are ONE object, not two things
# that must be argued into alignment.
#
# This script (1) encodes the 2nd law as a directional inequality (the
# asymmetry), (2) confirms the T1.6 fact that the entropy arc-length is the
# TIMELIKE coordinate, (3) makes the identification proper-time = entropy =
# arc-length explicit so monotonicity transfers, and (4) states honestly what
# DT does NOT solve (it installs the asymmetry as a founding law; it does not
# derive irreversibility from reversible microdynamics, nor supply the low-
# entropy past hypothesis -- the non-singular cosmology removes the singular
# t=0 but not the low-S boundary condition).
# ============================================================================

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


print("=" * 70)
print("THE ARROW OF TIME -- proper time = entropy = arc-length (DT identification)")
print("=" * 70)

# --- (1) the 2nd law is a DIRECTIONAL inequality (the asymmetry) -------------
print("\n[1] 2nd law as the asymmetry:  dE/phi <= dS   (entropy production >= 0)")
dS, dE_over_phi = var('dS dE_over_phi', domain='real')
sigma = dS - dE_over_phi                      # entropy production
# reversible (isentropic) leg: sigma = 0 ; irreversible leg: sigma > 0
sigma_rev = sigma.subs({dS: 0.5, dE_over_phi: 0.5})
sigma_irr = sigma.subs({dS: 0.5, dE_over_phi: 0.3})
print("    reversible  : dS = dE/phi  -> sigma = %s" % sigma_rev)
print("    irreversible: dS > dE/phi  -> sigma = %s > 0" % sigma_irr)
ok("entropy production sigma = dS - dE/phi is >= 0 (2nd law sets a direction).",
   sigma_rev == 0 and sigma_irr > 0)
ok("equality (sigma=0) is exactly the reversible / isentropic limit.",
   sigma_rev == 0)

# --- (2) T1.6: the entropy arc-length is the TIMELIKE coordinate -------------
print("\n[2] T1.6 (Lean-proved): the entropy arc-length is the timelike coord")
# stability quadratic h_ij dq^i dq^j = c^2 dt^2 ; solve for the entropy
# coordinate (dq0)^2 -> Lorentzian (+,-,-,-): timelike sign on proper time.
c, dt, dq0, dx2, h0 = var('c dt dq0 dx2 h0', domain='positive')
# h0*(dq0)^2 - dx2 = c^2 dt^2   (entropy-metric form, T1.6 Eq 18 corrected)
sol = solve(h0*dq0**2 - dx2 == c**2*dt**2, dq0**2)
dq0_sq = sol[0].rhs()
print("    solving the stability quadratic for (dq0)^2: %s" % dq0_sq)
ok("the proper-time coefficient is +c^2/h0 (TIMELIKE): entropy arc-length is time.",
   (dq0_sq - (c**2*dt**2 + dx2)/h0).simplify_full() == 0)
print("    => proper time tau = entropy arc-length S (the (+,-,-,-) timelike leg).")

# --- (3) the IDENTIFICATION transfers monotonicity --------------------------
print("\n[3] Identification:  d(tau) = d(S) = arc-length element")
# DT: proper time, entropy, and arc-length are the SAME differential. Therefore
# the 2nd law (dS >= 0) is identically the forward-time condition (d tau >= 0).
dtau = dS                                      # the DT identification
print("    so 2nd law dS >= 0  <=>  d(tau) >= 0  (the SAME statement)")
# sample a physical (irreversible) and a reversible path
for nm, val in [("irreversible", 0.5), ("reversible", 0.0)]:
    print("    %-13s: dS = %.1f -> d(tau) = %.1f" % (nm, val, val))
ok("forward time (d tau >= 0) is IDENTICAL to the 2nd law (dS >= 0), not aligned to it.",
   bool((dtau >= 0).subs({dS: 0.5})) and bool((dtau == 0).subs({dS: 0.0})))
ok("reversible limit dS=0 gives d(tau)=0: no arrow along isentropic directions.",
   bool((dtau == 0).subs({dS: 0.0})))

# --- (4) what DT does NOT solve (honest) ------------------------------------
print("\n[4] What the identification does NOT settle")
print("    DT makes the 2nd law a FOUNDING LAW (a postulated inequality); it does")
print("    NOT derive irreversibility from time-symmetric microdynamics (the hard")
print("    problem is RELOCATED, not solved), and it does not supply the low-")
print("    entropy 'past hypothesis'. The non-singular cosmology (script 37)")
print("    removes the singular t=0 but not the low-S boundary condition.")
print("  [NOTE] the arrow's ORIGIN (low-S boundary / reversible-microphysics "
      "derivation) stays open -- recorded as a caveat, not a verified claim.")

print("\n" + "-" * 70)
print("VERDICT")
print("-" * 70)
print("POSITIVE (a clean STRUCTURAL win): DT identifies proper time, entropy, and")
print("  the stability-metric arc-length as ONE object (T1.6, Lean-proved), so the")
print("  thermodynamic arrow and the temporal arrow are the SAME statement -- no")
print("  separate argument is needed to align them, and time's direction is the")
print("  2nd law's inequality by construction. This is a genuinely tighter")
print("  foundational placement than the standard bolt-on, and one of DT's")
print("  'elegant regardless' moves (with time/signature emerging from stability).")
print("LIMIT: it relocates rather than resolves the deep question -- the asymmetry")
print("  is installed as a founding law (not derived from reversible microphysics),")
print("  and the low-entropy past hypothesis is not supplied. So: a sound, elegant")
print("  identification of the arrow, not an explanation of its ultimate origin.")

print("\n" + "=" * 70)
print("38 COMPLETE.")
print("=" * 70)
