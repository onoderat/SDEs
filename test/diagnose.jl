using SDEs, Base.Test
include("setup.jl")
include("testutils.jl")
include("test.jl")
include("test_diffeq.jl")

##
x1, W1 = integrate(prob, x0, t, EM(), 1)
x2, W2 = integrate(prob, x0, t, PCE(), 1; θ=0.)

##
using PyPlot
plot(t, x1-x2)

##
figure()
plot(t, W_EM-W_pc)

##
