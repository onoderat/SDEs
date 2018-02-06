using SDEs
using Compat, BenchmarkTools
include("../setup.jl")
include("../testutils.jl")
include("../test.jl")

##
@time x, W = solve(prob, x0, t)
@btime x, W = solve(prob, x0, t)
