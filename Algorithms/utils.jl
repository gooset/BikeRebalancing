using Random

struct Station
    i::Int # indice of a station
    x::Int # x coordinate of the station
    y::Int # y coordinate of the station
    nbp::Int # number of bike present in the station
    capa::Int # station capacity
    ideal::Int # the ideal bike in the station
end

function parse_file(filename::String)
"""
    Function to get the input from a file. It takes the path \
    of the file as an input and save the capacity K of the trailer, \
    the coordinate of the warehouse and the datas of station in an array
    of Station
    """

    sts = Station[]
    f = open(filename, "r")
    k=0; ware=(0,0)
    for l in readlines(f, keep=true)
        if startswith(l, "K")
            k = parse(Int, split(l)[2])
        elseif startswith(l, r"stations|name|#")
            continue 
        elseif startswith(l, "warehouse")
            c = split(l, " ")
            wx, wy = parse(Int, c[2]), parse(Int, c[3])
            ware = (wx, wy)
        else
            tab = split(l, " ")
            i = parse(Int, tab[1])
            x = parse(Int, tab[2])
            y = parse(Int, tab[3])
            nbp = parse(Int, tab[4])
            capa = parse(Int, tab[5])
            ideal = parse(Int, tab[6])
            push!(sts, Station(i, x, y, nbp, capa, ideal))
        end
    end
    return length(sts), sts, ware, k
end


n, sts, ware, K = parse_file("/home/user/instances/tsdp_9_s500_k14.dat")

function dists_to_ware(ware::Tuple{Int, Int}, sts::Vector{Station})
    """ 
    Get the distance to the warehouse for all stations 
    """
    [round(sqrt((s.x - ware[1])^2 + (s.y - ware[2])^2)) for s in sts]
end


function dist_stations(sts::Vector{Station})
    """
    Get the distance between each pair of stations
    """
    n = length(sts)
    d = [round(sqrt((s1.x - s2.x)^2 + (s1.y - s2.y)^2)) for s1 in sts, s2 in sts]
    reshape(d, n, n)
end


function get_imbs(sts::Vector{Station})
    """
    Get imbalances of each station
    """
    [s.nbp - s.ideal for s in sts]
end


function get_cost(path::Vector{Int}, dists::Matrix{Float64}, dware::Vector{Float64}, imbs::Vector{Int})
    """
    Determine costs for each route
    The cost is calculated by adding the cost of the distance traveled
    plus the absolute value of all imbalances, multiplied by a weight
    """
    n = length(path)
    w = 10000
    cost_dist = dware[path[1]] + dware[path[n]]
    for i in 2:n
        cost_dist += dists[path[i], path[i - 1]]
    end
    return w * sum(abs.(imbs)) + cost_dist
end


function shuffle_path(path::Vector{Int}, ni::Int)
    """
    This function takes a path and generates a new path.
    It copies the path without changing it and returns the new path.

    Args:
    - path: A vector representing the original path.
    - ni: An integer representing the number of elements to shuffle.

    Returns:
    - A new path with elements shuffled within the specified range.

    Example:
    path = [1, 2, 3, 4, 5]
    new_path = shuffle_path(path, 2)
    # Possible output: [1, 3, 2, 4, 5]
    """

    # Copy the original path to avoid modifying it directly
    new_path = copy(path)

    # Generate random indices for shuffling
    ids_shuffle = shuffle(1:length(new_path))

    # Split the indices into two halves
    l, r = ids_shuffle[1:ni], ids_shuffle[ni + 1 : ni + ni]

    # Shuffle the elements within the specified range
    for (i, j) in zip(l, r)
        new_path[i], new_path[j] = new_path[j], new_path[i]
    end

    # Return the shuffled path
    return new_path
end


