using SDEs, Base.Test
include("setup.jl")
include("testutils.jl")
include("test.jl")

Ncheck = 1000
tolerance = 2/sqrt(Ncheck) #CLT

##Running the checks for this package
println("dt:", t[2]-t[1])
EMdev = check(prob, x0, t, EM(), 1:Ncheck)
println("Our EM deviations is   ", EMdev)

θ=0.5
η=0.5

PCEdev = check(prob, x0, t, PCE(), 1:Ncheck; θ=θ, η=η)
println("θ:",θ, "   η:",η)
println("PCE deviations is      ", PCEdev)

##Run DiffEq here to compare the deviation.
# include("test_diffeq.jl")
# DeqEMdev = check(prob, x0, t, DEQEM(), 1:Ncheck)
# println("Diffeq EM deviation is ", DeqEMdev)

#@test EMdev ≈ DeqEMdev atol=EMdev*tolerance
