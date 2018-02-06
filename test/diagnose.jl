using SDEs, Base.Test
include("setup.jl")
include("testutils.jl")
include("tests.jl")

x, x_analytic, W = test(prob, x0, t)

##
using PyPlot
plot(t, x)
plot(t, x_analytic)

##
plot(t, W)
