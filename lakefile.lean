import Lake
open Lake DSL

package «Dynamic_Theory» where

require mathlib from git "https://github.com/leanprover-community/mathlib4" @ "v4.34.1"

-- Physlib (formerly PhysLean/HepLean): theoretical-physics library on the same Mathlib pin.
require physlib from git "https://github.com/leanprover-community/physlib" @ "53dfa9d61ceac38fac97fdc9c45cf65cfa8c5fc4"

@[default_target]
lean_lib DynamicTheory where
  -- Root aggregator + shared Basic, plus every .lean under Layer{1,2,3}/.
  -- `.submodules` globs the directory recursively WITHOUT requiring a
  -- `Layer1.lean` base file (which does not exist).
  globs := #[
    .one `DynamicTheory,
    .one `Basic,
    .one `PhyslibCompat,
    .submodules `Layer1,
    .submodules `Layer2,
    .submodules `Layer3
  ]
