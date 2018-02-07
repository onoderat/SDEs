using SDEs, Base.Test
include("setup.jl")
include("testutils.jl")
include("test.jl")

Ncheck = 40000
tolerance = 2/sqrt(Ncheck) #CLT

##Running the checks for this package
EMdev = check(prob, x0, t, EM(), 1:Ncheck)
println("Our EM deviations is   ", EMdev)

PCEdev = check(prob, x0, t, PCE(), 1:Ncheck; θ=0.0, η=0.)
println("PCE deviations is   ", PCEdev)

##Run DiffEq here to compare the deviation.
include("test_diffeq.jl")
DeqEMdev = check(prob, x0, t, DEQEM(), 1:Ncheck)
println("Diffeq EM deviation is ", DeqEMdev)

#@test EMdev ≈ DeqEMdev atol=EMdev*tolerance
