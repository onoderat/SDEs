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
function integrate(a!::Function, b!::Function, x0::AbstractVector{T}, t::AbstractVector{<:Real},
    noise::Noise, pce::PCE, callback::Function; θ::Float64=0.5, η::Float64 = 0., bbprime::Function = (t,x) -> x) where {T<:Number}

    function abar!(t, x, f)
        a!(t, x, f)
        f .-= η*bbprime(t, x)
    end

    W = W0(noise)
    x = copy(x0)

    n = length(x0)
    fΔt = Vector{T}(n)
    g = Matrix{T}(n, noise.m)
    ΔW = copy(W)
    gΔW = Vector{T}(n)

    xbar = copy(x0)

    f = Vector{T}(n)
    fbar = Vector{T}(n)
    gbar = copy(g)

    #save the first data point
    callback(t[1], x, W)

    for i in 1:length(t)-1
        Δt = t[i+1]-t[i]

        # #This is the more efficient code that probably has a bug...
        # ab!(t[i], x, fΔt, g)
        # randn!(noise, ΔW)
        # ΔW .*= sqrt(Δt)
        # A_mul_B!(gΔW, g, ΔW)
        # #gΔW = g*ΔW
        # xbar .= x
        # xbar .+= fΔt
        # xbar .+= gΔW
        #
        # fΔt .*= Δt*(1-θ) #rescale this term...
        # # x .+= fΔt
        # ab!(t[i+1], xbar, fΔt, g) #Get the drift and diffusion with xbar and the next time step
        # fΔt .*= Δt*θ
        #
        # x .+= fΔt
        # x .+= gΔW #eta = 0 currently.
        # W .+= ΔW

        randn!(noise, ΔW)
        ΔW = sqrt(Δt)*ΔW

        abar!(t[i], x, f)
        b!(t[i], x, g)
        xbar += f*Δt + g*ΔW #prototyping code!

        abar!(t[i+1], xbar, fbar)
        b!(t[i+1], xbar, gbar)
        x += f*Δt*(1-θ) + fbar*Δt*θ + g*ΔW*(1-η) + gbar*ΔW*η

        W = W + ΔW
        callback(t, x, W)
    end
    return nothing
end
