import DifferentialEquations
DiffEq = DifferentialEquations


#Below are functions to solve with DiffEq
function solve_diffeq(prob::Problem, x0::AbstractVector, t::AbstractVector)
    nrp = zeros(length(x0), mgen(prob, x0))
    prob = DiffEq.SDEProblem(a!(prob), b!(prob), x0, (t[1], t[end]); noise_rate_prototype=nrp)
    sol = DiffEq.solve(prob, dt=t[2]-t[1], adaptive=false; save_noise=true)
    return sol.u[1:length(t)], sol.W.u[1:length(t)]
end

function test_diffeq(prob::Problem, x0::AbstractVector, t::AbstractVector)
    x, W = solve_diffeq(prob, x0, t)
    x_analytic = solution(prob, x0, t, W)
    return x, x_analytic, W
end

function check_diffeq(prob::Problem, x0::AbstractVector, t::AbstractVector)
    x, x_analytic, _ = test_diffeq(prob, x0, t)
    return diff_rms(t, x, x_analytic)
end

function check_diffeq(prob::Problem, x0::AbstractVector, t::AbstractVector, Ncheck::Int)
    return mean([check_diffeq(prob, x0, t) for i in 1:Ncheck])
end
