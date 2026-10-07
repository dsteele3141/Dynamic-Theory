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

## Gravity (Route 2, mass sector)

| # | Assumption | Category | Established counterpart | Result | Script |
|---|---|---|---|---|---|
| G1 | Weyl's R-tilde^2 action, adopted by Williams | SHARED-GR | GR assumes the Einstein-Hilbert action | Einstein + Lambda (Ghilencea) | `weyl_ghilencea_comparison.sage` |
| G2 | u4 = 0 (conservation of mass) | REQUIRED (Bianchi) | GR assumes T conserved | forced by the surface equations | `matter_source_tab.sage` |
| G3 | g44 frozen (conservation of mass as a restriction) | SELECTED (Cassini) | GR has no scalar | PPN gamma = 1 | `kk_radion_g44.sage` |
| G4 | GR strong-field reading, not e^{-lambda/r} as a metric | SELECTED (ringdown, EHT) | GR's Kerr | matches LIGO/EHT | `black_hole_ringdown.sage` |
| G5 | Lorentzian signature | DT-SAVES | GR assumes it | forced by the stability Hessian (T1.6) | Layer 1, `T1_6` |
| G6 | tau-dot_0 (dark-matter floor) | DT-SPECIFIC, free | none | shape right, size 1e-3..1e-7 (FLAG) | `gr_limit_domain.sage` |

## Quantum / weak sector (Route 3, charge sector)

| # | Assumption | Category | SM counterpart | Result | Script |
|---|---|---|---|---|---|
| Q1 | 5D Dirac equation (adopted ansatz, Report Eq 106) | SHARED-SM | SM postulates the Dirac equation | Clifford algebra, Pauli moment | `dirac_algebra.sage` |
| Q2 | Parity violation / one hand | SHARED-SM | SM assigns left-handed doublets | consistent with Wu, Goldhaber | `weak_parity.sage` |
| Q3 | One 4x4 irrep (one sign of kappa) instead of Williams' 8x8 | SHARED-SM (same one choice as Q2) | the same hand assignment | single left-handed zero mode | `weak_chirality_u4.sage` |
| Q4 | u4 = 0 read as a no-flux boundary at gamma = 0 | DT-SPECIFIC (our reading) | none needed: SM is 4D | makes 5D chirality possible | `weak_chirality_u4.sage` |
| Q5 | Charged short-range vector field, range hbar/(M_W c) | SHARED-SM | the W boson, M_W (or G_F) input | G_F consistent with the SM; V-A form then automatic | `weak_va_coupling.sage` |
| Q6 | Neutral weak current | SHARED-SM (not yet tested) | the Z boson | open | - |
| Q7 | Particle lambda values (e^{-lambda/r}) | DT-SPECIFIC | none (QED needs none) | hydrogen: lambda_p < ~1.8e-3 fm, Williams' 1 fm excluded (NEGATIVE CANDIDATE); the neutron barrier rests on the same 1 fm | `hydrogen_nonsingular_spectrum.sage`, `neutron_lifetime_tunnelling.sage` |
| Q8 | Neutron decay rate: effective units of action hbar'_e, hbar'_p (fitted to mu_n, spin) + tunnelling mass | DT-SPECIFIC (SM counterpart: g_A, V_ud measured) | SM: 2 measured inputs give 878 s to <1% | DT: book's choices span 10^-27..10^435 s, none near 878 s; natural (m_e, hbar'_e) pairing needs hbar' only 1.54x Williams' value (16 decades in tau); FITTABLE, not predicted | `neutron_lifetime_tunnelling.sage` |
| Q9 | Neutron decay emits DT's phi_4 quantum (a neutrino); Williams' no-neutrino p+e reading EXCLUDED | SHARED-SM, SELECTED by data | Pauli 1930: a light neutral particle carries the missing energy | DT internal energy exactly conserved for any Newton-III violation, so p+e gives a 3 keV line at ~782 keV; 6e-8 of measured decays there, mean missing 481 keV; with the phi_4 quantum the spectrum follows the SM's (open: helicity Q2/Q3, strength Q5) | `beta_spectrum_two_body.sage` |

## Running count

- SHARED (neutral): G1, Q1, Q2/Q3, Q5, Q6, Q9
- SELECTED by data: G3, G4, Q9 (G2 upgraded to required)
- DT-SAVES: G5
- DT-SPECIFIC: G6, Q4, Q7, Q8
