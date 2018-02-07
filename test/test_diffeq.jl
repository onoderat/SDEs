import DifferentialEquations
DiffEq = DifferentialEquations

struct DEQEM <: Solver end
function integrate(prob::Problem, x0::AbstractVector, t::AbstractVector, diffeqeuler::DEQEM, seed::Integer)
    nrp = zeros(length(x0), mgen(prob, x0))
    prob = DiffEq.SDEProblem(a!(prob), b!(prob), x0, (t[1], t[end]); noise_rate_prototype=nrp)
    sol = DiffEq.solve(prob, dt=t[2]-t[1], adaptive=false; save_noise=true, seed=seed)
    return sol.u[1:length(t)], sol.W.u[1:length(t)]
end
