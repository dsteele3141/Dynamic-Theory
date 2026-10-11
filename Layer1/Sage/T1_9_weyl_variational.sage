#!/usr/bin/env sage
# T1.9 - Weyl variational principle: structural checks (eqs 38-39)
#
# Source: P. E. Williams, LA-8370-MS (LASL, 1980), eqs (38)-(39).
# Full derivation, context and provenance:
#   Supplementary Materials (stand-alone document) - §S1, Appendix A [C9].
#
# Verifies F=dA, a concrete Maxwell solution, and FLRW Einstein-tensor
# consistency. The Einstein-Hilbert variation is not derived in THIS script;
# it is derived for DT's own action (Report Eq 67) in
# Layer3/Sage/einstein_from_dt_action.sage (4D and 5D metric families plus an
# off-diagonal instance), and weyl_lambda_reading.sage / weyl_vector_mass.sage
# settle the lambda term and the gauge vector (2026-10-07).

from sage.all import *
import os
import sys


class Tee:
    def __init__(self, *streams):
        self.streams = streams

    def write(self, data):
        for stream in self.streams:
            stream.write(data)
            stream.flush()

    def flush(self):
        for stream in self.streams:
            stream.flush()


# Output is captured via stdout redirection by the runner.


def ok(label, cond):
    print("  %s: %s [%s]" % (label, cond, "PASS" if cond else "FAIL"))
    assert cond


print("=" * 70)
print("T1.9 Weyl variational rewrite: structural checks, no EH overclaim")
print("=" * 70)

M = Manifold(4, 'M', structure='Lorentzian')
X.<t, x, y, z> = M.chart()
g = M.metric('eta')
g[0, 0] = -1
g[1, 1] = 1
g[2, 2] = 1
g[3, 3] = 1
nab = g.connection()

print("\n(A) Eq 38: F=dA, antisymmetry, and dF=0")
A = M.one_form('A')
A[0] = function('A0')(t, x, y, z)
A[1] = function('A1')(t, x, y, z)
A[2] = function('A2')(t, x, y, z)
A[3] = function('A3')(t, x, y, z)
F = A.exterior_derivative()
ok_curl = all(
    (F[i, j].expr() - (diff(A[j].expr(), X[i]) - diff(A[i].expr(), X[j]))).simplify_full() == 0
    for i in range(4) for j in range(4)
)
ok("F_ij = d_i A_j - d_j A_i for all components", ok_curl)
ok_antisym = all((F[i, j].expr() + F[j, i].expr()).simplify_full() == 0 for i in range(4) for j in range(4))
ok("F is antisymmetric", ok_antisym)
ok("dF = 0", F.exterior_derivative().is_zero())

print("\n(B) F^2 EL check on a concrete source-free plane wave")
Aw = M.one_form('Aw')
Aw[2] = cos(t - x)
Fw = Aw.exterior_derivative()
divFw = nab(Fw.up(g)).trace(0, 2)
divFw_zero = all(divFw[i].expr().simplify_full() == 0 for i in range(4))
ok("div_mu F^{mu nu}=0 for A_y=cos(t-x)", divFw_zero)
print("  This is a concrete exact solution of the Maxwell EL, not a general derivation.")
print("  The general arbitrary-A identity is handled by 10_T1_9_weyl_strengthening.")

print("\n(C) R-term structural consistency on FLRW, not a derivation of EH variation")
Mc = Manifold(4, 'Mc', structure='Lorentzian')
Xc.<tc, xc, yc, zc> = Mc.chart()
a = function('a')(tc)
gc = Mc.metric('flrw')
gc[0, 0] = -1
gc[1, 1] = a^2
gc[2, 2] = a^2
gc[3, 3] = a^2
nabc = gc.connection()
Ric = gc.ricci()
Rs = gc.ricci_scalar()
G = Ric - (Rs / 2) * gc
G00 = G[0, 0].expr().simplify_full()
print("  G_00 = %s" % G00)
ok("FLRW Einstein tensor is nonzero", bool(G00 != 0))
Rs_expr = Rs.expr().simplify_full()
print("  Ricci scalar R = %s" % Rs_expr)
has_second_derivative = ("tc, tc)" in str(Rs_expr)) or ("D[0, 0]" in str(Rs_expr))
ok("R contains second derivatives of the metric scale factor", has_second_derivative)
divG = nabc(G.up(gc)).trace(0, 2)
divG_zero = all(divG[i].expr().simplify_full() == 0 for i in range(4))
ok("div_mu G^{mu nu}=0 on FLRW", divG_zero)

print("\nSummary:")
print("  Verified here: F=dA identities, one concrete Maxwell EL solution, and")
print("  FLRW Einstein-tensor consistency/order checks.")
print("  Not derived in this script: the Einstein-Hilbert variation")
print("  delta INT R sqrt(-g) -> G_{mu nu}. Derived for DT's own action (Eq 67)")
print("  in Layer3/Sage/einstein_from_dt_action.sage (metric families + an")
print("  off-diagonal instance); the fully general identity is standard (Weyl 1918).")
print("=" * 70)
