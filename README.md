# Bike Rebalancing Algorithms

This repository contains algorithms implemented in Julia to address the bike rebalancing problem. The bike rebalancing problem refers to the challenge of redistributing bicycles across a bike-sharing network to ensure the availability of bikes at all stations while minimizing operational costs.

## Algorithms

The repository includes the following algorithms:

1. **Heuristic Algorithm:** This algorithm employs a heuristic approach to tackle the bike rebalancing problem. It focuses on finding reasonably good solutions in a timely manner, though it may not guarantee an optimal solution.

2. **Branch and Bound Implementation:** This algorithm utilizes the branch and bound technique to solve the bike rebalancing problem. It explores the solution space by iteratively partitioning it into smaller subproblems and bounding the search using lower and upper bounds to ultimately find an optimal solution.

3. **Simulated Annealing Metaheuristic Implementation:** This algorithm leverages the simulated annealing metaheuristic to address the bike rebalancing problem. Simulated annealing mimics the annealing process in metallurgy to efficiently explore the solution space and find near-optimal solutions.

## Folder Structure

The repository is organized as follows:

- `heuristic_algorithm/`: Contains the implementation of the heuristic algorithm in Julia.
- `branch_and_bound_implementation/`: Includes the implementation of the branch and bound algorithm in Julia.
- `simulated_annealing_metaheuristic/`: Contains the implementation of the simulated annealing metaheuristic in Julia.

## Usage

To use the algorithms in your project, follow these steps:

1. Clone this repository to your local machine using the following command:

