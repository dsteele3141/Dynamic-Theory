#!/usr/bin/env sage
# T2.13 — Shock Waves: Enhanced Viscosity  [completes prediction P2]
#
# Source: Williams LA-8370-MS (1980), Section III, pages 146-150.
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S3, Appendix A [C5].
#
# ============================================================================
# T2.12 showed the hypersurface geometry contributes a
# viscous-like stress t^{ab} = -P h^{ab}, with h carrying the mass-density
# gradient (eq 165). In a region of LARGE density gradient — a shock front —
# this term becomes significant. For a steady 1D shock the total stress is
#
#   sigma = P { 1 - (1/a0^2)(d gamma/dx)^2 } + eta (du/dx)        (geometric + ordinary)
#
# with the conservation laws (steady shock):  gamma u = k1 (mass),
# k1 u + sigma = k2 (momentum),  k1^2 E - sigma^2/2 = k3 (energy).
#
# Using mass conservation to eliminate d gamma/dx, the stress collapses to an
# ORDINARY viscous form with an EFFECTIVE coefficient (eq, p.150):
#
#   sigma = P + eta_eff (du/dx),   eta_eff = eta - (P k1^2)/(a0^2 u^4) (du/dx).
#
# Inside a shock du/dx < 0, so eta_eff > eta: the geometric term ENHANCES the
# viscosity and THICKENS the shock front — prediction P2 (increased viscous
# effects in shocked materials).
#
# Verified:
#   (A) mass conservation gamma u = k1  =>  d gamma/dx = -(k1/u^2)(du/dx);
#   (B) substituting it, sigma = P + eta_eff (du/dx) with eta_eff as above;
#   (C) eta_eff > eta inside a shock (du/dx < 0) — viscosity ENHANCED;
#   (D) classical limit a0 -> infinity: eta_eff -> eta (geometric term off);
#   (E) numeric demonstration of the enhancement.
# ============================================================================

_lines = []
def out(s=''):
    print(s); _lines.append(str(s))

out('=' * 70)
out('T2.13 — Shock-wave enhanced viscosity (completes prediction P2)')
out('=' * 70)
out('')

# ----------------------------------------------------------------------------
# (A) Mass conservation gamma u = k1  =>  d gamma/dx = -(k1/u^2)(du/dx)
# ----------------------------------------------------------------------------
out('-' * 70)
out('(A) Steady-shock mass conservation: gamma u = k1  =>  gamma_x = -(k1/u^2) u_x')
out('-' * 70)
x = var('x')
k1 = var('k1', domain='positive')
uf = function('u')(x)
gam = k1 / uf                                   # gamma = k1/u  (mass conservation)
dgam = diff(gam, x).simplify_full()
expected = -(k1 / uf^2) * diff(uf, x)
out('  d gamma/dx = %s' % dgam)
out('  -(k1/u^2)(du/dx): difference = %s' % (dgam - expected).simplify_full())
assert (dgam - expected).simplify_full() == 0
out('')

# ----------------------------------------------------------------------------
# (B) Total stress collapses to sigma = P + eta_eff (du/dx)
# ----------------------------------------------------------------------------
out('-' * 70)
out('(B) Total stress => sigma = P + eta_eff (du/dx)')
out('-' * 70)
var('P a0 eta u', domain='positive')
var('dudx', domain='real')                      # velocity gradient (sign matters)

dgdx = -(k1 / u^2) * dudx                        # from (A)
# geometric (T2.12 h11) + ordinary viscous stress:
sigma = P * (1 - (1/a0^2) * dgdx^2) + eta * dudx
eta_eff = eta - (P * k1^2) / (a0^2 * u^4) * dudx
sigma_eff = P + eta_eff * dudx
out('  sigma          = P{1 - (1/a0^2)(d gamma/dx)^2} + eta (du/dx)')
out('  eta_eff        = eta - (P k1^2)/(a0^2 u^4) (du/dx)')
out('  sigma - [P + eta_eff (du/dx)] = %s'
    % (sigma - sigma_eff).simplify_full())
assert (sigma - sigma_eff).simplify_full() == 0
out('')

# ----------------------------------------------------------------------------
# (C) Inside a shock du/dx < 0  =>  eta_eff > eta  (viscosity ENHANCED)
# ----------------------------------------------------------------------------
out('-' * 70)
out('(C) Enhancement: eta_eff - eta > 0 when du/dx < 0 (inside a shock)')
out('-' * 70)
d_eta = (eta_eff - eta).simplify_full()
out('  eta_eff - eta = %s' % d_eta)
out('          = -(P k1^2)/(a0^2 u^4) (du/dx)')
# with P,k1,a0,u > 0 and du/dx < 0, this is > 0:
assume(dudx < 0)
pos = bool(d_eta > 0)
out('  with du/dx < 0 (and P,k1,a0,u > 0): eta_eff - eta > 0 ? %s' % pos)
assert pos
forget(dudx < 0)
out('  => geometric term ENHANCES viscosity and THICKENS the shock front (P2).')
out('')

# ----------------------------------------------------------------------------
# (D) Classical limit a0 -> infinity: eta_eff -> eta
# ----------------------------------------------------------------------------
out('-' * 70)
out('(D) Classical limit a0 -> infinity (geometric term switched off)')
out('-' * 70)
eta_eff_classical = limit(eta_eff, a0=oo)
out('  lim_{a0->inf} eta_eff = %s   (recovers ordinary viscosity eta): %s'
    % (eta_eff_classical, eta_eff_classical == eta))
assert eta_eff_classical == eta
out('')

# ----------------------------------------------------------------------------
# (E) Numeric demonstration
# ----------------------------------------------------------------------------
out('-' * 70)
out('(E) Numeric demonstration (dimensionless, du/dx < 0 inside shock)')
out('-' * 70)
for a0v in [10.0, 3.0, 1.0]:
    sub = {P: 1, k1: 1, u: 1, eta: 1, a0: a0v, dudx: -1}
    ee = float(eta_eff.subs(sub))
    out('  a0 = %5.2f :  eta_eff = %.4f  (= eta + %.4f enhancement; ratio %.2fx)'
        % (a0v, ee, ee - 1.0, ee / 1.0))
out('  (smaller a0 => stronger geometric coupling => more enhancement)')
out('')

out('=' * 70)
out('T2.13 SUMMARY (completes prediction P2 — enhanced viscosity in shocks):')
out('  (A) gamma u = k1  =>  d gamma/dx = -(k1/u^2)(du/dx).                     [OK]')
out('  (B) sigma = P + eta_eff (du/dx), eta_eff = eta - (P k1^2/a0^2 u^4)(du/dx).[OK]')
out('  (C) inside a shock (du/dx<0): eta_eff > eta — viscosity ENHANCED.       [OK]')
out('  (D) a0 -> infinity: eta_eff -> eta (classical recovery).                [OK]')
out('  (E) numeric: enhancement grows as a0 decreases.                         [OK]')
out('  => Together with T2.12 (viscous stress from geometry), the Dynamic Theory')
out('     predicts INCREASED viscous effects in shocked (large-grad-gamma)')
out('     materials (prediction P2). Magnitude scales as 1/a0^2.')
out('=' * 70)
