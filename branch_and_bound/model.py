import pulp as pl

def setup_model(n, K, dist_to_warehouse, dist_between_stations, nbp, capacity, ideal):
    """Sets up the branch-and-bound optimization problem using PuLP."""
    model = pl.LpProblem("Bike_Rebalancing", pl.LpMinimize)

    # Decision variables
    x = pl.LpVariable.dicts("x", ((i, j) for i in range(n) for j in range(n)), cat="Binary")
    load = pl.LpVariable.dicts("load", range(n + 1), lowBound=0, upBound=K)
    drop = pl.LpVariable.dicts("drop", ((i, j) for i in range(n) for j in range(n)))
    imbalance = pl.LpVariable.dicts("imbalance", range(n), lowBound=0)
    y = pl.LpVariable.dicts("y", ((i, j, k) for i in range(n) for j in range(n - 1) for k in range(n)), lowBound=0)

    # Objective function
    model += (
        1000 * pl.lpSum(imbalance[i] for i in range(n))
        + pl.lpSum(dist_to_warehouse[i] * x[i, 0] for i in range(n))
        + pl.lpSum(dist_between_stations[i][k] * y[i, j, k] for i in range(n) for j in range(n - 1) for k in range(n))
        + pl.lpSum(dist_to_warehouse[i] * x[i, n - 1] for i in range(n))
    )

    # Constraints
    for i in range(n):
        model += pl.lpSum(x[i, j] for j in range(n)) == 1, f"UniqueSelection{i}"
        model += pl.lpSum(x[j, i] for j in range(n)) == 1, f"UniqueVisit{i}"

    for j in range(1, n):
        model += load[j] == load[j - 1] - pl.lpSum(drop[i, j] for i in range(n)), f"LoadUpdate{j}"
        model += load[j] <= K, f"MaxLoad{j}"

    for i in range(n):
        for j in range(n):
            model += drop[i, j] <= (capacity[i] - nbp[i]) * x[i, j], f"CapacityDrop{i}_{j}"
            model += -nbp[i] * x[i, j] <= drop[i, j], f"NonBacklog{i}_{j}"

    for i in range(n):
        model += imbalance[i] >= nbp[i] + pl.lpSum(drop[i, j] for j in range(n)) - ideal[i], f"Imbalance1{i}"
        model += imbalance[i] >= -nbp[i] - pl.lpSum(drop[i, j] for j in range(n)) + ideal[i], f"Imbalance2{i}"

    for i in range(n):
        for j in range(n - 1):
            for k in range(n):
                model += y[i, j, k] >= x[i, j] + x[k, j + 1] - 1, f"FlowConservation{i}_{j}_{k}"

    return model
