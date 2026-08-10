#!/usr/bin/env sage
# T1.9 - Weyl variational principle: strengthening pass
#
# Source: P. E. Williams, LA-8370-MS (LASL, 1980), Section II.D, eqs (38)-(39).
# Full derivation, context and provenance:
#   Supplementary_Material.pdf - §S1, Appendix A [C10].
#
# PURPOSE
#   T1_9_weyl_variational.sage verified the Euler-Lagrange STRUCTURE of eq 39
#   using tractable substitutes: a single plane wave for the Maxwell EL and a
#   single FLRW metric for the Einstein EL. This pass upgrades the weakest of
#   those — and treats the term the original script left blank:
#
#   (A) MAXWELL EL, GENERAL.  Instead of one plane wave, prove for an ARBITRARY
#       potential A (four free functions of all coordinates) the exact identity
#           div_mu F^{mu nu} = box A^nu - d^nu(div A),     F = dA,
#       i.e. the F^2-term Euler-Lagrange operator IS the 2nd-order Maxwell
#       operator for any A (not just a known solution). In Lorenz gauge
#       (div A = 0) it reduces to the wave equation box A^nu = 0.
#
#   (B) THE lambda-CONSTRAINT TERM, -lambda(1/2 - 6 phi_i phi^i).  The original
#       script did not touch this — yet it is the DYNAMIC-THEORY-specific piece
#       (the unity-scale-factor / gauge normalisation). We give its two
#       Euler-Lagrange contributions explicitly:
#         * EL w.r.t. lambda  =>  the constraint  phi_i phi^i = 1/12;
#         * EL w.r.t. phi_k   =>  a source  12 lambda phi^k  added to the gauge
#                                 (Maxwell) field equation.
#
# OUT OF SCOPE (unchanged, stated honestly): the Einstein-Hilbert variation
#   delta INT R sqrt(-g) -> G_{mu nu} is NOT derived here (no symbolic variational
#   calculus for the general metric); per Williams it is the standard Weyl-1918
#   result. This pass strengthens the EM sector and the DT constraint only.
# ============================================================================

# Output is captured via stdout redirection by the runner.

_lines = []
def out(s=''):
    print(s); _lines.append(str(s))

out('=' * 70)
out('T1.9 STRENGTHENING — general Maxwell EL + the lambda-constraint term')
out('=' * 70)
out('')

# 4D Minkowski, Cartesian coords -> Levi-Civita connection vanishes, so the
# covariant divergence is the ordinary divergence. Metric eta = diag(-1,1,1,1).
var('t x y z')
coords = [t, x, y, z]
eta = [-1, 1, 1, 1]   # eta_{ii} = eta^{ii} (diagonal, +-1)

# ----------------------------------------------------------------------------
# (A) GENERAL Maxwell EL:  div_mu F^{mu nu} = box A^nu - d^nu(div A), arbitrary A
# ----------------------------------------------------------------------------
out('-' * 70)
out('(A) Maxwell EL for an ARBITRARY potential A (four free functions)')
out('-' * 70)

A = [function('A0')(t, x, y, z), function('A1')(t, x, y, z),
     function('A2')(t, x, y, z), function('A3')(t, x, y, z)]

# Field tensor F_{ij} = d_i A_j - d_j A_i, raised F^{mu nu} = eta^{mu a} eta^{nu b} F_{ab}
F  = [[diff(A[j], coords[i]) - diff(A[i], coords[j]) for j in range(4)] for i in range(4)]
Fup = [[eta[i] * eta[j] * F[i][j] for j in range(4)] for i in range(4)]

# LHS: div_mu F^{mu nu}  (the Euler-Lagrange operator of INT F_ij F^ij sqrt(-g))
divF = [sum(diff(Fup[mu][nu], coords[mu]) for mu in range(4)) for nu in range(4)]

# RHS: box A^nu - d^nu(div A)
Aup      = [eta[nu] * A[nu] for nu in range(4)]                       # A^nu
divA     = sum(diff(Aup[mu], coords[mu]) for mu in range(4))          # div A = d_mu A^mu
boxA     = [sum(eta[mu] * diff(Aup[nu], coords[mu], 2) for mu in range(4)) for nu in range(4)]
graddivA = [eta[nu] * diff(divA, coords[nu]) for nu in range(4)]      # d^nu(div A)

resid = [(divF[nu] - (boxA[nu] - graddivA[nu])).simplify_full() for nu in range(4)]
ok_general = all(r == 0 for r in resid)
out('  residual per nu (div F - (boxA - grad div A)): %s' % resid)
out('  div_mu F^{mu nu} = box A^nu - d^nu(div A)  for ARBITRARY A: %s   [%s]'
    % (ok_general, 'VERIFIED' if ok_general else 'FAIL'))
assert ok_general
out('  => the F^2-term EL is the 2nd-order Maxwell operator for any A,')
out('     not merely the single plane wave of 02_T1_9. In Lorenz gauge')
out('     (div A = 0) this reduces to box A^nu = 0 (the wave equation).')
out('')

# ----------------------------------------------------------------------------
# (B) The lambda-constraint term -lambda(1/2 - 6 phi_i phi^i): its EL content
# ----------------------------------------------------------------------------
out('-' * 70)
out('(B) lambda-constraint term  -lambda(1/2 - 6 phi_i phi^i)  (DT-specific)')
out('-' * 70)

var('lam s phi0 phi1 phi2 phi3')
phi = [phi0, phi1, phi2, phi3]                       # gauge vector phi_i (lower)
phisq = sum(eta[i] * phi[i]^2 for i in range(4))     # phi_i phi^i = eta^{ij} phi_i phi_j
Lc = -lam * (1/2 - 6 * phisq)

# EL w.r.t. the multiplier lambda  ->  the constraint
dLc_dlam = diff(Lc, lam).simplify_full()
out('  dLc/dlambda = %s        (= -(1/2 - 6 phi_i phi^i))' % dLc_dlam)
constraint_sol = solve(1/2 - 6 * s == 0, s)          # s stands for phi_i phi^i
out('  EL(lambda) = 0  =>  phi_i phi^i = %s   (unity-scale-factor normalisation)'
    % constraint_sol[0].rhs())
assert constraint_sol[0].rhs() == QQ(1)/12

# EL w.r.t. phi_k  ->  the source term entering the gauge (Maxwell) field eq
ok_source = True
src = []
for k in range(4):
    dLc_dphik = diff(Lc, phi[k]).simplify_full()
    expected  = (12 * lam * eta[k] * phi[k]).simplify_full()   # 12 lambda phi^k
    src.append(dLc_dphik)
    if (dLc_dphik - expected).simplify_full() != 0:
        ok_source = False
out('  dLc/dphi_k = %s' % src)
out('  dLc/dphi_k = 12 lambda phi^k  (source added to the gauge field eq): %s   [%s]'
    % (ok_source, 'VERIFIED' if ok_source else 'FAIL'))
assert ok_source
out('  => the constraint (i) pins the gauge-vector norm phi_i phi^i = 1/12, and')
out('     (ii) sources the Maxwell EL:  A * div_mu F^{mu nu} + 12 lambda phi^nu = 0.')
out('')

# ----------------------------------------------------------------------------
out('=' * 70)
out('T1.9 STRENGTHENING SUMMARY:')
out('  (A) Maxwell EL generalised from one plane wave to ARBITRARY A:')
out('      div_mu F^{mu nu} = box A^nu - d^nu(div A)  [VERIFIED, general]')
out('  (B) lambda-constraint (previously untouched) given explicit EL content:')
out('      EL(lambda) => phi^2 = 1/12 ; EL(phi_k) => source 12 lambda phi^k [VERIFIED]')
out('')
out('  Still cited, not derived (out of scope): the Einstein-Hilbert variation')
out('  delta INT R sqrt(-g) -> G_{mu nu} (standard Weyl-1918; no symbolic')
out('  variational calculus for the general metric here).')
out('=' * 70)

# (result captured via stdout redirection by the runner)
