#Functions to test for strong convergence of the SDE solvers.
#The number corresponds to the number of the formulas in Kloden & Platen 1992 - Chapter 4
import SDEs:integrate

"""
Approximating the integral of a function using the right hand side only.
"""
function rint(t::AbstractVector, x::AbstractVector)
    return sum(diff(t).*x[2:end])
end

"""
return the rms for the difference between 2 single-varible function (of t)
"""
function diff_rms(t::AbstractVector, f1vec::AbstractVector, f2vec::AbstractVector)
    fdiff = [norm(f1-f2) for (f1, f2) in zip(f1vec, f2vec)]
    rms = sqrt(rint(t, fdiff)/(t[end]-t[1]))
    return rms
end

function integrate(prob::Problem, x0::AbstractVector, t::AbstractVector, solver::Solver, seed::Integer; params...)
    return integrate(a!(prob), b!(prob), x0, t, solver, mgen(prob, x0), seed; params...)
end

function integrate(prob::Problem, x0::AbstractVector, t::AbstractVector, pce::Union{PCE, SDEs.PCEproto}, seed::Integer; params...)
    return integrate(a!(prob), b!(prob), x0, t, pce, mgen(prob, x0), seed; bbprime! = bbp!(prob), params...)
end

import DifferentialEquations
DiffEq = DifferentialEquations

struct DEQEM <: Solver end
function integrate(prob::Problem, x0::AbstractVector, t::AbstractVector, diffeqeuler::DEQEM, seed::Integer)
    nrp = zeros(length(x0), mgen(prob, x0))
    prob = DiffEq.SDEProblem(a!(prob), b!(prob), x0, (t[1], t[end]); noise_rate_prototype=nrp)
    sol = DiffEq.solve(prob, dt=t[2]-t[1], adaptive=false; save_noise=true, seed=seed)
    return sol.u[1:length(t)], sol.W.u[1:length(t)]
end

function test(prob::Problem, x0::AbstractVector, t::AbstractVector, solver::Solver, seed::Integer; params...)
    x, W = integrate(prob, x0, t, solver, seed; params...)
    x_analytic = solution(prob, x0, t, W)
    return x, x_analytic, W
end

function check(prob::Problem, x0::AbstractVector, t::AbstractVector, solver::Solver, seed::Integer; params...)
    x, x_analytic, _ = test(prob, x0, t, solver, seed; params...)
    return diff_rms(t, x, x_analytic)
end

function check(prob::Problem, x0::AbstractVector, t::AbstractVector, solver::Solver, seedlist::AbstractArray; params...)
    return mean([check(prob, x0, t, solver, i; params...) for i in seedlist])
end
