#Solves the predictor corrector euler scheme - pg327 of Bruti-Liberati 2007
#Strong order 0.5, with some degree of implicitness
#First solve it for an η of 0. TODO: Extend this later.
"""
Private predictor  function
ab! : bias & diffusion function
x0 : Initial state
t : times to use for time evolution
noise : Noise object
callback : a function that runs on t, x, W
"""
function pcEuler(ab!::Function, x0::AbstractVector{T}, t::AbstractVector{<:Real},
    noise::Noise, callback::Function; θ=0.5::Float64) where {T<:Number}
    W = W0(noise)
    x = copy(x0)

    n = length(x0)
    fΔtscaled = Vector{T}(n)
    g = Matrix{T}(n, noise.m)
    ΔW = copy(W)
    gΔW = Vector{T}(n)

    xbar = copy(x0)

    #save the first data point
    callback(t[1], x, W)

    for i in 1:length(t)-1
        Δt = t[i+1]-t[i]

        ab!(t[i], x, fΔt, g)
        fΔtscaled .*= Δt*(1-θ)
        randn!(noise, ΔW)
        ΔW .*= sqrt(Δt)
        A_mul_B!(gΔW, g, ΔW)

        xbar = copy(x)
        xbar .+= fΔtscaled
        xbar .+= gΔW

        x .+= (1-θ)*fΔt

        ab!(t[i+1], xbar, fΔtscaled, ΔW) #Get the drift and diffusion with xbar and the next time step
        fΔtscaled .*= Δt*θ

        x .+= fΔtscaled
        x .+= gΔW #eta = 0 currently.
        W .+= ΔW
        callback(t, x, W)
    end
    return nothing
end

function pcEuler(ab!::Function, x0::AbstractVector{T}, t::AbstractVector{<:Real}, m::Int; seed::Integer=default_seed(), θ=) where {T<:Number}
    noise = Noise(m;seed=seed)
    out = [[], []] #Instantiate for saving the x and W respectively
    callback = default_callback(out)
    explicitEM(ab!, x0, t, noise, callback)
    return out
end
