#!/usr/bin/env sage
# --------------------------------------------------------------------------
# SOURCE: analysis built on script 34 (DT gravitational-Bohr ladder r_n = a1 n^2,
#   Mercury anchored at n0=3) + standard planetary data (semi-major axes, masses).
#   Purpose: separate the TWO effects behind the empty orbits -- (i) the quantised
#   ladder (sets allowed radii), (ii) the planet-mass "feeding"/clearing effect
#   (Hill-radius zones a massive planet sweeps clear). Question: from Jupiter
#   outward, does the pattern of UNFILLED levels track the giants' clearing widths?
# --------------------------------------------------------------------------

# ============================================================================
# 34d_gap_vs_feeding_pattern.sage               [A]  (assertion-hardened)
# RUN: /home/dsteele/miniconda3/envs/sage/bin/sage 34d_gap_vs_feeding_pattern.sage
# ============================================================================

from sage.all import *

def ok(label, cond):
    cond = bool(cond)
    print("  [%s] %s" % ("PASS" if cond else "FAIL", label))
    assert cond, "ASSERTION FAILED: " + label

MSUN_ME = 332946.0                       # Sun mass in Earth masses
# planet: (name, a_AU, mass_Mearth)
P = [("Mercury",0.387,0.0553),("Venus",0.723,0.815),("Earth",1.000,1.000),
     ("Mars",1.524,0.107),("Jupiter",5.203,317.8),("Saturn",9.537,95.16),
     ("Uranus",19.191,14.54),("Neptune",30.07,17.15)]
names=[p[0] for p in P]; a=[p[1] for p in P]; m=[p[2] for p in P]

# --- DT ladder, Mercury anchored at n0 = 3 (script 34's canonical fit) -------
n0 = 3
a1 = a[0]/n0**2                          # ladder scale in AU  (n=1 radius)
nval = [n0*sqrt(a[i]/a[0]) for i in range(len(P))]
nint = [Integer(round(x)) for x in nval]

print("="*74)
print("34d  UNFILLED-ORBIT PATTERN FROM JUPITER OUTWARD (ladder x feeding)")
print("="*74)
print("\nDT ladder r_n = a1 n^2, a1 = %.4f AU (Mercury=n0=3)" % a1)
for i in range(len(P)):
    print("   %-8s a=%7.3f AU  m=%7.2f Me  ->  n=%6.3f (level %2d)"
          % (names[i], a[i], m[i], nval[i], nint[i]))

# --- inner system: consecutive, no gaps -------------------------------------
print("\n[1] Inner system (Mercury..Mars): consecutive levels, no gaps")
inner = nint[:4]
ok("Mercury..Mars occupy CONSECUTIVE levels %s (delta n = 1, zero empty)"
   % list(inner), all(inner[i+1]-inner[i]==1 for i in range(3)))

# --- from Jupiter outward: gaps and Hill-radius separations ------------------
print("\n[2] From Jupiter outward: empty levels vs mutual-Hill-radius spacing")
print("    pair                empty levels   sep (AU)   mutual R_H (AU)   sep/R_H")
idx = [3,4,5,6,7]                        # Mars, Jup, Sat, Ura, Nep
gaps=[]; hill_sep=[]
for k in range(len(idx)-1):
    i,j = idx[k], idx[k+1]
    empties = int(nint[j]-nint[i]-1)
    da = a[j]-a[i]
    RHm = ((m[i]+m[j])/(3*MSUN_ME))**(1/3) * (a[i]+a[j])/2      # mutual Hill radius
    sep_in_RH = da/RHm
    gaps.append(empties); hill_sep.append(float(sep_in_RH))
    print("    %-8s->%-8s   %2d           %7.3f    %8.4f        %6.2f"
          % (names[i], names[j], empties, da, RHm, sep_in_RH))

# --- each giant's own clearing width, expressed in ladder LEVELS -------------
print("\n[3] Each giant's clearing zone as a number of LADDER LEVELS")
print("    (zone ~ C mutual-Hill-radii; convert dr->dn via dn = dr*n/(2a))")
print("    planet     R_H (AU)   R_H in levels   clear +-3 R_H (levels)")
for i in [4,5,6,7]:
    RH = (m[i]/(3*MSUN_ME))**(1/3) * a[i]
    dn_per_RH = RH*nval[i]/(2*a[i])                # levels spanned by one R_H
    clear = 2*3*dn_per_RH                          # +-3 Hill radii, both sides
    print("    %-8s  %7.4f    %6.2f          %6.2f"
          % (names[i], RH, dn_per_RH, clear))

# --- the pattern --------------------------------------------------------------
print("\n[4] The pattern")
print("    empty-level counts (Jup-out): %s  (mean %.1f)"
      % (gaps, float(sum(gaps))/len(gaps)))
print("    Hill-radius spacings        : %s" % ["%.1f"%x for x in hill_sep])
ok("there ARE gaps everywhere from Mars->Jupiter outward (every pair has >=1 empty)",
   all(g>=1 for g in gaps))
ok("empty-level count is roughly CONSTANT (~3-5), not growing without bound "
   "(max-min <= 2)", max(gaps)-min(gaps) <= 2)
ok("Jupiter-Saturn is the TIGHTEST pair in Hill radii (the two most massive "
   "planets clear the widest zones, so fewest R_H between them)",
   hill_sep[1] == min(hill_sep))
# the terrestrial pairs, for contrast, are MANY more Hill radii apart:
RHm_EM = ((m[2]+m[3])/(3*MSUN_ME))**(1/3)*(a[2]+a[3])/2
sep_EM = (a[3]-a[2])/RHm_EM
print("    (contrast: Earth-Mars = %.0f mutual R_H, but ZERO empty levels -- the"
      % sep_EM)
print("     terrestrials are widely spaced in R_H yet consecutive in n)")

print("\n"+"-"*74)
print("VERDICT / READING")
print("-"*74)
print("From Jupiter outward the unfilled-orbit pattern is a SUPERPOSITION:")
print(" * LADDER effect: adjacent giants sit ~4-6 levels apart (n ~ 11,15,21,26),")
print("   because their real orbit-radius RATIOS (~1.6-2) map to delta-n ~ sqrt(ratio)")
print("   at those n -- so ~3-5 EMPTY levels sit between each giant. Roughly constant,")
print("   set by the geometry of an n^2 ladder over a ~geometric spacing.")
print(" * FEEDING effect: those same giants are spaced only ~8-16 MUTUAL HILL RADII")
print("   apart, and the Jupiter-Saturn pair (most massive) is the TIGHTEST in Hill")
print("   radii -- a massive planet clears a wide zone, so the levels inside it stay")
print("   empty. The +-3 R_H clearing width of each giant is ~1-3 levels, comparable")
print("   to the observed adjacent empties -- the two pictures are CONSISTENT in size.")
print("KEY CONTRAST: the terrestrials are MANY Hill radii apart yet occupy CONSECUTIVE")
print("levels (no gaps), while the giants are FEW Hill radii apart yet leave 3-5 empty")
print("levels each. So the empties are NOT set by the ladder alone nor by mass alone --")
print("they are where a big planet's clearing zone happens to straddle several closely-")
print("spaced high-n levels. Occupation = feeding/dynamics; allowed radii = ladder.")
print("Neither effect needs the other, and standard feeding reproduces the pattern")
print("without the ladder -- consistent with the 'inconclusive' verdict.")
print("="*74)
print("34d COMPLETE.")
print("="*74)
