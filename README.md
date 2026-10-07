# Dynamic Theory — machine-verified supplementary code

Machine-verification code and results for Pharis E. Williams' **Dynamic Theory**
(DT). Key equations and derivations were transcribed from the report *The
Dynamic Theory: A New View of Space, Time, and Matter* (LA-8370-MS, LASL, 1980)
into Lean and Sage and independently verified here; the later book is consulted
only as a secondary reference. Organised by the three-layer reading of Williams'
Chapter-1 flow chart:

- **Layer 1** — Foundations of the space–time–matter geometry (the three laws,
  integrating factor, stability metric, Weyl geometry, Lorentzian signature).
- **Layer 2** — The routes: 5D geometry, field equations, spinor sector.
- **Layer 3** — Outputs: potentials, particles, gravity, predictions.

Each layer holds both verification languages side by side:

```
Layer1/
  Lean/            Lean 4 / Mathlib proof modules   (modules Layer1.Lean.*)
  lean-results/    one .out.txt per module ("compiled clean" — see below)
  Sage/            SageMath / SymPy scripts + any data files
  sage-results/    captured stdout per script (+ generated figures)
Layer2/  ... (same shape)
Layer3/  ... (same shape)
```

Repo-root files:

```
lakefile.lean  lean-toolchain  lake-manifest.json   Lake project config
DynamicTheory.lean                                  library root (imports all layers)
Basic.lean                                          shared support
AxiomCheck.lean   AxiomCheck.out.txt                Lean axiom-footprint audit + its output
linter.py         linter.out.txt                    Sage + Cadabra linter + its output
```

## Lean — build & verify

```sh
lake exe cache get   # fetch the prebuilt Mathlib oleans
lake build           # compiles every proof module (success ⇒ all proofs check)
```

Toolchain `leanprover/lean4:v4.34.1` (pinned in `lean-toolchain`); Mathlib
`v4.34.1` and [Physlib](https://github.com/leanprover-community/physlib)
(formerly PhysLean) revisions pinned in `lake-manifest.json`. The build is clean — **0 `sorry`**.

A Lean *proof* module emits no stdout on success — it either compiles (proof
verified) or it does not. So each `lean-results/*.out.txt` is simply a
`(no diagnostics — compiled clean)` marker; the substantive Lean artifacts are
the build above and the axiom audit below.

### Axiom audit

```sh
lake env lean AxiomCheck.lean        # writes/compares the footprint
```

Runs `collectAxioms` over every `def`/`theorem` under the `DTWilliams` namespace
and flags any `sorryAx` or any axiom outside Lean's three standard axioms.
Current footprint (see `AxiomCheck.out.txt`): **300 declarations, 0 sorry,
{propext, Classical.choice, Quot.sound} only — PASS**.

## Sage — run & lint

Run any script with SageMath (output is captured to the layer's `sage-results/`):

```sh
sage Layer1/Sage/T1_1-3_integrating_factor.sage
```

Lint the whole Sage corpus (pure Python, no Sage needed):

```sh
python3 linter.py
```

Checks signature conventions, the corrected Dirac/Clifford and self-energy
forms, hard-coded-verdict anti-patterns, Sage-API regressions, the
stdout-capture output convention, and that each script's result is
traceback/Error/FAIL-free; it also checks the Cadabra cross-checks in
`Layer{N}/Cadabra/` (run with `cadabra2 file.cdb > ../cadabra-results/file.out.txt`).
Current state (see `linter.out.txt`): **175 OK, 0 WARN, 0 FAIL — CLEAN**. Figure-generator scripts (`plot_*.sage`)
emit PNGs into `sage-results/` and are skipped by the linter.

## Provenance

Every module/script carries a `SOURCE (primary)` header citing LA-8370-MS; the
later book (*The Dynamic Theory: A New View of Space-Time-Matter*, 2011) is
cited only where the report is insufficient.
