> **Note on authorship.** This file, and much of the verification code in this
> repository, was written with the assistance of AI coding tools (Claude Code and
> Codex). That is disclosed rather than hidden because it does not affect what the
> results establish: every Sage script is assertion-driven, so a failed identity
> aborts the run, and every Lean proof is certified by the compiler. The results
> stand or fall on re-execution, not on who or what typed them. See
> **Build & verify** below for the commands and the expected output.

# Dynamic-Theory — CLAUDE.md

Machine-verification corpus for Pharis E. Williams' **Dynamic Theory** (DT).
Equations and derivations are transcribed from the report *The Dynamic Theory: A
New View of Space, Time, and Matter* (LA-8370-MS, LASL, 1980) and independently
verified. Two verification layers, **Lean 4 / Mathlib** proofs and **SageMath /
SymPy** scripts, organised by the three-layer reading of Williams' Chapter-1 flow
chart.

This is a **buildable Lake project** and a results archive. Read this file first.

## Layout

```
DynamicTheory.lean   library root (imports every layer module)
Basic.lean           shared Lean support
AxiomCheck.lean      Lean axiom-footprint audit   -> AxiomCheck.out.txt
linter.py            Sage + Cadabra linter        -> linter.out.txt
lakefile.lean  lean-toolchain  lake-manifest.json
Layer{1,2,3}/
  Lean/            *.lean   -> modules  Layer{N}.Lean.*
  lean-results/    one .out.txt per module ("(no diagnostics - compiled clean)")
  Sage/            *.sage   (+ data files; figure scripts are plot_*.sage)
  sage-results/    captured stdout per script (+ .png figures)
INDEX.md             per-layer index of every module and script
```

- **Layer 1** Foundations (three laws, integrating factor, stability metric,
  Weyl geometry, Lorentzian signature). **Layer 2** Routes (5D geometry, field
  equations, spinor sector). **Layer 3** Outputs (potentials, particles,
  gravity, predictions).
- Files are **un-numbered**: reading order is not encoded in filenames.

## Build & verify

Run Lean with the repo toolchain (elan): `export PATH="$HOME/.elan/bin:$PATH"`.

```sh
lake exe cache get     # REQUIRED first - fetch prebuilt Mathlib oleans.
                       # Without it, lake rebuilds Mathlib from source (hours).
lake build             # builds the DynamicTheory library. Success = all proofs check.
lake env lean AxiomCheck.lean   # axiom audit
python3 linter.py               # Sage convention linter (pure Python)
```

| command | expected |
|---|---|
| `lake build` | succeeds, no `sorry` |
| `lake env lean AxiomCheck.lean` | 300 declarations, 0 `sorry`, exactly `propext`, `Classical.choice`, `Quot.sound` (Lean's standard axioms, not assumptions of the theory) |
| `python3 linter.py` | 168 OK / 0 WARN / 0 FAIL (incl. 3 Cadabra cross-checks in `Layer{1,2}/Cadabra/`; rerun with `cadabra2 X.cdb > ../cadabra-results/X.out.txt`) |

Versions: lean4 `v4.34.1`, Mathlib `v4.34.1` (rev
`d13f23b723b8a846827a245b89c10fc7d3f11612`), Physlib rev `53dfa9d`, SageMath 10.9. Everything else is
pinned in `lake-manifest.json`. The ~9 GB `.lake/` is git-ignored. `PhyslibCompat.lean` (default target)
checks that Physlib and the DT layer coexist. `Layer2/Lean/PhyslibBridge.lean`
proves DT's 5D metric = Physlib `minkowskiMatrix` (d=4) and that Physlib's Dirac
gammas (γ⁰..γ³, iγ⁵) realise DT's 5D Dirac ansatz (+31 decls → 300).
Pre-bridge 269 vs the earlier 273: the 4
auto-generated `deriving Fintype` helpers no longer exist under v4.34.1.

## Lake / Lean constraints (load-bearing - do not break)

- A Lean module name **= its file path**, and each component must be a valid
  identifier: letters/digits/underscores, **no hyphens, no leading digit**. Hence
  `Layer{N}/Lean/` -> modules `Layer{N}.Lean.*`. A folder like `lean-code` or
  `01_layer_1` would not build. (`sage-results`, `lean-results`, `Sage` are fine;
  only `.lean` directories are module paths.)
- `Lean` here is always a qualified component (`Layer1.Lean....`), so it does not
  clash with the toolchain's reserved top-level `Lean` namespace.
- The library globs the layer trees in `lakefile.lean`, using `.submodules`, which
  excludes the non-existent `Layer{N}` base module. Do **not** use
  `.andSubmodules` or the TOML `"Layer1.*"` form: they try to include a base
  `Layer1.lean` that does not exist and fail with "some modules have bad imports".
- Internal **namespaces are `DTWilliams.*`** (e.g.
  `namespace DTWilliams.IntegratingFactor`), independent of file path. AxiomCheck
  audits the `DTWilliams` prefix, so moving a file changes `import` lines only.

## Adding a module

- **Lean:** put `Foo.lean` in `Layer{N}/Lean/` (module `Layer{N}.Lean.Foo`), add
  `import Layer{N}.Lean.Foo` to `DynamicTheory.lean` and to `AxiomCheck.lean`,
  keep its `namespace DTWilliams.*`, `lake build`, re-run AxiomCheck, and add a
  matching `lean-results/Foo.out.txt`.
- **Sage:** put `foo.sage` in `Layer{N}/Sage/`, rely on stdout capture (no
  self-managed output path; the linter flags `os.makedirs` and `Tee`), put its
  captured run in `sage-results/foo.out.txt`, and run `python3 linter.py`.
  Figure generators are named `plot_*.sage`, are skipped by the linter, and emit
  PNGs.
- Update `INDEX.md` in the same change.

## Provenance

Every module and script carries a `SOURCE (primary)` header citing LA-8370-MS.
The later books, *The Dynamic Theory: A New View of Space-Time-Matter* (2011) and
*Physics - Against the Odds*, are cited only where the report is insufficient;
the reversed Eq-68d gauge sign follows Williams' acknowledgement of the reversal
found by Dr. Dan Ross. Headers also point into the accompanying Supplementary
Material by section and code id (`[Cn]`), which is published with the manuscript
rather than in this repository. Preserve these headers.
