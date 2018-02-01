#Solves SDE Problems
#Currently only EM is implemented
"""
Private explicitEM function
ab! : bias & diffusion function
x0 : Initial state
t : times to use for time evolution
noise : Noise object
callback : a function that runs on t, x, W
"""
function explicitEM_(ab!::Function, x0::AbstractVector{T}, t::AbstractVector{<:Real}, noise::Noise, callback::Function) where {T<:Number}
    W = W0(noise)
    x = copy(x0)

    n = length(x0)
    fΔt = Vector{T}(n)
    g = Matrix{T}(n, Noise.m)
    ΔW = copy(W)
    gΔW = Vector{T}(n)

    for i in 1:length(t)-1
        Δt = t[i+1]-t[i]

        ab!(t[i], x, fΔt, g)

        fΔt .*= Δt
        x .+= fΔt

        randn!(ΔW)
        ΔW .*= sqrt(Δt)
        A_mul_B!(gΔW, g, ΔW)
        x .+= gΔW
        W .+= ΔW
        callback(t, x, W)
    end
    return nothing
end

"""
Default callback function that stores x & W of the simulations.
"""
function default_callback(out)
    return function(t,x,W)
    push!(out[1], xvec)
    push!(out[2], Wvec)
    end
end

function explicitEM(ab!::Function, x0::AbstractVector{T}, t::AbstractVector{<:Real}, m::Int; verbose::Bool=false, seed=seed_gen()) where {T<:Number}
    out = [[], []] #Instantiate for saving the x and W respectively
    explicitEM(ab!, x0, t, m, callback=default_callback(out); seed=seed)
    return out
end
