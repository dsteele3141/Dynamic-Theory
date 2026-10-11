# T2.9 — Spin States & Nucleon Octet (Pages 121-128)
#
# Source: Williams LA-8370-MS (LASL, 1980), pages 121-128.
# Full derivation, context and provenance:
#   Supplementary Materials (stand-alone document) — §S3, Appendix A [C6].

from sage.all import *
from itertools import product


def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label


def mat_zero(M):
    return M.simplify_full().is_zero()


# --- Basic Blocks ---
I2 = identity_matrix(SR, 2)
Z2 = zero_matrix(SR, 2)
s1m = matrix(SR, [[0,1],[1,0]])
s2m = matrix(SR, [[0,-I],[I,0]])
s3m = matrix(SR, [[1,0],[0,-1]])

def block4(a, b, c, d):
    return block_matrix([[a, b], [c, d]], subdivide=False)

# 8x8 gamma-matrices with corrected A
beta = block4(I2, Z2, Z2, -I2)
alpha1 = block4(Z2, s1m, s1m, Z2)
alpha2 = block4(Z2, s2m, s2m, Z2)
alpha3 = block4(Z2, s3m, s3m, Z2)
A_correct = block4(Z2, I*I2, -I*I2, Z2)

Z4 = zero_matrix(SR, 4)
betaT = block4(beta, Z4, Z4, beta)
alphaT1 = block4(Z4, alpha1, alpha1, Z4)
alphaT2 = block4(Z4, alpha2, alpha2, Z4)
alphaT3 = block4(Z4, alpha3, alpha3, Z4)
alphaT4 = block4(A_correct, Z4, Z4, A_correct)

gammas = [betaT, -betaT*alphaT1, -betaT*alphaT2, -betaT*alphaT3, -betaT*alphaT4]

I8 = identity_matrix(SR, 8)

# 1. SPIN OPERATOR ALGEBRA
print("="*60)
print("COMPUTATION 1: Spin Operator Properties")
print("="*60)

# s_a = (i/2)gamma^b gamma^c, u_a = (i/2)gamma^4 gamma^a
s = [None,
     1/2*I * gammas[2]*gammas[3],
     1/2*I * gammas[3]*gammas[1],
     1/2*I * gammas[1]*gammas[2]]
u = [None,
     1/2*I * gammas[4]*gammas[1],
     1/2*I * gammas[4]*gammas[2],
     1/2*I * gammas[4]*gammas[3]]

# Verify squares
print("\nVerifying s_a^2 = u_a^2 = I/4:")
ok("s_a^2 = I/4 for a = 1,2,3.",
   all(mat_zero(s[a]^2 - 1/4*I8) for a in range(1,4)))
ok("u_a^2 = I/4 for a = 1,2,3.",
   all(mat_zero(u[a]^2 - 1/4*I8) for a in range(1,4)))

print("\nVerifying cross-anticommutation {s_a, u_b} for a != b:")
ok("{s1, u2} = 0 (the zeros underpinning S_j^2 = 3/4 I).",
   mat_zero(s[1]*u[2] + u[2]*s[1]))

# 2. FOUR-SPIN COMPONENTS (Eqs on Page 122)
print("\n" + "="*60)
print("COMPUTATION 2: Four-Spin Components S_j")
print("="*60)

S = [None,
     s[1] - u[2] - u[3],
     s[2] + u[1] - u[3],
     s[3] + u[1] + u[2],
     s[1] - s[2] + s[3]]

target_sq = 3/4*I8
ok("S_j^2 = 3/4 I for j = 1..4 (eigenvalues +/- sqrt(3)/2).",
   all(mat_zero(S[j]^2 - target_sq) for j in range(1, 5)))

print("\nRESULT: S_j eigenvalues are +/- sqrt(3)/2.")
print("  Standard spin-1/2 has eigenvalues +/- 1/2.")
print("  Nucleons in 5D theory have spin magnitude sqrt(3)/2 components.")

# 3. OCTET TABLE VERIFICATION
print("\n" + "="*60)
print("COMPUTATION 3: Allowed States & t-Vector Audit")
print("="*60)

H = 1/2
def get_S_values(st):
    s1, s2, s3, u1, u2, u3 = st
    return (s1-u2-u3, s2+u1-u3, s3+u1+u2, s1-s2+s3)

def get_t_correct(st):
    u1, u2, u3 = st[3:]
    return (-(u2+u3), u1-u3, u1+u2)

# Scan for states where all Sj are either +1/2 or -3/2.
# SCOPE (finding L3-04): the S_j in {+1/2,-3/2} restriction is IMPOSED from
# Williams' Page-126 table -- it is NOT derived here from the 5D Dirac equation or
# prior geometry. What follows verifies the CONSISTENCY and CARDINALITY of the
# stated octet table, not the dynamical selection of exactly these eight states.
allowed = []
for st in product((H, -H), repeat=6):
    sv = get_S_values(st)
    if all(val in (H, -3/2) for val in sv):
        allowed.append((st, sv, get_t_correct(st)))

print(f"\nNumber of allowed states found: {len(allowed)}")
ok("Exactly 8 states satisfy the imposed restriction (the table's cardinality).",
   len(allowed) == 8)

state3 = (H, -H, -H, H, H, -H)
for st, sv, tv in allowed:
    if st == state3:
        print(f"  (s; u) = {st}")
        print(f"  S_j = {sv}")
        print(f"  t-vector = {tv}")

print("\nAUDIT: Page 127 t3 = u2 + u3 definition.")
u1_3, u2_3, u3_3 = state3[3:]
t3_manuscript_val = u2_3 + u3_3          # manuscript (wrong) formula
t3_correct_val = u1_3 + u2_3             # corrected formula
print(f"  Manuscript t3 (u2+u3) for state (3): {t3_manuscript_val}")
print(f"  Corrected  t3 (u1+u2) for state (3): {t3_correct_val}")
print("  CONCLUSION: Page 127 formula MUST be t3 = u1 + u2.")
ok("Corrected t-vector for state (3) is (0, 1, 1).", get_t_correct(state3) == (0, 1, 1))
ok("Page-127 source error is real: manuscript t3 (u2+u3) != corrected t3 (u1+u2) for state (3).",
   t3_manuscript_val != t3_correct_val)

print("\nAudit Complete: 17_spin_states.sage")
print("="*60)
