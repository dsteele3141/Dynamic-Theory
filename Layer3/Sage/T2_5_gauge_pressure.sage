#!/usr/bin/env sage
# T2.5 — Gauge field pressure (reduced radiation pressure; prediction P1)
#   pressure p = -(1/24pi)[E^2 + B^2 + 3 V0^2 - V^2].
#
# Source: Williams LA-8370-MS (1980), Section III.e, pages 100-103, eq p.102.
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S3, Appendix A [C8].

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


def ok(label, cond):
    print("  %s: %s [%s]" % (label, cond, "PASS" if cond else "FAIL"))
    assert cond


print("=" * 70)
print("T2.5 gauge pressure rewrite")
print("=" * 70)

var('E1 E2 E3 B1 B2 B3 V1 V2 V3 V0', domain='real')
E = vector([E1, E2, E3])
B = vector([B1, B2, B3])
V = vector([V1, V2, V3])
Esq = E.dot_product(E)
Bsq = B.dot_product(B)
Vsq = V.dot_product(V)
I3 = identity_matrix(SR, 3)

def outer(a, b):
    return matrix(SR, 3, 3, lambda i, j: a[i] * b[j])

TD = (
    outer(E, E) + outer(B, B) - outer(V, V)
    - (1/2) * (Esq + Bsq + V0^2 - Vsq) * I3
)
t_tensor = (
    outer(E, E) + outer(B, B) - outer(V, V)
    - (1/3) * (Esq + Bsq - Vsq) * I3
)
tau = TD - t_tensor

print("\n(A) Traceless/isotropic split")
tr_t = t_tensor.trace().simplify_full()
ok("tr(t)=0 with corrected 1/3 coefficient", tr_t == 0)
tr_tau = tau.trace().simplify_full()
expected_tr_tau = -(1/2) * (Esq + Bsq + 3*V0^2 - Vsq)
ok("tr(tau') expected value", (tr_tau - expected_tr_tau).simplify_full() == 0)
ok("tau' isotropic", (tau - (tr_tau/3)*I3).simplify_full() == matrix(SR, 3, 3, 0))

print("\n(B) Pressure and classical limit")
p = (TD.trace() / (12*pi)).simplify_full()
p_expected = -(Esq + Bsq + 3*V0^2 - Vsq) / (24*pi)
ok("p = -(E^2+B^2+3V0^2-V^2)/(24*pi)", (p - p_expected).simplify_full() == 0)
p_classical = p.subs({V1: 0, V2: 0, V3: 0, V0: 0}).simplify_full()
u = (Esq + Bsq) / (8*pi)
ok("V=V0=0 gives p=-(1/3)u", (p_classical + u/3).simplify_full() == 0)

print("\n(C) V-field correction and the EXACT reduction condition")
dp = (p - p_classical).simplify_full()
ok("Delta p = (V^2-3V0^2)/(24*pi)", (dp - (Vsq - 3*V0^2)/(24*pi)).simplify_full() == 0)
# Write A = E^2+B^2 > 0 and D = V^2 - 3 V0^2, so 24*pi*p_cl = -A, 24*pi*p_DT = -A+D.
# |p_DT| < |p_cl|  <=>  |-A+D| < A  <=>  -A < -A+D < A  <=>  0 < D < 2A.
# The condition D > 0 (V^2 > 3V0^2) ALONE is INSUFFICIENT: for D > 2A the
# pressure flips positive with magnitude EXCEEDING the classical value.
print("  With A=E^2+B^2>0 and D=V^2-3V0^2: 24pi*p_cl=-A, 24pi*p_DT=-A+D.")
print("  EXACT reduced-magnitude condition: 0 < D < 2A  (NOT merely D>0).")

# numeric: reduced case 0<D<2A
sample_reduce = {E1: 1, E2: 0, E3: 0, B1: 0, B2: 1, B3: 0, V1: 4/5, V2: 0, V3: 0, V0: 1/10}
p_num = p.subs(sample_reduce).n(); pcl_num = p_classical.subs(sample_reduce).n()
D_red = (Vsq - 3*V0^2).subs(sample_reduce).n(); A_red = (Esq + Bsq).subs(sample_reduce).n()
ok("reduced case: 0<D<2A holds and |p| is reduced",
   (0 < D_red < 2*A_red) and abs(p_num) < abs(pcl_num))

# numeric: D<0 (V^2<3V0^2) increases magnitude
sample_increase = {E1: 1, E2: 0, E3: 0, B1: 0, B2: 1, B3: 0, V1: 1/10, V2: 0, V3: 0, V0: 4/5}
p_inc = p.subs(sample_increase).n(); pcl_inc = p_classical.subs(sample_increase).n()
D_inc = (Vsq - 3*V0^2).subs(sample_increase).n()
ok("D<0 case: not (0<D<2A) and |p| is increased",
   not (0 < D_inc) and abs(p_inc) > abs(pcl_inc))

# numeric: OVERSHOOT counterexample D>2A (V^2>3V0^2 but magnitude NOT reduced)
sample_overshoot = {E1: 1, E2: 0, E3: 0, B1: 0, B2: 0, B3: 0, V1: 3, V2: 0, V3: 0, V0: 0}
p_ov = p.subs(sample_overshoot).n(); pcl_ov = p_classical.subs(sample_overshoot).n()
D_ov = (Vsq - 3*V0^2).subs(sample_overshoot).n(); A_ov = (Esq + Bsq).subs(sample_overshoot).n()
ok("OVERSHOOT: D>0 (V^2>3V0^2) yet |p| NOT reduced when D>2A",
   (D_ov > 0) and (D_ov > 2*A_ov) and abs(p_ov) >= abs(pcl_ov))

zero_sub = {V1: sqrt(Esq + Bsq + 3*V0^2), V2: 0, V3: 0}
ok("p=0 when V^2=E^2+B^2+3V0^2", p.subs(zero_sub).simplify_full() == 0)

print("\nSummary:")
print("  EXACT reduction condition: 0 < V^2-3V0^2 < 2(E^2+B^2).")
print("  D>0 alone is insufficient: D>2A overshoots to a larger positive pressure.")
print("=" * 70)
