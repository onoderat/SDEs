# Define Noise type which the solvers accepts
abstract type NoiseType end
abstract type RealNoise <: NoiseType end
abstract type ComplexNoise <: NoiseType end
abstract type ComplexAnalyticNoise <: NoiseType end

#Figure out a way to hide the neccesary hidden memory in some hidden way.
"""
T : Noise Type
m : Specifies the number of noise channels
"""
struct Noise{T} where T <: NoiseType
    m::Int
    rng::AbstractRNG
    temp::Vector{Float64}
end

function seed_gen()
    return Int(round(time()))
end

RealNoise(m; seed=seed_gen()) = Noise{RealNoise}(m, MersenneTwister(seed), nothing)
ComplexAnalyticNoise(m; seed=seed_gen()) = Noise{ComplexAnalyticNoise}(m, MersenneTwister(seed), Vector{Float64}(2m))
ComplexNoise(m; seed=seed_gen()) = Noise{ComplexNoise}(m, MersenneTwister(seed), Vector{Float64}(2m))

W0(noise::Noise{RealNoise}) = zeros(Float64, Noise.m)
W0(noise::Noise{ComplexNoise}) = zeros(Complex128, 2*Noise.m) #This create the W for for both W and W^*, since this is required in the matrix multiplication with g.
W0(noise::Noise{ComplexAnalyticNoise}) = zeros(Complex128, Noise.m)

function randn!(noise::Noise{RealNoise}, ΔW)
    randn!(noise.rng, ΔW)
end

#TODO: Can this function be optimized further?
function randn!(noise::ComplexNoise, ΔW)
    randn!(noise.rng, noise.temp)
    ΔW[1:noise.m] .= noise.temp[1:noise.m] + im*noise.temp[noise.m+1:end]
    ΔW[noise.m+1:end] .= noise.temp[1:noise.m] - im*noise.temp[noise.m+1:end]
end

function randn!(noise::ComplexAnalyticNoise, ΔW)
    randn!(noise.rng, noise.temp)
    ΔW .= noise.temp[1:noise.m] + im*noise.temp[noise.m+1:end]
end
