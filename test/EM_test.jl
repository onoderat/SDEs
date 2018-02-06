using SDEs, Base.Test
include("setup.jl")
include("testutils.jl")
include("test.jl")

Ncheck = 1000
tolerance = 2/sqrt(Ncheck) #CLT

##Running the checks for this package
deviation = check(prob, x0, t, Ncheck)
println("This pkg's EM deviations is ", deviation)

##Run DiffEq here to compare the deviation.
include("test_diffeq.jl")
diffeq_deviation = check_diffeq(prob, x0, t, Ncheck)
println("Diffeq's EM deviation is    ", diffeq_deviation)

@test deviation ≈ diffeq_deviation atol=deviation*tolerance
