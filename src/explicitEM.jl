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
function explicitEM(ab!::Function, x0::AbstractVector{T}, t::AbstractVector{<:Real},
    noise::Noise, callback::Function) where {T<:Number}
    W = W0(noise)
    x = copy(x0)

    n = length(x0)
    fΔt = Vector{T}(n)
    g = Matrix{T}(n, noise.m)
    ΔW = copy(W)
    gΔW = Vector{T}(n)

    #save the first data point
    callback(t[1], x, W)

    for i in 1:length(t)-1
        Δt = t[i+1]-t[i]

        ab!(t[i], x, fΔt, g)

        fΔt .*= Δt
        x .+= fΔt

        randn!(noise, ΔW)
        ΔW .*= sqrt(Δt)
        #A_mul_B!(gΔW, g, ΔW) #This line performs better than the more readable version!
        gΔW .= g*ΔW
        x .+= gΔW
        W .+= ΔW
        callback(t, x, W)
    end
    return nothing
end

function explicitEM(ab!::Function, x0::AbstractVector{T}, t::AbstractVector{<:Real}, m::Int; seed::Integer=default_seed()) where {T<:Number}
    noise = Noise(m;seed=seed)
    out = [[], []] #Instantiate for saving the x and W respectively
    callback = default_callback(out)
    explicitEM(ab!, x0, t, noise, callback)
    return out
end
