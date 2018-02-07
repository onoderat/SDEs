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
    noise::Noise, pce::PCE, callback::Function; θ::Float64=0.5, η::Float64 = 0., bbprime!::Function = (x,y,z)-> nothing) where {T<:Number}

    n = length(x0)
    bb_temp = zeros(T, n)
    function abar!(t, x, ff)
        a!(t, x, ff)
        bbprime!(t, x, bb_temp)
        ff .= ff - η*bb_temp
        return nothing
    end

    W = W0(noise)
    x = copy(x0)


    f = Vector{T}(n)
    g = Matrix{T}(n, noise.m)
    gΔW = Vector{T}(n)
    ΔW = copy(W)

    xbar = copy(x)
    fbar = copy(f)
    gbar = copy(g)

    #save the first data point
    callback(t[1], x, W)

    for i in 1:length(t)-1
        Δt = t[i+1]-t[i]
        randn!(noise, ΔW)
        ΔW .*= sqrt(Δt)

        abar!(t[i], x, f)
        b!(t[i], x, g)

        f .*= Δt
        A_mul_B!(gΔW, g, ΔW)

        xbar = copy(x)
        xbar .+= f
        xbar .+= gΔW

        abar!(t[i+1], xbar, fbar)
        b!(t[i+1], xbar, gbar)

        x .+= (θ*fbar + (1-θ)*f)*Δt + (η*gbar + (1-η)*g)*ΔW
        W .+= ΔW
        callback(t, x, W)
    end
    return nothing

end
