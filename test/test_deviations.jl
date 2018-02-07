using SDEs, Base.Test
include("setup.jl")
include("testutils.jl")
include("test.jl")

Ncheck = 1000
tolerance = 2/sqrt(Ncheck) #CLT
θ=0.5
η=0.5

println(prob, ", dt:", t[2]-t[1], ", θ:",θ, ", η:",η)

EMPdev = check(prob, x0, t, SDEs.EMproto(), 1:Ncheck)
println("proto EM  :", EMPdev)
EMdev = check(prob, x0, t, EM(), 1:Ncheck)
println("EM        :", EMdev)
PCEPdev = check(prob, x0, t, SDEs.PCEproto(), 1:Ncheck; θ=θ, η=η)
println("proto PCE :", PCEPdev)
PCEdev = check(prob, x0, t, PCE(), 1:Ncheck; θ=θ, η=η)
println("PCE       :", PCEdev)

##Run DiffEq here to compare the deviation.
# include("test_diffeq.jl")
# DeqEMdev = check(prob, x0, t, DEQEM(), 1:Ncheck)
# println("Diffeq EM deviation is ", DeqEMdev)

#@test EMdev ≈ DeqEMdev atol=EMdev*tolerance
