# Bike Rebalancing Optimization Project

This project tackles the **bike rebalancing problem**: ensuring bikes are optimally distributed across stations in a bike-sharing network, balancing availability with minimized operational costs.

Two methods are implemented in **both Julia and Python**:
1. **Simulated Annealing** - A heuristic approach to explore solutions iteratively.
2. **Branch and Bound** - An optimization approach to find an exact solution.

## Setup

1. **Python**: Install dependencies:
   ```bash
   pip install -r requirements.txt

2. **Julia**: Ensure required Julia packages are installed.

## Usage

1. **Python**:
        Run the Simulated Annealing algorithm:

    ```bash

python simulated_annealing/main.py instances/example_data.dat

Run the Branch and Bound algorithm:

```bash

    python branch_and_bound/main.py instances/example_data.dat

    Julia: Run each .jl file directly with an instance path.

## Data

All data files are stored in the instances folder for consistency.