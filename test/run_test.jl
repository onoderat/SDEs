include("../src/solvers.jl")
include("setup.jl")
using BenchmarkTools
Ncheck = 1000

##Running the checks for this package
my_deviation = mean([check(prob, x0, t) for i in 1:Ncheck])
println("This pkg's deviations is ", my_deviation)

##Run DiffEq here to compare the deviation.
diffeq_deviation = mean([check_diffeq(prob, x0, t) for i in 1:Ncheck])
println("Diffeq's deviation is    ", diffeq_deviation)

##
# @time x, x_analytic, W = test_31(x0, t, avec)
# using PyPlot
# plot(t, x)
# plot(t, x_analytic)
