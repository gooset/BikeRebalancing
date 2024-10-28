import sys
import os
import time
from .utils import parse_file, calculate_distances
from .model import setup_model
from .config import INSTANCES_DIR, DEFAULT_INSTANCE_FILE
import pulp as pl

def display_results(model, elapsed_time, n):
    """Displays results of the solved optimization problem."""
    if pl.LpStatus[model.status] == "Optimal":
        print(f"The optimal objective value is: {pl.value(model.objective):.2f}")
        print(f"Obtained in {elapsed_time:.2f} seconds")

        print("\nSelected Stations:")
        for i in range(n):
            for j in range(n):
                if pl.value(model.variablesDict()[f"x_{i}_{j}"]) > 0.99:
                    print(f"Station {i} is selected at step {j}")
    else:
        print("The problem has not been solved to the optimum")

def main(file_name=DEFAULT_INSTANCE_FILE):
    file_path = os.path.join(INSTANCES_DIR, file_name)
    n, K, warehouse, x, y, nbp, capacity, ideal = parse_file(file_path)
    dist_to_warehouse, dist_between_stations = calculate_distances(warehouse, x, y)

    start_time = time.time()
    model = setup_model(n, K, dist_to_warehouse, dist_between_stations, nbp, capacity, ideal)
    model.solve(pl.PULP_CBC_CMD(msg=False))
    elapsed_time = time.time() - start_time

    display_results(model, elapsed_time, n)

if __name__ == "__main__":
    file_name = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_INSTANCE_FILE
    main(file_name)
