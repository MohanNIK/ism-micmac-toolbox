# ism-micmac-toolbox

`ism-micmac-toolbox` is a lightweight MATLAB/Octave-oriented toolbox for influence-structure modeling experiments. It packages a small adjacency-matrix example plus two scripts that were used in related methodology work.

## Included Files

- `tianISM.m`: reachability-matrix and level-partition workflow
- `RFginioob.m`: companion script from the same local code archive
- `adjacency_matrix.xlsx`: example input matrix
- `examples/adjacency_matrix_example.xlsx`: duplicated example input for quick experiments
- `smoke_test.py`: offline shape check for the example matrix

## Quick Start

1. Open `adjacency_matrix.xlsx` in MATLAB or Octave.
2. Place `tianISM.m` in the current working directory.
3. Run:

```matlab
tianISM
```

## Notes

- This repo is intentionally small and method-focused.
- The Python smoke test does not execute MATLAB code; it only verifies that the example matrix is square and readable.
