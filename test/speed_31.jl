#A purely speed-check run. Does not check for correctness in script!
#Used to compare with say DiffEq
include("../src/solvers.jl")
include("setup_31.jl")
using BenchmarkTools

##
@time x, W = solve(prob, x0, t)
@btime x, W = solve(prob, x0, t)
