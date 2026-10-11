# T1.1-T1.3 - Integrating factor, absolute velocity, mechanical entropy
#
# Source: P. E. Williams, LA-8370-MS (LASL, 1980), Eqs 2-6.
# Full derivation, context and provenance:
#   Supplementary Materials (stand-alone document) - §S1, Appendix A [C1].
from sage.all import *

# Symbolic DEMONSTRATION of T1.1-T1.3, not an independent derivation:
#   - COMPUTATION 1 POSITS the separated form lambda = phi(qdot)*f(sigma) and
#     then checks ratio-independence; the conditional separation proof is
#     carried by the Lean module (authoritative).
#   - The Euler-Lagrange PASS only checks the system is well-formed and
#     non-degenerate (residuals not identically zero), a consistency check.
# Eq 6 on Page 28 is the Euler-Lagrange system (not the entropy definition).

# --- Symbols ---
var('q qdot qdot3 qdot0 sigma sigmahat x v xp vp xpp vpp sigma1 sigma2 tau')

phi = function('phi')
f = function('f')
fhat = function('fhat')
g = function('g')


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


# ============================================================================
# COMPUTATION 1: T1.1 - Factorization lambda = phi(qdot) * f(sigma)
# ============================================================================
print("="*60)
print("COMPUTATION 1: T1.1 Integrating Factor (Eq 5)")
print("="*60)

# lambda/lambda_c must be independent of qdot (from Eq 3, 4 argument)
lam = phi(qdot) * f(sigma)
lamc = phi(qdot) * g(sigma, sigmahat)
ratio = lam / lamc

print(f"\nRatio lambda/lambda_c = {ratio.simplify_full()}")
print(f"  ∂(Ratio)/∂qdot = {diff(ratio, qdot)}")
ok("Product form: d(ratio)/dqdot vanishes (independence condition).",
   diff(ratio, qdot).simplify_full().is_zero())

# Mixed partial condition: ∂²ln(lambda)/∂sigma∂qdot = 0
log_lam = log(lam)
mixed = diff(diff(log_lam, sigma), qdot).simplify_full()
print(f"\nMixed partial ∂²ln(λ)/∂σ∂q̇ = {mixed}")
ok("Mixed partial d^2 ln(lambda)/dsigma dqdot vanishes (separable form).",
   mixed.is_zero())

# ============================================================================
# COMPUTATION 2: T1.2 - Absolute Velocity (Eq 2 region)
# ============================================================================
print("\n" + "="*60)
print("COMPUTATION 2: T1.2 Absolute Velocity")
print("="*60)

# I_common = Integral(f(sigma), (sigma, sigma1, sigma2))
# In Sage, we can represent this symbolically
I_common = integral(f(sigma), sigma, sigma1, sigma2)
DeltaE = phi(qdot) * I_common
DeltaE3 = phi(qdot3) * I_common

print(f"\nEnergy ratio ΔE/ΔE3 = {(DeltaE / DeltaE3).simplify_full()}")
print(f"  Expected: phi(qdot)/phi(qdot3)")
ok("Energy ratio = phi(qdot)/phi(qdot3) (depends only on the velocity factor).",
   (DeltaE / DeltaE3 - phi(qdot)/phi(qdot3)).simplify_full().is_zero())

# ============================================================================
# COMPUTATION 3: T1.3 - Entropy & Variational Principle (Eq 6)
# ============================================================================
print("\n" + "="*60)
print("COMPUTATION 3: T1.3 Variational Principle (Eq 6)")
print("="*60)

U = function('U')(x, v)
F_force = function('F')(x, v)
phi_v = function('phi')(v)

# dU/dtau (total derivative)
dU_dtau = diff(U, x)*xp + diff(U, v)*vp

# G = (1/phi) [ dU/dtau - F*dx/dtau ]
G = (dU_dtau - F_force*xp) / phi_v

def euler_lagrange(expr, coord, coord_p, coord_pp):
    """Computes D_tau(∂G/∂coord') - ∂G/∂coord."""
    # D_tau operator on first jet
    # Note: coord_p is the derivative of coord with respect to tau.
    # xp = dx/dtau, vp = dv/dtau, xpp = dxp/dtau, vpp = dvp/dtau
    def total_tau_deriv(target):
        # target depends on x, v, xp, vp
        return (diff(target, x)*xp + diff(target, v)*vp +
                diff(target, xp)*xpp + diff(target, vp)*vpp)

    dL_dq_p = diff(expr, coord_p)
    return (total_tau_deriv(dL_dq_p) - diff(expr, coord)).simplify_full()

print("\nVerifying Manuscript Eq 6 (Euler-Lagrange Equations):")
EL_x = euler_lagrange(G, x, xp, xpp)
EL_v = euler_lagrange(G, v, vp, vpp)

# The E-L residuals are not identically zero (they ARE the equations of motion);
# the verification here is that the variational system is well-formed and
# non-degenerate, i.e. both E-L operators yield genuine (non-trivial) equations.
print(f"  D_tau(∂G/∂x') - ∂G/∂x residual: {EL_x}")
print(f"  D_tau(∂G/∂v') - ∂G/∂v residual: {EL_v}")
ok("Euler-Lagrange system (Eq 6) is well-formed and non-degenerate "
   "(both residuals not identically zero).",
   (not EL_x.is_zero()) and (not EL_v.is_zero()))

print("\nAudit Complete: 06_integrating_factor.sage")
print("="*60)
