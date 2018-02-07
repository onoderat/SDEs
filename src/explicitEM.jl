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
function integrate(a!::Function, b!::Function, x0::AbstractVector{T}, t::AbstractVector{<:Real},
    noise::Noise, em::EM, callback::Function) where {T<:Number}
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
        randn!(noise, ΔW)
        ΔW .*= sqrt(Δt)

        a!(t[i], x, fΔt)
        b!(t[i], x, g)

        fΔt .*= Δt
        A_mul_B!(gΔW, g, ΔW) #This line performs better than the more readable version!

        x .+= fΔt
        x .+= gΔW
        W .+= ΔW
        callback(t, x, W)
    end
    return nothing
end
