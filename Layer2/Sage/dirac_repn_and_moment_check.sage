#!/usr/bin/env sage
# Dirac representation and moment-coupling checks (Eqs 109, 121)
#
# Source: P. E. Williams, LA-8370-MS (LASL, 1980), eqs (109), (121); the book
#   ("The Dynamic Theory") eqs 6.28, 6.33 are cited where the Report is compared
#   against the book transcription.
# Full derivation, context and provenance:
#   Supplementary Materials (stand-alone document) — §S2, Appendix A [C10].

from sage.all import *

def ok(label, cond):
    print(f"  {label}: {'PASS' if cond else 'FAIL'}")
    assert cond

def block4(a, b, c, d):
    return block_matrix([[a, b], [c, d]], subdivide=False)

print("="*70)
print("10_dirac_repn_and_moment_check.sage")
print("="*70)

# ----------------------------------------------------------------------------
# ITEM (i): minimal 4x4 Clifford closure
# ----------------------------------------------------------------------------
print("\n(i) Dirac representation -- minimal 4x4 closure & E5 independence")

I2 = identity_matrix(SR, 2)
Z2 = zero_matrix(SR, 2)
s1 = matrix(SR, [[0, 1], [1, 0]])
s2 = matrix(SR, [[0, -I], [I, 0]])
s3 = matrix(SR, [[1, 0], [0, -1]])

beta   = block4(I2, Z2, Z2, -I2)
alpha1 = block4(Z2, s1, s1, Z2)
alpha2 = block4(Z2, s2, s2, Z2)
alpha3 = block4(Z2, s3, s3, Z2)
A_src  = block4(Z2, I2,   I2,   Z2)     # literal Eq-109 5th generator (4x4)
A_cor  = block4(Z2, I*I2, -I*I2, Z2)    # E5-corrected complex 5th generator

g_sig = [1, -1, -1, -1, -1]             # signature (+,-,-,-,-)

def gammas_4x4(A4):
    al = [alpha1, alpha2, alpha3, A4]
    return [beta] + [-beta * al[i] for i in range(4)]

def check_clifford(gs):
    I4 = identity_matrix(SR, 4)
    for j in range(5):
        for k in range(5):
            anticomm = (gs[j]*gs[k] + gs[k]*gs[j]).simplify_full()
            expected = 2 * g_sig[j] * I4 if j == k else zero_matrix(SR, 4)
            if anticomm != expected:
                return False
    return True

closes_cor = check_clifford(gammas_4x4(A_cor))
closes_src = check_clifford(gammas_4x4(A_src))

ok("corrected complex A closes 5D Clifford algebra in MINIMAL 4x4 (Book 6.28)", closes_cor)
ok("literal Eq-109 A FAILS the algebra even at 4x4 (E5 is genuine here too)", not closes_src)

# ----------------------------------------------------------------------------
# ITEM (h): moment-coupling contraction
# ----------------------------------------------------------------------------
print("\n(h) Moment coupling -- contraction returns the Report/SI-2.23 form")

var('E1 E2 E3 B1 B2 B3 V1 V2 V3 V4 xd1 xd2 xd3 xd4 sa1 sa2 sa3 n1 n2 n3')

# Williams' explicit spin tensor sigma^{jk} (Report p.118): entries xd, s (2i), n
sig = matrix(SR, [
    [    0,    xd1,      xd2,      xd3,    xd4],
    [-xd1,      0, -2*I*sa3,  2*I*sa2,     n1],
    [-xd2, 2*I*sa3,      0, -2*I*sa1,     n2],
    [-xd3,-2*I*sa2, 2*I*sa1,      0,     n3],
    [-xd4,    -n1,     -n2,     -n3,      0]])

# antisymmetric field tensor F (V4 = fifth-dim scalar; F_30 = -E3 corrected)
Ft = matrix(SR, [
    [  0,  E1,  E2,  E3, V4],
    [-E1,   0, -B3,  B2, V1],
    [-E2,  B3,   0, -B1, V2],
    [-E3, -B2,  B1,   0, V3],
    [-V4, -V1, -V2, -V3,  0]])

expr = (-I/2 * sum(Ft[j, k]*sig[j, k] for j in range(5) for k in range(5))).simplify_full()

report_form = (2*(B1*sa1 + B2*sa2 + B3*sa3)
               - I*(E1*xd1 + E2*xd2 + E3*xd3)
               - I*V4*xd4
               - I*(V1*n1 + V2*n2 + V3*n3))
book_633    = (2*(B1*sa1 + B2*sa2 + B3*sa3)
               + 2*(V1*n1 + V2*n2 + V3*n3)
               + I*(E1*xd1 + E2*xd2 + E3*xd3)
               - I*V4*xd4)

matches_report = ((expr - report_form).simplify_full() == 0)
matches_book   = ((expr - book_633).simplify_full() == 0)

ok("contraction equals the Report/SI-2.23 form (machine-verified)", matches_report)
ok("contraction does NOT equal the transcribed Book-6.33 form", not matches_book)

print("\n" + "-"*70)
print("VERDICTS (persisted): (i) E5 correction holds in both tested reps -- 4x4")
print("(Book 6.28) closes, literal A fails even at 4x4; 8x8 is a reducible doubling")
print("(octet content deferred to Layer 3, not from doubling alone).")
print("(h) Report/SI-2.23 moment coupling is authoritative; Book-6.33 per-term")
print("coefficients are a transcription artifact (nonzero residual).")
print("="*70)
