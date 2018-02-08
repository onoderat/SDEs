using SDEs, Base.Test
include("setup.jl")
include("test_utils.jl")

Ncheck = 1000
tolerance = 2/sqrt(Ncheck) #CLT for comparing processes with different random number generators
id_tolerance = 1e-7 #For comparing things with same random number generators
θ=0.5
η=0.5

println(prob, ", dt:", t[2]-t[1], ", θ:",θ, ", η:",η)

EMPdev = check(prob, x0, t, SDEs.EMproto(), 1:Ncheck)
println("proto EM  :", EMPdev)

EMdev = check(prob, x0, t, EM(), 1:Ncheck)
println("EM        :", EMdev)

DeqEMdev = check(prob, x0, t, DEQEM(), 1:Ncheck)
println("Diffeq    :", DeqEMdev)

PCEPdev = check(prob, x0, t, SDEs.PCEproto(), 1:Ncheck; θ=θ, η=η)
println("proto PCE :", PCEPdev)

PCEdev = check(prob, x0, t, PCE(), 1:Ncheck; θ=θ, η=η)
println("PCE       :", PCEdev)

@test EMdev ≈ DeqEMdev atol=EMdev*tolerance
@test EMdev ≈ EMPdev atol=EMdev*id_tolerance
@test PCEPdev ≈ PCEdev atol=PCEdev*id_tolerance
@test PCEdev < EMdev
