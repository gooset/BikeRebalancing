import math
from typing import List
from .utils import distance, create_initial_solution


def simulated_annealing(points: List[List[float]], initial_temp: float, cooling_rate: float, max_iter: int):
    """Performs simulated annealing to find a near-optimal solution."""
    current_solution = create_initial_solution(len(points))
    current_distance = calculate_total_distance(current_solution, points)

    best_solution = current_solution[:]
    best_distance = current_distance

    temperature = initial_temp

    for iteration in range(max_iter):
        for _ in range(len(points)):  # Create a neighbor
            new_solution = current_solution[:]
            i, j = random.sample(range(len(points)), 2)
            new_solution[i], new_solution[j] = new_solution[j], new_solution[i]

            new_distance = calculate_total_distance(new_solution, points)
            acceptance_probability = calculate_acceptance_probability(current_distance, new_distance, temperature)

            if new_distance < current_distance or random.random() < acceptance_probability:
                current_solution, current_distance = new_solution, new_distance

            if current_distance < best_distance:
                best_solution, best_distance = current_solution[:], current_distance

        temperature *= cooling_rate  # Cool down

    return best_solution, best_distance


def calculate_total_distance(solution: List[int], points: List[List[float]]) -> float:
    """Calculates the total distance of the given solution."""
    total_distance = 0.0
    for i in range(len(solution) - 1):
        total_distance += distance(points[solution[i]], points[solution[i + 1]])
    total_distance += distance(points[solution[-1]], points[solution[0]])  # Returning to start
    return total_distance


def calculate_acceptance_probability(current_distance: float, new_distance: float, temperature: float) -> float:
    """Calculates the acceptance probability for the new solution."""
    if new_distance < current_distance:
        return 1.0
    return math.exp((current_distance - new_distance) / temperature)
