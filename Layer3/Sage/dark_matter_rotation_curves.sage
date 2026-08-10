#!/usr/bin/env sage
# Dark matter / rotation curves: DT's time-dependent gravitational field
# reproduces MOND -- flat curves, the a = a_N(1 + r/r_c) law, the baryonic
# Tully-Fisher relation v^4 = G M a0, and the a0 ~ c H0 scale.
#
# Source: P. E. Williams, "The Dynamic Theory", Ch. 3 Eqs (3.24)-(3.36), pp.68-70.
# Full derivation, context and provenance:
#   Supplementary_Material.pdf — §S3, Appendix A.2 (Book corpus, script 23, B-M4).

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


def rel(a, b):
    return abs(float(a) - float(b)) / abs(float(b))


print("=" * 70)
print("DARK MATTER / ROTATION CURVES -- DT time-dependent gravity vs MOND & data")
print("=" * 70)

# --- (1) The correction term is r-independent -> flat curve -----------------
print("\n[1] Eq (3.30): the velocity correction is r-independent (flat floor)")
G, M, r, H0, tau0dot, c, a0 = var('G M r H0 tau0dot c a0', domain='positive')
v2_330 = (G * M / r) * (1 + H0 * tau0dot * r / c)        # Eq (3.30)
v2_expanded = G * M / r + G * M * H0 * tau0dot / c
ok("v^2 = GM/r + (GM H0 tau0dot/c): the second term is independent of r.",
   (v2_330 - v2_expanded).simplify_full() == 0)

# --- (2) Williams' fit tau0dot = c/(r_c H0) -> MOND -------------------------
print("\n[2] With tau0dot = c/(r_c H0), r_c = sqrt(GM/a0): DT == MOND")
r_c = sqrt(G * M / a0)
tau0dot_fit = c / (r_c * H0)
v_flat_sq = (G * M * H0 * tau0dot_fit / c)
a_N = G * M / r**2
a_deep = a_N * r / r_c                                    # deep regime of Eq (3.36)

# Robust identity check: substitute arbitrary positive values (radicals defeat
# symbolic simplify_full here, so compare numerically).
sv = {G: 1.1, M: 2.3, a0: 0.7, H0: 1.9, c: 13.0, r: 5.0}
nz = lambda expr: abs(float(expr.subs(sv))) < 1e-12 * (1 + abs(float((G*M*a0).subs(sv))))
ok("flat-curve speed v_flat^2 = sqrt(G M a0).",
   nz(v_flat_sq - sqrt(G * M * a0)))
ok("deep regime a -> sqrt(a_N a0) (the deep-MOND law).",
   nz(a_deep - sqrt(a_N * a0)))

# --- (3) Tully-Fisher: v_flat^4 = G M a0 ------------------------------------
print("\n[3] Baryonic Tully-Fisher: v_flat^4 = G M a0")
ok("v_flat^4 = G M a0.", nz(v_flat_sq**2 - G * M * a0))

# --- (4) Numerical test against real galaxies -------------------------------
print("\n[4] Numerical: flat speeds for real baryonic masses (a0 = 1.2e-10 m/s^2)")
GG = 6.674e-11
Msun = 1.989e30
a0n = 1.2e-10
def vflat(M_in_Msun):
    return (GG * (M_in_Msun * Msun) * a0n)**0.25      # m/s
for name, Mb, vobs in [("dwarf (1e9 Msun)", 1e9, None),
                       ("Milky Way (6e10)", 6e10, 200e3),
                       ("massive spiral (3e11)", 3e11, 250e3)]:
    vf = vflat(Mb)
    extra = ("  (observed ~%d km/s)" % int(vobs/1e3)) if vobs else ""
    print("    %-22s v_flat = %6.1f km/s%s" % (name, vf/1e3, extra))
ok("Milky-Way-scale baryonic mass gives a realistic flat speed (150-250 km/s).",
   150e3 < vflat(6e10) < 250e3)
# Tully-Fisher scaling: 16x mass -> 2x speed (v ~ M^{1/4})
ok("Tully-Fisher scaling v ~ M^{1/4} (16x mass -> 2x speed).",
   abs(vflat(16e9) / vflat(1e9) - 2.0) < 0.01)

# --- (5) The MOND scale is naturally ~ c H0 ---------------------------------
print("\n[5] Cosmic coincidence: the MOND scale a0 ~ c H0 / (2 pi)")
H0n = 70e3 / 3.0857e22         # s^-1
cH0 = 2.99792458e8 * H0n
print("    c H0       = %.3g m/s^2" % cH0)
print("    a0 (MOND)  = %.3g m/s^2" % a0n)
print("    a0/(c H0)  = %.3f   (1/2pi = %.3f)" % (a0n / cH0, float(1/(2*pi))))
ok("a0 is of order c H0 (within a factor ~2 pi) -- set by the H0 time-dependence.",
   0.05 < a0n / cH0 < 0.5)

print("\n  NET: DT's time-dependent gravity reproduces MOND -- flat rotation curves,")
print("  the a = a_N(1 + r/r_c) law, and the baryonic Tully-Fisher v^4 = G M a0 --")
print("  with realistic speeds and NO dark matter. The MOND scale a0 emerges at")
print("  the c H0 scale naturally. BOUND: the onset is set by fitting tau0dot per")
print("  galaxy (~1/sqrt(M)); DT reproduces MOND phenomenology but does not derive")
print("  a0 parameter-free. Full write-up: mass-sector-postdictions.txt.")

print("\n" + "=" * 70)
print("23 COMPLETE.")
print("=" * 70)
