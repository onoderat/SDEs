# Define Noise type which the solvers accepts
function default_seed()
    return rand(UInt)
end

function default_rng(seed)
    return MersenneTwister(seed)
end

"""
Arguments
T : Noise Type
m : Specifies the number of noise channels

Keyword arguments
seed: There is another more convenient constructor that given a seed instantiates a RNG using the deault_rng function.
"""
struct Noise
    m::Int
    rng::AbstractRNG
    Noise(m::Int, rng::AbstractRNG) = new(m, rng)
    Noise(m::Int; seed::Integer=default_seed()) = new(m, default_rng(seed))
end

W0(noise::Noise) = zeros(Float64, noise.m)

import Base:randn!

function randn!(noise::Noise, ΔW)
    randn!(noise.rng, ΔW)
end
