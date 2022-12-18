# Import necessary packages
using JuMP
using Cbc

# Define a function to parse data from a file
function parse_file(filename::String)
    # Initialize variables
    k = 0
    x = Int[]
    y = Int[]
    nbp = Int[]
    capa = Int[]
    ideal = Int[]
    ware = (0, 0)

    # Open the file and read its content line by line
    f = open(filename, "r")
    for l in readlines(f, keep=true)
        # Parse the values for k and warehouse location
        if startswith(l, "K")
            k = parse(Int, split(l)[2])
        elseif startswith(l, r"stations|name|#")
            continue 
        elseif startswith(l, "warehouse")
            c = split(l, " ")
            wx, wy = parse(Int, c[2]), parse(Int, c[3])
            ware = (wx, wy)
        else
            # Parse the values for station locations and characteristics
            tab = split(l, " ")
            push!(x, parse(Int, tab[2]))
            push!(y, parse(Int, tab[3]))
            push!(nbp, parse(Int, tab[4]))
            push!(capa, parse(Int, tab[5]))
            push!(ideal, parse(Int, tab[6]))
        end
    end
    # Return the parsed data
    return length(x), k, ware, x, y, nbp, capa, ideal
end

# Parse the data from the input file
n, K, ware, x, y, nbp, capa, ideal = parse_file("/home/oury/instances/tsdp_1_s10_k6.dat")

# Define a function to compute distances from stations to the warehouse
function dists_to_ware(w, x)
    # Initialize an empty array
    d = zeros(Float64, length(x))
    # Compute distances using the Euclidean distance formula
    for i in 1:n
        d[i] = round(sqrt(abs2(x[i] - w[1]) + abs2(y[i] - w[2])))
    end
    # Return the distances
    d
end

# Define a function to compute distances between stations
function dist_stations(x, y)
    # Initialize a square matrix of zeros
    d = zeros(Float64, (n, n))
    # Compute distances using the Euclidean distance formula
    for i in 1:n
        for j in 1:n
            if i != j
                d[i, j] = round(sqrt(abs2(x[i] - x[j]) + abs2(y[i] - y[j])))
            end
        end
    end
    # Return the distances
    d
end

# Compute the distances from stations to the warehouse and between stations
dists = dist_stations(x, y)
dware = dists_to_ware(ware, x)

# Define a JuMP optimization model using the Cbc solver
m = Model(Cbc.Optimizer)


# Define decision variables
@variable(m, x[i in 1:n, j in 1:n], Bin) # Binary variables for selecting stations at each step
@variable(m, load[j in 0:n] >= 0) # Amount of bicycle carried by the Vehicle at each step
@variable(m, drop[i in 1:n, j in 1:n]) # Amount of bicycle dropped off by the Vehicle at each station and step
@variable(m, imb[i in 1:n] >= 0) # Imbalance variable for each station
@variable(m, y[i in 1:n, j in 1:n-1, k in 1:n] >= 0) # Flow variable for bicycle between stations

# Define constraints
@constraint(m, uniq_i[i in 1:n], sum(x[i,j] for j in 1:n) == 1) # Each station is selected exactly once
@constraint(m, uniq_j[j in 1:n], sum(x[i,j] for i in 1:n) == 1) # Each step visits exactly one station
@constraint(m, load_constr1[j in 0:n], load[j] <= K) # Vehicle can carry up to K units of bicycle
@constraint(m, load_constr2[j in 1:n], load[j] == load[j-1] - sum(drop[i,j] for i in 1:n)) # bicycle carried is updated at each step
@constraint(m, drop_constr[i in 1:n, j in 1:n], drop[i,j] <= (capa[i] - nbp[i])*x[i,j]) # Amount of bicycle dropped off cannot exceed remaining capacity at station
@constraint(m, nbp_constr[i in 1:n, j in 1:n], -nbp[i]*x[i,j] <= drop[i,j]) # Non-backlog policy constraint
@constraint(m, imb_cons1[i in 1:n], imb[i] >= nbp[i] + sum(drop[i,j] for j in 1:n) - ideal[i]) # Imbalance constraint 1
@constraint(m, imb_cons2[i in 1:n], imb[i] >= -nbp[i] - sum(drop[i,j] for j in 1:n) + ideal[i]) # Imbalance constraint 2
@constraint(m, y_cons[i in 1:n, j in 1:n-1, k in 1:n], y[i,j,k] >= x[i,j] + x[k, j+1] - 1) # Flow conservation constraint

# Define objective function
@objective(m, Min, 1000*sum(imb[i] for i in 1:n) + sum(dware[i]*x[i,1] for i in 1:n) 
            + sum(sum(sum(dists[i,k]*y[i,j,k] for k in 1:n) for i in 1:n) for j in 1:n-1)
            + sum(dware[i]*x[i,n] for i in 1:n))

# Solve the optimization problem and output results
start = time()


set_silent(m) 
optimize!(m)
finish = time()

OBJ = objective_value(m)

println("The optimal value is : ", OBJ)
println("obtained in ", finish-start, " seconds")

# Print selected stations
for i in 1:n
    for j in 1:n
        xij = JuMP.value(x[i,j])
        if (xij >= 0.99 && xij <= 1.01) 
            println("We select the station ",i," at step ",j,")")
        end
    end
end

# Check if problem is solved to optimality
status = termination_status(m)
isOptimal = status == MOI.OPTIMAL

if isOptimal 
    println("The problem has been solved to the optimum")
else 
    println("The problem has not been solved to the optimum")
end