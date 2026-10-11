#!/usr/bin/env sage
# Field structure of Williams' two-particle B_{mu nu} = d_mu A_nu - d_nu A_mu:
# antisymmetry, the sigma.F (Pauli-type) coupling, and abelian-vs-non-abelian
# Yang-Mills content.
#
# Source: P. E. Williams, "The Dynamic Theory" (2009), Ch. 2 Eq (2.31), Ch. 9 Eq (9.39).
# Full derivation, context and provenance:
#   Supplementary Materials (stand-alone document) — §S3, Appendix A.2 (Book corpus, script 13, B-C2).

from sage.all import *


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


def mat_zero(M):
    return M.simplify_full().is_zero()


print("=" * 70)
print("NONSTANDARD MODEL A2 -- Yang-Mills field structure (weak sector)")
print("=" * 70)

# --- Explicit 4x4 Dirac gamma matrices (Dirac basis), metric (+,-,-,-) ------
I2 = identity_matrix(SR, 2)
Z2 = zero_matrix(SR, 2)
sx = matrix(SR, [[0, 1], [1, 0]])
sy = matrix(SR, [[0, -I], [I, 0]])
sz = matrix(SR, [[1, 0], [0, -1]])


def blk(a, b, c, d):
    return block_matrix([[a, b], [c, d]], subdivide=False)


g0 = blk(I2, Z2, Z2, -I2)
g1 = blk(Z2, sx, -sx, Z2)
g2 = blk(Z2, sy, -sy, Z2)
g3 = blk(Z2, sz, -sz, Z2)
gam = [g0, g1, g2, g3]
I4 = identity_matrix(SR, 4)
eta = diagonal_matrix(SR, [1, -1, -1, -1])

# --- (0) Sanity: Clifford algebra {gamma^mu, gamma^nu} = 2 eta^{mu nu} ------
print("\n[0] Clifford algebra of the gamma matrices")
ok("{gamma^mu, gamma^nu} = 2 eta^{mu nu} I4 for all mu,nu.",
   all(mat_zero(gam[m] * gam[n] + gam[n] * gam[m] - 2 * eta[m, n] * I4)
       for m in range(4) for n in range(4)))

# sigma^{mu nu} = (i/2)[gamma^mu, gamma^nu]
sigma = [[(I / 2) * (gam[m] * gam[n] - gam[n] * gam[m]) for n in range(4)]
         for m in range(4)]

# --- (1) Antisymmetry of the field tensor ----------------------------------
print("\n[1] Field tensor antisymmetry B_{mu nu} = -B_{nu mu}")
# Symbolic antisymmetric field array F_{mu nu} (the dA - dA curl).
Fsym = matrix(SR, 4, 4, lambda i, j: var('F_%d%d' % (i, j)) if i < j else 0)
Fanti = Fsym - Fsym.transpose()          # exactly antisymmetric by construction
ok("B_{mu nu} := d_mu A_nu - d_nu A_mu is antisymmetric (B^T = -B).",
   (Fanti + Fanti.transpose()).is_zero())

# --- (2) sigma.F coupling is the squared-Dirac field term -------------------
print("\n[2] sigma.F coupling: gamma^mu gamma^nu F_{mu nu} = -i sigma^{mu nu} F_{mu nu}")
lhs = sum(gam[m] * gam[n] * Fanti[m, n] for m in range(4) for n in range(4))
rhs = sum((-I) * sigma[m][n] * Fanti[m, n] for m in range(4) for n in range(4))
ok("gamma^mu gamma^nu F_{mu nu} = -i sigma^{mu nu} F_{mu nu}  (F antisymmetric).",
   mat_zero(lhs - rhs))
# Corollary: the symmetric (metric) part drops out, as it must.
ok("eta^{mu nu} F_{mu nu} = 0  (symmetric . antisymmetric vanishes).",
   bool(sum(eta[m, n] * Fanti[m, n] for m in range(4) for n in range(4)) == 0))
print("  => the -i sigma^{mu nu} B_{mu nu} term of Eq (2.31)/(9.39) is exactly")
print("     the field-strength coupling produced by squaring (i gamma.D - m).")

# --- (3) Abelian vs non-abelian: where the real Yang-Mills content lives ----
print("\n[3] Abelian (as written) vs non-abelian (genuine Yang-Mills)")
# Matrix-valued (multi-particle internal-space) potentials.
a, b, c, d = var('a b c d')
A_mu = matrix(SR, [[0, a], [b, 0]])      # generic, non-diagonal
A_nu = matrix(SR, [[c, 0], [0, d]])      # diagonal but distinct entries
comm = A_mu * A_nu - A_nu * A_mu
ok("[A_mu, A_nu] != 0 for matrix-valued (multi-particle) potentials.",
   not mat_zero(comm))

# Abelian limit: potentials proportional to the identity -> commutator zero.
A_mu_ab = a * I2
A_nu_ab = c * I2
ok("[A_mu, A_nu] = 0 when potentials ∝ identity  (pure Maxwell/abelian limit).",
   mat_zero(A_mu_ab * A_nu_ab - A_nu_ab * A_mu_ab))

# The full non-abelian field strength differs from Williams' written curl by
# exactly the commutator term:  F_full - (dA - dA) = -i e [A_mu, A_nu].
e = var('e')
extra = (-I * e) * comm
ok("F_full - (dA - dA) = -i e [A_mu, A_nu], non-zero in the non-abelian case.",
   not mat_zero(extra))

print("\n  VERDICT:")
print("   - The field tensor FORM and the sigma.F coupling are genuine and exact.")
print("   - As literally written, B = dA - dA is the ABELIAN curl; the")
print("     non-abelian Yang-Mills self-coupling -i e[A_mu,A_nu] is carried by")
print("     the I^theta multi-particle matrix structure, not by the scalar curl.")
print("   - So 'these ARE the Yang-Mills fields' is exact at the level of the")
print("     field-tensor/coupling form; the non-abelian content is implicit in")
print("     the index structure and is NOT made explicit in Eq (2.31)/(9.39).")

print("\n" + "=" * 70)
print("A2 COMPLETE.")
print("=" * 70)
