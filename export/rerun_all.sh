#!/usr/bin/env bash
# Re-run every Sage script in a generated restricted repo and the linter.
# Usage: export/rerun_all.sh [TARGET]   (default ~/lean/Dynamic-Theory-GR-SM)
# Proves the export is self-contained: no script reaches outside TARGET.
set -u
TGT="${1:-$HOME/lean/Dynamic-Theory-GR-SM}"
SAGE=/home/dsteele/miniconda3/envs/sage/bin/sage
fail=0
for L in Layer1 Layer2 Layer3; do
  cd "$TGT/$L" || exit 1
  for s in Sage/*.sage; do
    n=$(basename "$s" .sage)
    if ! "$SAGE" "$s" > "sage-results/$n.out.txt" 2>&1; then
      echo "FAIL $L/$s"; fail=1
    fi
  done
done
cd "$TGT" && python3 linter.py > /dev/null; tail -4 linter.out.txt
exit $fail
