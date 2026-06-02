from pathlib import Path

import pandas as pd


def main() -> None:
    path = Path("adjacency_matrix.xlsx")
    df = pd.read_excel(path, header=None)
    assert df.shape[0] == df.shape[1], "Adjacency matrix must be square"
    print(f"ism-micmac-toolbox smoke test passed ({df.shape[0]}x{df.shape[1]})")


if __name__ == "__main__":
    main()
