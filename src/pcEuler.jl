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
    W = W0(noise)
    x = copy(x0)

    n = length(x0)
    f = Vector{T}(n)
    g = Matrix{T}(n, noise.m)
    ΔW = copy(W)

    #save the first data point
    callback(t[1], x, W)

    for i in 1:length(t)-1
        Δt = t[i+1]-t[i]

        a!(t[i], x, f)


        randn!(noise, ΔW)
        ΔW .= ΔW*sqrt(Δt)
        b!(t[i], x, g)
        #A_mul_B!(gΔW, g, ΔW) #This line performs better than the more readable version!
        x .+= f*Δt + g*ΔW
        
        W .+= ΔW
        callback(t, x, W)
    end
    return nothing

end
