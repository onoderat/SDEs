using SDEs, Base.Test
include("setup.jl")
include("testutils.jl")
include("test.jl")
#include("test_diffeq.jl")

##
x1, W1 = integrate(prob, x0, t, EM(), 1)
x2, W2 = integrate(prob, x0, t, SDEs.PCEproto(), 1; θ=0., η=0.5)
#x3, W3 = integrate(prob, x0, t, DEQEM(), 1)

println((x2 - x1)[end])

##
using PyPlot
plot(t, x1)
plot(t, x2)

##
figure()
plot(t, W1-W2)

##
