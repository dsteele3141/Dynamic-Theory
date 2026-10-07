# Verification Code Index

Maps the reference codes used in the Supplementary Material to the file(s) in this repository. `[Cn]` codes (Appendix A) restart per layer; Layer-3 **book-extension** scripts (Appendix A.2) are tagged by the §7 block (`B-Cn` charge/particle, `B-Mn` mass/gravity) they support. Lean modules carry the proofs; Sage scripts give symbolic cross-checks/illustrations.


## Layer 1 — Foundations: Space–Time–Matter Geometry

| Code | Lean module(s) | Sage script(s) |
|------|----------------|----------------|
| **C1** | `Layer1/Lean/T1_1_IntegratingFactor.lean` | `Layer1/Sage/T1_1-3_integrating_factor.sage` |
| **C2** | `Layer1/Lean/T1_1_Universality.lean` | — |
| **C3** | `Layer1/Lean/T1_2_AbsoluteVelocity.lean` | — |
| **C4** | `Layer1/Lean/T1_3_Entropy.lean` | — |
| **C5** | `Layer1/Lean/T1_4_MaxwellRelations.lean` | `Layer1/Sage/T1_4_maxwell_relations.sage` |
| **C6** | `Layer1/Lean/T1_10_Equilibrium.lean` | `Layer1/Sage/T1_10_equilibrium.sage` |
| **C7** | `Layer1/Lean/T1_5_Sylvester.lean` | `Layer1/Sage/T1_5_stability_conditions.sage` |
| **C8** | `Layer1/Lean/T1_6_StabilityMetric.lean`<br>`Layer1/Lean/T1_6_SignatureNecessity.lean`<br>`Layer1/Lean/T1_6_SignatureInertia.lean` | `Layer1/Sage/T1_6_stability_metric.sage` |
| **C9** | `Layer1/Lean/T1_7_8_Connection.lean` | `Layer1/Sage/T1_9_weyl_variational.sage` |
| **C10** | — | `Layer1/Sage/T1_8_weyl_integrability.sage`<br>`Layer1/Sage/T1_8_conformal_gauge.sage`<br>`Layer1/Sage/T1_9_weyl_strengthening.sage` |
| **C11** | — | `Layer1/Sage/arrow_of_time.sage` |
| **C12** | — | `Layer1/Sage/T1_6_general_lorentzian_necessity.sage` |

## Layer 2 — Routes: 5D Geometry, Field Equations, Spinor Sector

| Code | Lean module(s) | Sage script(s) |
|------|----------------|----------------|
| **C1** | `Layer2/Lean/T2_1_Minkowski5D.lean` | `Layer2/Sage/T2_1_5D_minkowski.sage` |
| **C2** | — | `Layer2/Sage/christoffel_connection.sage`<br>`Layer2/Sage/setup.sage` |
| **C3** | — | `Layer2/Sage/bianchi_maxwell.sage` |
| **C4** | `Layer2/Lean/T2_3_EnergyMomentum.lean` | `Layer2/Sage/energy_momentum_tensor.sage` |
| **C5** | `Layer2/Lean/T2_4_ForceDensity.lean` | `Layer2/Sage/force_density.sage` |
| **C6** | `Layer2/Lean/T2_7_DiracFactorisation.lean` | `Layer2/Sage/dirac_algebra.sage` |
| **C7** | `Layer2/Lean/T2_7_PositivityRoute.lean` | — |
| **C8** | `Layer2/Lean/T2_8_DiracWithFields.lean` | `Layer2/Sage/dirac_with_fields.sage` |
| **C9** | — | `Layer2/Sage/geometry_dependent_uncertainty.sage` |
| **C10** | — | `Layer2/Sage/dirac_repn_and_moment_check.sage` |

## Layer 3 — Outputs: Potentials, Particles, Gravity, Predictions

| Code | Lean module(s) | Sage script(s) |
|------|----------------|----------------|
| **C1** | `Layer3/Lean/T2_10_London.lean` | `Layer3/Sage/gateway_london_quantisation.sage` |
| **C2** | — | `Layer3/Sage/T2_11_hypersurface_metric.sage` |
| **C3** | — | `Layer3/Sage/T2_14_schwarzschild_5D_sage.sage`<br>`Layer3/Sage/T2_14_schwarzschild_5D_sympy.sage` |
| **C4** | — | `Layer3/Sage/T2_12_viscous_stress.sage` |
| **C5** | — | `Layer3/Sage/T2_13_shock_viscosity.sage` |
| **C6** | `Layer3/Lean/T2_9_SpinStates.lean` | `Layer3/Sage/T2_9_spin_states.sage` |
| **C7** | — | `Layer3/Sage/T2_6_self_energy_sage.sage`<br>`Layer3/Sage/T2_6_self_energy_sympy.sage` |
| **C8** | — | `Layer3/Sage/T2_5_gauge_pressure.sage` |
| **C9** | — | `Layer3/Sage/T2_2_charge_conservation.sage` |
| **C10** | — | `Layer3/Sage/mass_sector_gauge_vs_curvature.sage` |
| **C11** | — | `Layer3/Sage/u4_rest_mass_nonconservation.sage` |
| **C12** | — | `Layer3/Sage/weak_field_poisson.sage` |
| **C13** | — | `Layer3/Sage/phat_photon_blackbody.sage` |

### Layer 3 — Book extensions (Appendix A.2, §7)

| §7 block | Sage script |
|----------|-------------|
| B-C1/C2 | `Layer3/Sage/nonsingular_force_3rdlaw.sage` |
| B-C2 | `Layer3/Sage/yangmills_field_structure.sage` |
| B-C1 | `Layer3/Sage/su3_three_body_structure.sage` |
| B-C3 | `Layer3/Sage/neutron_com_barrier_lifetime.sage` |
| B-C3 | `Layer3/Sage/virtual_mass_photon_LHC.sage` |
| B-C3 | `Layer3/Sage/lowZ_masses_vs_SEMF.sage` |
| B-C4 | `Layer3/Sage/P1_radiation_pressure_a0.sage` |
| B-C3 | `Layer3/Sage/nuclear_model_recovered.sage` |
| B-M1 | `Layer3/Sage/earth_magnetic_moment.sage` |
| B-M2 | `Layer3/Sage/force_ratio.sage` |
| B-M3 | `Layer3/Sage/perihelion_advance.sage` |
| B-M4 | `Layer3/Sage/dark_matter_rotation_curves.sage` |

### Layer 3 — Constants and provenance (exploratory)

Scripts that trace where the theory's two numerical constants come from. They are
assertion-driven and linted like the rest, but they establish provenance rather
than a `[Cn]` claim, so the Supplementary Material cites them by name.

| Script | What it settles |
|--------|-----------------|
| `Layer3/Sage/k_nuclide_anchor.sage` | anchors `k` on the nuclide chart and inverts it into `K_gamma` |
| `Layer3/Sage/v0_source_law.sage` | what sources `V_0`, from the 68d Bianchi component in statics |
| `Layer3/Sage/self_energy_assembly_factors.sage` | the assembly factors behind prediction P3 |
| `Layer3/Sage/mass_energy_conversion_ceiling.sage` | the `d(gamma)/dt <= a_0 c` ceiling on mass conversion |

### Layer 3 — Cosmology and further book-sourced checks

Book-sourced results outside the numbered `B-Cn`/`B-Mn` blocks: the secular
gravitational time-dependence and its consequences, plus structural checks on
waves, orbits and singularity removal. Discussed in the Supplementary Material by
name; several are negative or inconclusive results, recorded as such.

| Script | Subject |
|--------|---------|
| `Layer3/Sage/redshift_relation_dark_energy.sage` | DT redshift relation |
| `Layer3/Sage/dark_energy_standard_candle.sage` | the evolving Chandrasekhar candle |
| `Layer3/Sage/pantheon_dark_energy_fit.sage` | fit to the Pantheon binned SN-Ia sample |
| `Layer3/Sage/pantheon_systematic_covariance.sage` | the same fit under the published systematic covariance |
| `Layer3/Sage/dark_energy_residual.sage` | how close the fit gets |
| `Layer3/Sage/highz_residual_diagnostic.sage` | whether the two highest-z bins are calibration-limited |
| `Layer3/Sage/local_unit_of_action_cancellation.sage` | whether the variable unit of action can hide the drift locally |
| `Layer3/Sage/local_gdot_escape_candidates.sage` | candidate escapes from the local `Gdot/G` bound |
| `Layer3/Sage/G_variation_constraints.sage` | the imported `Gdot/G` constraints |
| `Layer3/Sage/density_screening_nogo.sage` | the density-screening escape, and why it fails |
| `Layer3/Sage/nonsingular_cosmology_cmb.sage` | non-singular cosmology and the CMB |
| `Layer3/Sage/nonsingular_black_holes.sage` | singularity removal in the mass sector |
| `Layer3/Sage/electrogravitic_wave_polarization.sage` | polarization of the 5D wave |
| `Layer3/Sage/nontransverse_pressure_rederivation.sage` | radiation pressure of the non-transverse mode, re-derived |
| `Layer3/Sage/quantized_orbits.sage` | the gravitational Bohr ladder |
| `Layer3/Sage/moon_system_quantisation.sage` | the same ladder applied to a satellite system |
| `Layer3/Sage/gap_vs_feeding_pattern.sage` | ladder gaps against planetary data |

## Cadabra cross-checks (independent second engine)

Abstract-index derivations in [Cadabra2](https://cadabra.science), valid in any
dimension (so 5D is a special case). Each is assertion-driven with a mutation
test; output in `Layer{N}/cadabra-results/`, checked by `linter.py`.

| Backs | Cadabra file | What it adds over the Sage script |
|-------|--------------|-----------------------------------|
| L1 **C9** | `Layer1/Cadabra/maxwell_variation.cdb` | the Maxwell field equation as the Euler-Lagrange equation of -1/4 F^2; gauge invariance of F = dA |
| L2 **C5** | `Layer2/Cadabra/force_density.cdb` | Div T = F.J as an identity plus Bianchi, for any dimension (Sage: explicit 5D components) |
| L2 **C8** | `Layer2/Cadabra/dirac_with_fields.cdb` | the Eq 116 -> 119 squaring step, sign of the -(i/2) F sigma coupling derived (Sage: prose only); Eq 117; 5D gamma contraction |

`Layer3/Sage/units_audit.sage` is a dimensional audit (sympy.physics.units) of
the mass-sector constants: a0, K_gamma, u4, k4, A0, the Eq 2.10 / 2.21
relations, and the two notation collisions (gauge a0 vs MOND a0; u4 vs u^4).

## Derivations added after the SI (no C-number yet)

| Topic | Script | Result |
|-------|--------|--------|
| GR on a 4D surface (Book Eqs 1.34-1.39 / 10.1-10.9) | `Layer3/Sage/gr_on_4d_surface.sage` | Gauss-Codazzi reduction 5D -> 4D on the mass hypersurface. u4 = 0 for all free motion <=> extrinsic curvature K = 0; then 5D Einstein-type equations restrict EXACTLY to 4D Einstein, with T_a4 = 0 and T_44 = (eps/2) T^a_a as constraints (dust: -rho c^2/2, as in C12). Williams identifies rather than derives this step; the script derives it under two stated conditions. K != 0 adds induced sources (Ricci-flat example with a cosmological term). |
| Einstein equations recovered on the surface (Book Eq 1.38 / 10.8) | `Layer3/Sage/einstein_equations_recovery.sage` | Makes Williams' identification G = C T exact. [1] u4 = 0 -> J^4 = 0 -> the surface source (matter + Maxwell + massless scalar A_4) is conserved; [2] restricted Lovelock: only a(R_ab - R g_ab/2) + Lambda g_ab is divergence-free; [3] Gauss-Bonnet is allowed in 5D but drops out of the 4D surface equations when K = 0 (survives only in the 44 constraint); [4] Newtonian limit: Psi = Phi derived, kappa = 8 pi G/c^4. Premises: local, second-order, metric-only field equations; Lovelock's theorem imported; Lambda open (DT would set 0). |
| Einstein equations from DT's own action (Report Eq 39 / 67) | `Layer3/Sage/einstein_from_dt_action.sage` | Supplies the premises the Lovelock step assumed. [1] Williams' constraint coefficients 6 (Eq 39, 4D) and 12 (Eq 67, 5D) are the Weyl-curvature coefficient (n-1)(n-2): R~ = R - 2(n-1) div phi - (n-1)(n-2) phi.phi; [2] metric variation of sqrt|g| R = -sqrt|g| G^ab (4D and 5D families, off-diagonal instance): the operator is local and second order, closing T1.9's 'EH variation cited, not derived'; [3] F^2 gives the Maxwell stress; the lambda term's cosmological part has the constraint as coefficient, so Lambda = 0 if lambda is a multiplier (corpus reading), Lambda = -lam/4 if a constant (Weyl 1918). Not derived from the three laws: the choice of R as Lagrangian (Weyl's procedure, adopted by Williams). |
| What lambda is in Eqs 39 / 67 (decides Lambda) | `Layer3/Sage/weyl_lambda_reading.sage` | On Weyl's procedure, which the Report invokes, lambda is a CONSTANT, not a Lagrange multiplier. [1] Gauge weights: R~ -> e^(-2s) R~, so sqrt|g| R~^p is invariant only for p = n/2 (R~^2 in 4D, R~^(5/2) in 5D); [2] natural gauge R~ = -lambda, first-order expansion of R~^2 reproduces Eq 39 exactly and Eq 67 (5D parent R~^(5/2) would give 3/5 not 1/2); [3] varying lambda as an auxiliary field gives R~ = -lambda (the gauge condition), not phi.phi = const -- the corpus multiplier reading (T1.9) is not Weyl's; [4] f'(0) = 0, so lambda != 0 and |Lambda| = lambda/4 != 0, magnitude unfixed; the same lambda sets a Proca-type mass for the gauge vector. Open: that mass scale (needs alpha) and the imaginary London gauge. |
| Gauge-vector mass in Eqs 39 / 67; Weyl structure drops out of GR | `Layer3/Sage/weyl_vector_mass.sage` | [1] R~ = -(n-1)(n-2) phi.phi for constant phi (geometric sign; flips for imaginary phi; R~ complex for non-constant imaginary phi); [2] dispersion Omega^2 = K^2 + 2k/alpha; [3] weak field G_00 = 2 lap Phi fixes G = +kappa T, so positive EM energy needs alpha > 0 (real phi), < 0 (imaginary); [4] London coupling q = e/hbar: m^2 = -k alpha_fs/(2 l_P^2), a Planck-mass TACHYON (0.15 / 0.21 M_P), independent of lambda -- the London phase cannot be the phi inside Eq 39/67, only the Weyl-1929 phase on matter; [5] the real integrable vector (Report Eq 65, F = 0) is forced to phi = 0 on shell, so the metric equations are exactly G + Lambda g = kappa T. |
| Joint fit: DT drift + Lambda on Pantheon | `Layer3/Sage/dt_lambda_joint_fit.sage` | Lambda enters DT's non-expanding cosmology via the static patch g_tt = 1 - Lambda r^2/3 composed with the log-z drift; xi >= 0 profiled exactly; full covariance. Drift and Lambda are DEGENERATE (valley xi ~ 0.23 + 1.5 L, L = Lambda c^2/6H0^2). Full cov leans to Lambda > 0, ~Planck size (Lambda=0: dchi2 6.9) but on the 2 calibration-limited high-z bins (dropped: 3.1); best fit at the ansatz edge. Fixed xi=0.229 => Lambda ~ 0; xi=0 => Lambda < 0; xi=1 (Gdot/G=H0) => Lambda ~1.6x Planck. So Lambda's size is tied to the drift rate (Gdot/G). Leading-order coupling only. |
| Williams Eq 39/67 vs Ghilencea's Weyl quadratic gravity | `Layer3/Sage/weyl_ghilencea_comparison.sage` | Term-by-term check that DT's GR step is the published gauge-fixed Weyl R~^2 result (Ghilencea, JHEP 03 (2019) 049; PRD 101 (2020) 045010): same R~ (k = 6/12, computed from the Weyl connection), dictionary phi = (q/2) omega, same linearisation (lambda = phi0^2; only p = 2 gives Williams' 1/2), same Lambda = lambda/4, same Weyl-vector mass m^2 = (3/2) q^2 M^2 (5D: 3 q^2 M^2), and DT's integrable phi = d ln f is the Stueckelberg mode gauged to Riemannian. Not checked: Ghilencea's C~^2 term (absent in Williams), Weyl-weighted matter, sign of Lambda in Williams' conventions. |
| Extra 5D fields: radion g_44 and KK vector g_a4 vs PPN gamma | `Layer3/Sage/kk_radion_g44.sage` | Linearised 5D Einstein tensor with free g_44 and g_04. With u4 = 0 dust (Eq 1.34: T^44 = T^a4 = 0) and g_44 DYNAMICAL the radion is sourced: Psi = Phi/2, Chi = -Phi/2, PPN gamma = 1/2 -- excluded by Cassini by ~2e4. u4 = 0 along worldlines does NOT fix g_44 (geodesic keeps dy/ds = 0 for any N(x)); a Lambda-induced radion mass has range ~1e26 m, no screening. With conservation of mass as a RESTRICTION (multiplier holding g_44 = -1; Williams writes only the surface Eqs 1.38): gamma = 1, Newton exact, beta = 1 via K = 0, and the multiplier is T_44 = -rho c^2/2, the mass-direction source found earlier. KK vector unsourced (T_04 = 0). Also shows weak_field_poisson branch B needs anisotropic stress. Cassini SELECTS the constraint reading; it does not derive it. |
| Test-body motion: Eq 62 vs 4D geodesics | `Layer3/Sage/test_body_motion.sage` | Eq 62 DERIVED as the Euler-Lagrange equation of delta Int gamma ds on a fully general 5D metric. Its u4 term is exactly the space-time-matter fifth force -(1/gamma)(dgamma/ds) u_mu (Mashhoon-Wesson-Liu), switched off by u4 = 0. On the K = 0 surface the 5D Christoffels reduce to 4D ones and f^mu is the 4D geodesic operator with no body parameter (weak EP); the d_mu gamma term integrates to zero over a compact body, so the centre of mass follows a 4D geodesic. But u4 = 0 is NOT preserved freely: on a path gamma = a0 q4 the mass equation drives du4/ds = -a0/gamma (~1e4 /m for Al), so conservation of mass is a RESTRICTION with a reaction -- the same one kk_radion_g44 needs. Not treated: strong EP/Nordtvedt, spin/tidal terms. |
| Gravitational radiation: modes, speed, power | `Layer3/Sage/gravitational_radiation.sage` | Linearised Riemann mode count: 4D = 2, free 5D = 5 (2 tensor + 2 KK vector + 1 g44 scalar, seen in 4D as a BREATHING polarisation). Under the same conservation-of-mass restriction as kk_radion_g44 / test_body_motion (h_A4 = 0) exactly GR's plus and cross survive, at c_gw = c (inside GW170817), with quadrupole power: Peters-Mathews Pbdot for PSR B1913+16 = -2.402e-12 vs -(2.398 +/- 0.004)e-12 observed. The missing vector/breathing modes are a third check of the restriction. Williams' gauge gravity with d_4 = 0 is a scalar gradient V_mu = d_mu phi_4 (EM sector decouples exactly; mixing ~ K_g gamma ~ 2e-31), so it carries no tensor waves; his "gravity wave does not exist by itself" (Against the Odds p.170) is SUPERSEDED by the metric sector (GW150914 has no EM partner). Linear theory; beyond-quadrupole reaction inherited from GR. |
| Black-hole ringdown: DT's strong-field fork | `Layer3/Sage/black_hole_ringdown.sage` | Ringdown is set by the LIGHT RING. GR reading of DT (vacuum surface equations, Birkhoff): Schwarzschild/Kerr, ring at 3M, Kerr f_220 ~ 250 Hz for GW150914 as observed. Williams' non-singular potential promoted to g_00: areal radius gives beta = 2 (perihelion 2/3 GR, excluded); isotropic gives beta = 1, departing from GR only at 2PN; three gamma = 1 closures kept. In ALL of them: no horizon (g_00 >= 1-2/e) and NO light ring (potential too shallow, |V| <= c^2/e) -> no Kerr ringdown, no EHT photon ring. It is also not a vacuum solution (G^t_t ~ -(lambda/r)^4: negative exterior energy density, closure B = 1/g_00, sign controlled). Ringdown + EHT select the GR reading: a strong NEGATIVE for nonsingular_black_holes.sage, not for DT. Static, non-rotating, eikonal; metric closure is ours. |
| Matter source T_ab (gap #4) | `Layer3/Sage/matter_source_tab.sage` | Williams' own T^ab (Book Eqs 1.34-1.37) checked as a GR source. (A) His constant 8 pi K/c^2 (Eq 1.39) gives Newton exactly. (B) The contracted Bianchi identity forces nabla T = 0; for dust its timelike part is the continuity residual, whose Newtonian form IS Williams' u^4 (Eq 1.36), and the rest is geodesic motion -- so conservation of mass is REQUIRED by DT's surface equations, not only chosen (the g_44 part stays Cassini-selected). (C) With u^4 = 0, T^{a4} = 0: no source for g_a4/g_44. (D) Eq 1.37 gives the standard EM energy but leaves a V trace term (1/4)(|V|^2 - V0^2); (E) at Newtonian strength (V = g/sqrt(4 pi G), Eq 10.19) it would give PPN beta = 9/8, excluded by ~1e3; (F) DT removes it: J^4 = sigma u^4 = 0 leaves phi_4 unsourced, V = 0, force = Lorentz, T = dust + Maxwell. (G) Maxwell is Weyl-invariant in 4D only. Scope: dust + EM (pressure is the standard extension); convective current and dust's Einstein-gauge Weyl coupling assumed; h^ab = 0 in (D). |
| Exact pp-wave lift (gap #3, nonlinear) | `Layer3/Sage/exact_ppwave_lift.sage` | Upgrades gravitational_radiation.sage from first order to EXACT in the wave sector. (A) GR's exact plane-fronted wave ds^2 = H du^2 + 2 du dv - dx^2 - dy^2 has only R_uu = (1/2) lap_perp H; plus/cross with arbitrary waveforms and amplitude is an exact vacuum solution with non-zero curvature. (B) Lifted to 5D with g_44 = -1 it stays an exact vacuum solution, 5D Ricci = 4D Ricci. (C) Gamma^4 = 0: u^4 = 0 is preserved exactly along test-body paths. (D) d_v is null and covariantly constant: exact speed c at any amplitude. (E) Tidal tensor traceless: plus/cross only, exactly. (F) The exact breathing wave C(u)(x^2+y^2-2w^2) exists ONLY with mass-coordinate dependence and carries a mass-axis tidal force -- the reading the restriction excludes. (G) Exact superposition of co-moving waves. Scope: exact plane waves, not mergers (those are inherited via gr_on_4d_surface). |
| Domain of the GR limit (gap #5) | `Layer3/Sage/gr_limit_domain.sage` | Williams' weak-field mass sector (Eqs 3.24-3.27) is Newton x (1 - lambda/r) x (1 - H0 tau); lambda/r is settled by the metric reading (black_hole_ringdown). (A) tau0dot = 0 gives Newton/GR exactly (residual ~1e-24/century). (B) ONE DIAL: the Eq 3.30 rotation-curve anomaly kappa = H0 tau0dot/c equals |d ln G_eff/dt|/c -- the spatial anomaly IS the secular drift read across r/c. (C) a = a_N(1 + kappa r) precesses by -pi kappa r per orbit (apsidal formula + numerical orbit). (D) Flat curves need tau0dot = c/(r_c H0) ~ 5e5 for the Milky Way: its gravity must change by O(1) every r_c/c ~ 3e4 yr, and |H0 tau| ~ r/r_c > 1 on the flat part (outside the linearisation). (E) Eq 3.33 drops v^2/c^2 = lambda/r0, the term it keeps; corrected tau0dot^2 = 2E0/(m c^2), a free initial condition (galaxy: ~1e11 rest energies). (F) Universal-a0 reading for the Sun: Mercury +1.5e4"/cy, EXCLUDED; Mercury bounds tau0dot_sun < 1.4e4, LLR < 1.4e-3 (imported bound). VERDICT: GR limit exact at tau0dot -> 0; internal-consistency FLAG on the Ch. 3 dark-matter postdiction (not a falsification; defeater: Williams' "two times" bookkeeping). (H) No compromise: v_flat^2 x T_fade = GM/c for every tau0dot; the natural reading (Eq 3.19, tau0dot = 1) gives the Milky Way ~0.25 km/s; the shortfall falls as M^-1/2 (~1e7 dwarfs, ~5e5 MW, ~4e3 clusters) and closes only near the Hubble-radius mass; fixed tau0dot gives v^2 ~ M, so Tully-Fisher needs the per-system tuning. |
| Hydrogen with the non-singular potential (QM sector) | `Layer3/Sage/hydrogen_nonsingular_spectrum.sage` | Report: London condition -> Bohr hydrogen, pure Coulomb. Book Ch. 9 (Eqs 9.2, 9.16, 9.19, p.241): e^{-lambda/r}/r has a LONG-RANGE 1/r^2 tail, s(s+1)=l(l+1)+lambda, Delta E = Lt/(n^3(2l+1)) -- a Lamb-type shift by a non-QED route. (A,B) Williams algebra re-derived exactly; the tail depends on which particle is body 1 (V_c odd under relabelling). (C) Eq 9.19 2e-5 puts 1 fm on the ELECTRON, inconsistent with lambda_e=1e-3 fm. (D) Williams lambda values: R1 0.009x Lamb, R2 39x, R3 20x. (E) REPLACES (no QED): l-pattern wrong for any Lambda; fit Lamb + 1S-2S, 2S-4P misses by 521 MHz vs 2.3 kHz. (F) SUPPLEMENTS: |Lambda| < 1e-6 fm; all Williams readings excluded >100x; mass-scaled lambda survives eH. (G) muonic H excludes mass-scaled and lepton-universal lambda_mu. VERDICT: NEGATIVE CANDIDATE, not a falsification (defeaters: lambda only assumed, V_c labelling unsettled, lambda may run with separation). |

> Figure generators are named `plot_*.sage` (`plot_dark_energy_hubble.sage`,
> `plot_planetary_orbits.sage`). They emit PNGs into `sage-results/` and are
> skipped by the linter.

> `Layer3/Lean/NSM_SU3_Circulant.lean` — the Nonstandard-Model SU(3) circulant
> proof (charge sector, §7). Cited in prose as `NSM_SU3_circulant`; it has no
> separate `[Cn]` code but is part of the verified Lean library (included in the
> `lake build` and the AxiomCheck footprint).
