import Lake
open Lake DSL

package «Dynamic_Theory» where

require mathlib from git "https://github.com/leanprover-community/mathlib4"

@[default_target]
lean_lib DynamicTheory where
  -- Root aggregator + shared Basic, plus every .lean under Layer{1,2,3}/.
  -- `.submodules` globs the directory recursively WITHOUT requiring a
  -- `Layer1.lean` base file (which does not exist).
  globs := #[
    .one `DynamicTheory,
    .one `Basic,
    .submodules `Layer1,
    .submodules `Layer2,
    .submodules `Layer3
  ]
