#Solves the predictor corrector euler scheme - pg327 of Bruti-Liberati 2007
#Strong order 0.5, with some degree of implicitness

#Prototyping predictor corrector code
struct PCEproto <: Solver end
struct PCE <: Solver end

function integrate(a!::Function, b!::Function, x0::AbstractVector{T}, t::AbstractVector{<:Real},
    noise::Noise, pce::PCEproto, callback::Function; θ::Float64=0.5, η::Float64 = 0., bbprime!::Function = (t,x,bbp)-> nothing) where {T<:Number}

    n = length(x0)
    bbp = zeros(T, n)

    function abar!(t, x, ff)
        a!(t, x, ff)
        bbprime!(t, x, bbp)
        ff .-= η*bbp
        return nothing
    end

    W = W0(noise)
    ΔW = copy(W)
    x = copy(x0)

    f = Vector{T}(n)
    g = Matrix{T}(n, noise.m)

    xbar = copy(x0)
    fbar = copy(f)
    gbar = copy(g)

    callback(t[1], x, W)
    for i in 1:length(t)-1
        Δt = t[i+1]-t[i]
        randn!(noise, ΔW)
        ΔW .*= sqrt(Δt)

        abar!(t[i], x, f)
        b!(t[i], x, g)

        xbar .= copy(x)
        xbar .+= f*Δt + g*ΔW

        abar!(t[i+1], xbar, fbar)
        b!(t[i+1], xbar, gbar)

        x .+= (θ*fbar + (1-θ)*f)*Δt + (η*gbar + (1-η)*g)*ΔW
        callback(t, x, W)
    end
end

"""
optimized predictor corrector integrate
ab! : bias & diffusion function
x0 : Initial state
t : times to use for time evolution
noise : Noise object
callback : a function that runs on t, x, W
"""
function integrate(a!::Function, b!::Function, x0::AbstractVector{T}, t::AbstractVector{<:Real},
    noise::Noise, pce::PCE, callback::Function; θ::Float64=0.5, η::Float64 = 0., bbprime!::Function = (t,x,bbp)-> nothing) where {T<:Number}

    n = length(x0)
    bbp = zeros(T, n)

    function abar!(t, x, ff)
        a!(t, x, ff)
        bbprime!(t, x, bbp)
        bbp .*= -η
        ff .+=  bbp
        return nothing
    end

    W = W0(noise)
    ΔW = copy(W)
    x = copy(x0)


    fΔt = Vector{T}(n)
    g = Matrix{T}(n, noise.m)
    gΔW = Vector{T}(n)

    xbar = copy(x)
    fΔtbar = copy(fΔt)
    gbar = copy(g)
    gΔWbar = Vector{T}(n)

    #save the first data point
    callback(t[1], x, W)

    for i in 1:length(t)-1
        Δt = t[i+1]-t[i]
        randn!(noise, ΔW)
        ΔW .*= sqrt(Δt)

        abar!(t[i], x, fΔt)
        b!(t[i], x, g)

        fΔt .*= Δt
        A_mul_B!(gΔW, g, ΔW)

        xbar = copy(x)
        xbar .+= fΔt
        xbar .+= gΔW

        abar!(t[i+1], xbar, fΔtbar)
        b!(t[i+1], xbar, gbar)

        fΔtbar .*= Δt
        A_mul_B!(gΔWbar, gbar, ΔW)

        fΔtbar .*= θ
        fΔt .*= 1-θ
        gΔWbar .*= η
        gΔW .*= 1-η

        x .+= fΔtbar
        x .+= fΔt
        x .+= gΔWbar
        x .+= gΔW

        W .+= ΔW
        callback(t, x, W)
    end
    return nothing
end
