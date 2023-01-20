include("utils.jl")


function generate_path(path::Vector{Int}, org_imbs::Vector{Int}, K::Int)
    """
    Function to generate the best possible drop-off and pick-up for a path.
    """
    imbs, p = copy(org_imbs), copy(path)
    n = length(path)
    s = p[1]
    k = imbs[s] <= 0 ? rand(min(abs(imbs[s]), K)) : rand(0:(K - min(imbs[s], K)))
    load = k
    for i in 1:n
        s = p[i]
        if imbs[s] < 0 && k > 0
            dp_max = min(abs(imbs[s]), k)
            dp = dp_max
            imbs[s] += dp
            k -= dp
        elseif imbs[s] > 0 && k < K
            pk_max = min(imbs[s], K - k)
            pk = pk_max
            imbs[s] -= pk
            k += pk
        else
            continue
        end
    end
    return imbs, load
end


function simulated_annealing(sts::Vector{Station}, dists::Matrix{Float64}, dware::Vector{Float64}, K::Int)
    """
    This is a heuristic to find a better solution to our problem.
    We use a simulated annealing heuristic and shuffle our path and generate drop-offs and pick-ups.
    """
    n = length(sts)
    orig_imbs = get_imbs(sts)
    best_path = collect(1:n)  # Initialize with a simple path
    best_imbs, best_load = generate_path(best_path, orig_imbs, K)
    best_cost = get_cost(best_path, dists, dware, best_imbs)
    current_imbs, current_load, current_path = best_imbs, best_load, best_path
    current_cost = best_cost

    T = 400
    alpha = 0.9

    for _ in 1:n  # Use _ instead of a variable name if it won't be used
        ni = rand([0, 0, 1, 2])
        path = shuffle_path(current_path, ni)
        path_imbs, load = generate_path(path, orig_imbs, K)
        cost = get_cost(path, dists, dware, path_imbs)
        
        accept_prob = exp((current_cost - cost) / T)
        if cost < current_cost || rand() < accept_prob
            current_cost = cost
            current_path = path
            current_imbs = path_imbs
            current_load = load

            if cost < best_cost
                best_cost = cost
                best_path = path
                best_imbs = path_imbs
                best_load = load
            end
        end
        T = alpha * T
    end
    return best_cost, best_path, best_imbs, best_load
end

# Check if an input file is provided through command-line argument
if length(ARGS) > 0
    filename = ARGS[1]
    n, sts, ware, K = parse_file(filename)
    imbs = get_imbs(sts)
    dists = dist_stations(sts)
    dware = dists_to_ware(ware, sts)
    best_cost, best_path, best_imbs, best_load = simulated_annealing(sts, dists, dware, K)

    println("The best path found:")
    println(best_path)
else
    println("No input file provided. Please provide the path to the input file as a command-line argument.")
end
