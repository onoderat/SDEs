using SDEs
using Compat, BenchmarkTools
include("../test/setup.jl")
include("../test/test_utils.jl")

θ=0.5
η=0.5

println(prob, ", dt:", t[2]-t[1], ", θ:",θ, ", η:",η)
print("EM proto  :")
@btime x, W = integrate(prob, x0, t, SDEs.EMproto(), 1)
print("EM        :")
@btime x, W = integrate(prob, x0, t, EM(), 1)
print("Diffeq EM :")
@btime x, W = integrate(prob, x0, t, DEQEM(), 1)
print("PCE proto :")
@btime x, W = integrate(prob, x0, t, SDEs.PCEproto(), 1; θ=θ, η=η)
print("PCE       :")
@btime x, W = integrate(prob, x0, t, PCE(), 1; θ=θ, η=η)
