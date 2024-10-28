import sys
import os
import time
from .annealing import simulated_annealing
from .config import INSTANCES_DIR, DEFAULT_INSTANCE_FILE

def load_data(file_path):
    """Loads point data from a file in the instances directory."""
    points = []
    with open(os.path.join(INSTANCES_DIR, file_path), 'r') as f:
        for line in f:
            points.append(list(map(float, line.strip().split())))
    return points

def main(file_name=DEFAULT_INSTANCE_FILE):
    points = load_data(file_name)

    start_time = time.time()
    best_solution, best_distance = simulated_annealing(points)
    end_time = time.time()

    print(f"Best solution: {best_solution}")
    print(f"Best distance: {best_distance}")
    print(f"Time taken: {end_time - start_time:.2f} seconds")

if __name__ == "__main__":
    file_name = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_INSTANCE_FILE
    main(file_name)
