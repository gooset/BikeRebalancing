def parse_file(filename: str):
    """Parses data from a file and returns parameters and station data."""
    trailer_capacity, warehouse = 0, (0, 0)
    x, y, nbp, capacity, ideal = [], [], [], [], []

    with open(filename, "r") as f:
        for line in f:
            if line.startswith("K"):
                trailer_capacity = int(line.split()[1])
            elif line.startswith("warehouse"):
                parts = line.split()
                warehouse = (int(parts[2]), int(parts[3]))
            elif not any(line.startswith(prefix) for prefix in ["stations", "name", "#"]):
                data = line.split()
                x.append(int(data[2]))
                y.append(int(data[3]))
                nbp.append(int(data[4]))
                capacity.append(int(data[5]))
                ideal.append(int(data[6]))

    return len(x), trailer_capacity, warehouse, x, y, nbp, capacity, ideal


def calculate_distances(warehouse, x, y):
    """Calculates distances from each station to the warehouse and between stations."""
    n = len(x)
    dist_to_warehouse = [
        round(((x[i] - warehouse[0]) ** 2 + (y[i] - warehouse[1]) ** 2) ** 0.5)
        for i in range(n)
    ]
    dist_between_stations = [
        [round(((x[i] - x[j]) ** 2 + (y[i] - y[j]) ** 2) ** 0.5) if i != j else 0 for j in range(n)]
        for i in range(n)
    ]
    return dist_to_warehouse, dist_between_stations
