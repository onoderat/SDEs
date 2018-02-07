using SDEs
using Compat, BenchmarkTools
include("../setup.jl")
include("../testutils.jl")
include("../test.jl")
include("../test_diffeq.jl")

##
@time x, W = integrate(prob, x0, t, EM(), 1)
@time x, W = integrate(prob, x0, t, PCE(), 1)
@time x, W = integrate(prob, x0, t, DEQEM(), 1)

@btime x, W = integrate(prob, x0, t, EM(), 1)
@btime x, W = integrate(prob, x0, t, PCE(), 1)
@btime x, W = integrate(prob, x0, t, DEQEM(), 1)
