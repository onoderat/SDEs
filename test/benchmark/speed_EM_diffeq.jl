using SDEs
using Compat, BenchmarkTools
include("../setup.jl")
include("../testutils.jl")
include("../test_diffeq.jl")

##
@time x, W = solve_diffeq(prob, x0, t)
@btime x, W = solve_diffeq(prob, x0, t)
