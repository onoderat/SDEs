#This script will compare the speed of this code against DiffEq
include("../src/solvers.jl")
include("tests.jl")
include("params_31.jl")

using DifferentialEquations
using BenchmarkTools
##
@time x, W = diffeq_run_31(x0, t, avec)
@btime x, W = diffeq_run_31(x0, t, avec)
