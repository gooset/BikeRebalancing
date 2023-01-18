# Bike Rebalancing Algorithms

This repository contains algorithms implemented in Julia to address the bike rebalancing problem. The bike rebalancing problem refers to the challenge of redistributing bicycles across a bike-sharing network to ensure the availability of bikes at all stations while minimizing operational costs.

## Algorithms

The repository includes the following algorithms:

1. **Heuristic Algorithm:** This algorithm employs a heuristic approach to tackle the bike rebalancing problem. It focuses on finding reasonably good solutions in a timely manner, though it may not guarantee an optimal solution.

2. **Branch and Bound Implementation:** This algorithm utilizes the branch and bound technique to solve the bike rebalancing problem. It explores the solution space by iteratively partitioning it into smaller subproblems and bounding the search using lower and upper bounds to ultimately find an optimal solution.

3. **Simulated Annealing Metaheuristic Implementation:** This algorithm leverages the simulated annealing metaheuristic to address the bike rebalancing problem. Simulated annealing mimics the annealing process in metallurgy to efficiently explore the solution space and find near-optimal solutions.

# Repository Structure

The repository is organized as follows:

- `Algorithms/simulated_annealing.jl/`: Contains the implementation of the simulated annealing metaheuristic in Julia.
- `Algorithms/branch-and-bound.jl`: Includes the implementation of the branch and bound algorithm in Julia.

## Usage

To use the algorithms in your project, follow these steps:

1. Clone this repository to your local machine using the following command:
git clone https://github.com/gooset/BikeRebalancing.git


2. Navigate to the cloned repository:

cd BikeRebalancing


3. Execute the desired algorithm by running the corresponding script file along with the path to the problem instance file. For example, to execute the simulated annealing algorithm on the `tsdp_9_s500_k14.dat` instance file located at `/home/user/instances`, use the following command:

julia Algorithms/simulated_annealing.jl instances/tsdp_9_s500_k14.dat


Modify the path and filename as per your specific instance file.

Note: Make sure you have Julia installed on your machine before executing the script.

4. The algorithm will process the instance file and provide the output or results based on the specific algorithm's logic.

Feel free to explore and modify the algorithm implementations according to your requirements.

