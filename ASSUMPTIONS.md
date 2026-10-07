# Assumption ledger

Every assumption DT needs beyond its three laws, kept in one place, so that it
can be judged on the SAME terms as the established theory it recovers.

**The rule.** If DT makes an assumption the Standard Model (or GR) also makes,
it is stated as *"just as the SM assumes X, if DT assumes X, the result is
consistent with the SM"*: neither a defect nor a win. What counts against DT
is an assumption the established theory does NOT need (**DT-specific**); what
counts for it is an established assumption DT does NOT need (**DT saves**).

Categories:
- **SHARED-SM / SHARED-GR**: the established theory assumes the same thing.
- **DT-SPECIFIC**: needed by DT only, usually because DT is 5D.
- **SELECTED**: one reading of DT among several, chosen by data (selected, not derived).
- **DT-SAVES**: something the established theory assumes that DT derives.
- **WILLIAMS DISCREPANCY**: Williams' own reading is excluded by experiment and
  the reading the data select is adopted instead; the discrepancy with Williams
  is recorded in the row. Not a count against DT.

**Williams is the default guide, not the final oracle.** Where DT's structure
(or a shared SM/GR assumption) supports a reading other than Williams', and
experiment selects it, that reading is DT and his is noted as a discrepancy.
Falsification is a test against EXPERIMENT: DT fails only where no reading
its structure supports, plus shared assumptions, fits the data.

## Gravity (Route 2, mass sector)

| # | Assumption | Category | Established counterpart | Result | Script |
|---|---|---|---|---|---|
| G1 | Weyl's R-tilde^2 action, adopted by Williams | SHARED-GR | GR assumes the Einstein-Hilbert action | Einstein + Lambda (Ghilencea) | `weyl_ghilencea_comparison.sage` |
| G2 | u4 = 0 (conservation of mass) | REQUIRED (Bianchi) | GR assumes T conserved | forced by the surface equations | `matter_source_tab.sage` |
| G3 | g44 frozen (conservation of mass as a restriction) | SELECTED (Cassini) | GR has no scalar | PPN gamma = 1 | `kk_radion_g44.sage` |
| G4 | GR strong-field reading, not e^{-lambda/r} as a metric | SELECTED (ringdown, EHT) | GR's Kerr | matches LIGO/EHT | `black_hole_ringdown.sage` |
| G5 | Lorentzian signature | DT-SAVES | GR assumes it | forced by the stability Hessian (T1.6) | Layer 1, `T1_6` |
| G6 | tau-dot_0 (dark-matter floor) | WILLIAMS DISCREPANCY (his tau-dot_0 ~ 5e5 excluded by consistency; tau-dot_0 -> 0, the GR limit, adopted: dark matter then unexplained, as in GR) | none | shape right, size 1e-3..1e-7 (FLAG) | `gr_limit_domain.sage` |

## Quantum / weak sector (Route 3, charge sector)

| # | Assumption | Category | SM counterpart | Result | Script |
|---|---|---|---|---|---|
| Q1 | 5D Dirac equation (adopted ansatz, Report Eq 106) | SHARED-SM | SM postulates the Dirac equation | Clifford algebra, Pauli moment | `dirac_algebra.sage` |
| Q2 | Parity violation / one hand | SHARED-SM | SM assigns left-handed doublets | consistent with Wu, Goldhaber | `weak_parity.sage` |
| Q3 | The hand of the zero modes (one sign of kappa M). [Revised 2026-10-07: Williams' 8x8 is RESTORED, read as one lepton doublet; earlier this row adopted one 4x4 irrep instead] | SHARED-SM (the same one choice of hand) | the same hand assignment | the 8x8 was excluded (N_nu ~ 6) only on the reading where BOTH blocks are neutral; read as (nu_L, e_L) it passes N_nu = 2.99, and its su(2) + u(1) is native (Q6) | `weak_chirality_u4.sage`, `su2_from_5d.sage` |
| Q4 | u4 = 0 read as a no-flux boundary at gamma = 0 | DERIVED (was DT-SPECIFIC) | none needed: SM is 4D | J^4 is the Dirac form of u4 (Heisenberg: dy/dt = alpha^4); on the half-line gamma >= 0 conservation of mass AND unitarity each force J^4(0) = 0; 4D Lorentz invariance leaves only the two CHIRAL boundary conditions; the hand is the one remaining sign (Q3). Rests on x^4 = gamma/a0 read as a half-line with a physical edge, and a local BC | `weak_chirality_u4.sage`, `noflux_boundary_derivation.sage` |
| Q5 | Charged short-range vector field, range hbar/(M_W c) | SHARED-SM | the W boson, M_W (or G_F) input | G_F consistent with the SM; V-A form then automatic | `weak_va_coupling.sage` |
| Q6 | Electroweak structure SU(2)_L x U(1)_Y, T3 - Q sin^2 thW | SPLIT: GLOBAL SU(2)_L x U(1)_Y, the left-handed doublet and |Y| = 1/2 DERIVED; GAUGING (W, Z) and sin^2 thW SHARED-SM (by IMPORT) | the gauged group + one mixing angle | Williams' 8x8 (Eqs 109-111) carries a native su(2)+u(1) (the two blocks are related by charge conjugation); it survives u4 = 0, acting on the zero modes as the doublet (psi_A,L, (psi_B,R)^c), both left-handed; Q = T3 + Y with one neutral member and q = Ze gives (nu_L, e_L), Y = -1/2. Williams' common phase is pure T3 (WILLIAMS DISCREPANCY). Without the gauging DT has no neutral current (NC/CC ~ 3e-67); with it sin^2 thW = 0.2315 fits R_nu, g_V^e, g_A^e, Q_W | `weak_neutral_current.sage`, `su2_from_5d.sage` |
| Q12 | Electroweak symmetry broken by a scalar DOUBLET (Higgs): fixes rho = M_W^2/(M_Z^2 cos^2 thW) = 1 | SHARED-SM (by IMPORT) | the Higgs doublet (scalar content is an SM input; rho = 1 follows from it) | rho_0 = 1.00038(20) measured. Importing it imports the 125 GeV Higgs boson too. Bare-mass tension TESTED -> Q13 | `weak_neutral_current.sage` |
| Q13 | Charged-fermion masses from Yukawa couplings to the Higgs doublet (not DT's 5D mass) | SHARED-SM (by IMPORT) | Yukawa couplings y_f (inputs) | DT's 5D mass (bulk +1 and gamma^4 d4) flips chirality and, inside one 5D field, is SU(2)-invariant only for a VECTOR-LIKE electron: excluded (g_A^e 0 vs -0.503, ~30 sigma; A_e 0 vs 0.1515, ~80 sigma). Chiral electron = two 5D fields whose zero modes DT's mass leaves massless; only psibar_L Phi psi_R works. DT's native mass survives for the heavy mass-axis modes only | `mass_term_su2.sage` |
| Q14 | Colour multiplicity: quarks in N_c = 3 copies (fractional charges 2/3, -1/3) | SHARED-SM (by IMPORT; two constraints DERIVED) | quarks in the SU(3) triplet | DT's 5D spinor has no room (4x4: U(1); Williams' 8x8: abelian U(1)xU(1)); anomaly cancellation of the imported SU(2)_L x U(1)_Y with DT's leptons FORCES an odd N_c with Q_u = 1/2+1/(2N_c); DT's q = Z e then forbids free quarks (confinement as a selection rule). N_c = 3 SELECTED by nucleon charges, R ratio, Z width R_l (selected, not derived) | `strong_sector_su3.sage` |
| Q15 | SU(3)_C gauge dynamics (gluons, asymptotic freedom, confinement) | SHARED-SM (by IMPORT) | gauged SU(3)_C, alpha_s input | DT's phi_0 cannot serve: fitted to alpha_s(m_tau)->alpha_s(M_Z) it turns repulsive before 1 TeV (meas 0.088) and has no string tension. Not a negative for Williams' NUCLEON potential (a role he never gave it) | `strong_sector_su3.sage` |
| Q7 | Particle lambda values (e^{-lambda/r}) | WILLIAMS DISCREPANCY (his 1 fm excluded; lambda_p < ~1.8e-3 fm adopted, a bounded DT parameter) | none (QED needs none) | hydrogen: lambda_p < ~1.8e-3 fm, Williams' 1 fm excluded (NEGATIVE CANDIDATE); the neutron barrier rests on the same 1 fm | `hydrogen_nonsingular_spectrum.sage`, `neutron_lifetime_tunnelling.sage` |
| Q8 | Neutron decay rate: effective units of action hbar'_e, hbar'_p (fitted to mu_n, spin) + tunnelling mass | WILLIAMS DISCREPANCY (his tunnelling lifetime not predictive; decay via the W, Q5, with g_A, V_ud adopted) | SM: 2 measured inputs give 878 s to <1% | DT: book's choices span 10^-27..10^435 s, none near 878 s; natural (m_e, hbar'_e) pairing needs hbar' only 1.54x Williams' value (16 decades in tau); FITTABLE, not predicted | `neutron_lifetime_tunnelling.sage` |
| Q9 | Neutron decay emits a light neutral fermion (a neutrino); Williams' no-neutrino p+e reading EXCLUDED | SHARED-SM, SELECTED by data | Pauli 1930: a light neutral particle carries the missing energy | DT internal energy exactly conserved for any Newton-III violation, so p+e gives a 3 keV line at ~782 keV; 6e-8 of measured decays there, mean missing 481 keV | `beta_spectrum_two_body.sage` |
| Q10 | DT's neutrino is the chiral zero mode of the 5D Dirac field (not Williams' phi_4 wave quantum) | SHARED-SM, SELECTED by data | SM: massless left-handed Weyl neutrino | phi_4 quantum is a 4D scalar (spin 0): excluded by J in n->p+e+X and by helicity 0 vs -1; zero mode: spin 1/2, nu helicity -1, nubar +1, as measured. Rests on Q3 + Q4 (our boundary reading). Massless, like the minimal SM | `neutrino_helicity.sage` |
| Q11 | Williams' neutron (Eq 2.57) carries J = hbar | WILLIAMS DISCREPANCY (excluded by spin 1/2; udd neutron, Q14, adopted) | -- (SM neutron J = 1/2) | Eq 2.57 adds the free p, e spins linearly (h/2+h/2 = h) and fixes the neutron's internal J to match; measured neutron spin 1/2 (2 Stern-Gerlach beams). Defeater: J counted in h' inside the neutron -- but the free neutron is spin 1/2 | `neutrino_helicity.sage` |

## Running count

- SHARED (neutral): G1, Q1, Q2/Q3, Q5, Q6, Q9, Q10, Q12, Q13, Q14, Q15
- SELECTED by data: G3, G4, Q3 (4x4 over 8x8, Z width), Q9, Q10 (G2 upgraded to required)
- DT-SAVES: G5
- DT-SPECIFIC (counts against): none (Q4 derived)
- DERIVED (was an assumption): Q4
- WILLIAMS DISCREPANCY (noted, data-selected reading adopted): G6, Q7, Q8, Q11 (and Williams' readings in Q3, Q9, Q10)
