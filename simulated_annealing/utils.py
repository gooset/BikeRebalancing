import math
import random
from typing import List

def distance(x: List[float], y: List[float]) -> float:
    """Calculates the Euclidean distance between two points."""
    return math.sqrt(sum((a - b) ** 2 for a, b in zip(x, y)))

def create_initial_solution(num_points: int) -> List[int]:
    """Generates a random initial solution."""
    solution = list(range(num_points))
    random.shuffle(solution)
    return solution
