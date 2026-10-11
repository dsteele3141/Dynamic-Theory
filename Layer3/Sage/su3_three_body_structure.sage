#!/usr/bin/env sage
# DT's 3-body cyclic construction C^theta = A^beta + A^gamma vs su(3): establish
# the Gell-Mann su(3) algebra, then show the cyclic map is circulant/abelian
# (a Cartan slice, not the 8-generator non-abelian su(3)).
#
# Source: P. E. Williams, "The Dynamic Theory" (2009), Ch. 2 Eq (2.32), Ch. 9 Eqs (9.40)-(9.41).
# Full derivation, context and provenance:
#   Supplementary Materials (stand-alone document) — §S3, Appendix A.2 (Book corpus, script 14, B-C1).

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


def mat_zero(M):
    return M.simplify_full().is_zero()


print("=" * 70)
print("NONSTANDARD MODEL A3 -- 3-body cyclic structure vs su(3) (strong sector)")
print("=" * 70)

# --- (1) Establish su(3): the 8 Gell-Mann generators ------------------------
print("\n[1] Establish su(3): Gell-Mann generators close with standard f^{abc}")
rt3 = sqrt(SR(3))
lam = [
    matrix(SR, [[0, 1, 0], [1, 0, 0], [0, 0, 0]]),                 # 1
    matrix(SR, [[0, -I, 0], [I, 0, 0], [0, 0, 0]]),                # 2
    matrix(SR, [[1, 0, 0], [0, -1, 0], [0, 0, 0]]),                # 3
    matrix(SR, [[0, 0, 1], [0, 0, 0], [1, 0, 0]]),                 # 4
    matrix(SR, [[0, 0, -I], [0, 0, 0], [I, 0, 0]]),                # 5
    matrix(SR, [[0, 0, 0], [0, 0, 1], [0, 1, 0]]),                 # 6
    matrix(SR, [[0, 0, 0], [0, 0, -I], [0, I, 0]]),                # 7
    (1 / rt3) * matrix(SR, [[1, 0, 0], [0, 1, 0], [0, 0, -2]]),    # 8
]
T = [l / 2 for l in lam]
I3 = identity_matrix(SR, 3)

ok("All lambda_a are traceless.", all((l.trace() == 0) for l in lam))
ok("All lambda_a are Hermitian.",
   all(mat_zero(l - l.conjugate_transpose()) for l in lam))
ok("Orthonormal: tr(lambda_a lambda_b) = 2 delta_ab.",
   all(mat_zero(matrix(SR, [[(lam[a] * lam[b]).trace() - 2 * (1 if a == b else 0)]]))
       for a in range(8) for b in range(8)))


# Structure constants from f_abc = -2 i tr([T_a,T_b] T_c).
def fabc(a, b, c):
    comm = T[a] * T[b] - T[b] * T[a]
    return (-2 * I * (comm * T[c]).trace()).simplify_full()


# Closure: every commutator reconstructs as i sum_c f_abc T_c.
closure_ok = True
for a in range(8):
    for b in range(8):
        comm = T[a] * T[b] - T[b] * T[a]
        recon = I * sum(fabc(a, b, c) * T[c] for c in range(8))
        if not mat_zero(comm - recon):
            closure_ok = False
ok("[T_a,T_b] = i f^{abc} T_c closes for ALL a,b (su(3) Lie algebra).", closure_ok)

# Spot-check the standard structure constants (1-indexed in the literature).
ok("f123 = 1.", fabc(0, 1, 2) == 1)
ok("f458 = sqrt(3)/2.", (fabc(3, 4, 7) - rt3 / 2).simplify_full() == 0)
ok("f678 = sqrt(3)/2.", (fabc(5, 6, 7) - rt3 / 2).simplify_full() == 0)
ok("f147 = 1/2.", fabc(0, 3, 6) == 1 / 2)
# Total antisymmetry (representative).
ok("f^{abc} totally antisymmetric: f123 = -f213 = f231.",
   (fabc(0, 1, 2) == -fabc(1, 0, 2)) and (fabc(0, 1, 2) == fabc(1, 2, 0)))
# Non-abelian: at least one commutator is non-zero.
ok("su(3) is NON-ABELIAN: [T_1,T_2] != 0.",
   not mat_zero(T[0] * T[1] - T[1] * T[0]))

# --- (2) Williams' cyclic construction on the 3 particle labels ------------
print("\n[2] Williams' cyclic combination C^theta = A^beta + A^gamma")
# 3-cycle permutation P (1->2->3->1) and the all-ones J.
P = matrix(SR, [[0, 0, 1], [1, 0, 0], [0, 1, 0]])
J = matrix(SR, 3, 3, lambda i, j: 1)
M = matrix(SR, [[0, 1, 1], [1, 0, 1], [1, 1, 0]])   # row theta picks the OTHER two labels

ok("Cyclic map M = J - I.", mat_zero(M - (J - I3)))
ok("Cyclic map M = P + P^2  (M is CIRCULANT).", mat_zero(M - (P + P * P)))
ok("J = I + P + P^2  (sum of the 3 cyclic permutations).",
   mat_zero(J - (I3 + P + P * P)))
ok("P^3 = I  (P is the 3-cycle).", mat_zero(P * P * P - I3))

# --- (3) The construction is abelian (circulant) -> only a Cartan slice ----
print("\n[3] Circulant => commuting => at most a Cartan (rank-2) slice of su(3)")
ok("[M, P] = 0.", mat_zero(M * P - P * M))
ok("[P, P^2] = 0.", mat_zero(P * (P * P) - (P * P) * P))
ok("[M, P^2] = 0.", mat_zero(M * (P * P) - (P * P) * M))
print("  => {I, P, P^2, M} generate a COMMUTATIVE (circulant) algebra:")
print("     the full Williams cyclic construction is abelian.")

# i*M is a legitimate su(3) element (traceless, anti-Hermitian) ...
iM = I * M
ok("i*M is traceless.", iM.trace() == 0)
ok("i*M is anti-Hermitian  => i*M lies IN su(3).",
   mat_zero(iM + iM.conjugate_transpose()))
print("  ... but only as ONE Cartan-type element; the accessible traceless")
print("      anti-Hermitian circulant space has dimension <= 2 (= rank su(3)),")
print("      NOT 8.")

# Genuine off-diagonal su(3) generators are NOT circulant -> unreachable.
def is_circulant(Mx):
    c0, c1, c2 = Mx[0, 0], Mx[0, 1], Mx[0, 2]
    target = matrix(SR, [[c0, c1, c2], [c2, c0, c1], [c1, c2, c0]])
    return mat_zero(Mx - target)

ok("M is circulant.", is_circulant(M))
ok("lambda_4 (off-diagonal 1<->3 coupling) is NOT circulant => unreachable.",
   not is_circulant(lam[3]))
ok("lambda_6 (off-diagonal 2<->3 coupling) is NOT circulant => unreachable.",
   not is_circulant(lam[5]))

print("\n  VERDICT:")
print("   - DT's 3-body equation genuinely carries the fundamental TRIPLET")
print("     (the '3' of SU(3)) index structure -- this much is real.")
print("   - But the explicit cyclic combination C = A^beta + A^gamma is")
print("     circulant/abelian: it reaches only a Cartan (maximal-torus) slice,")
print("     not the 8-generator non-abelian su(3).  No f^{abc}, no colour, no")
print("     gluon octet are produced.  'SU(3) characteristics' = triplet +")
print("     Cartan resemblance, NOT a derivation of the QCD gauge algebra.")

print("\n" + "=" * 70)
print("A3 COMPLETE.")
print("=" * 70)
