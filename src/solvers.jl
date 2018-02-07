# Define the solver type
abstract type Solver end
struct EM <: Solver end
struct PCE <: Solver end

function integrate(a!::Function, b!::Function, x0::AbstractVector{T}, t::AbstractVector{<:Real}, solver::Solver, m::Int, seed::Integer;
                params...) where {T<:Number}
    noise = Noise(m;seed=seed)
    out = [[], []] #Instantiate for saving the x and W respectively
    callback = default_callback(out)
    integrate(a!, b!, x0, t, noise, solver, callback; params...)
    return out
end
