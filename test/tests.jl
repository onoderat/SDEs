#Write a few functions to test for Strong convergence of the SDE solvers.
#Attempt to write it for arbituary dimensions! (Even though the formulas are usually for a 1d case)
#The number corresponds to the number of the formulas in Kloden & Platen 1992 - Chapter 4

import DifferentialEquations: SDEProblem, solve

abstract type Problem end

function ab!(prob::Problem)
    a_func = a!(prob)
    b_func = b!(prob)
    return function(t, x, f, g)
        a_func(t, x, f)
        b_func(t, x, g)
        return nothing
    end
end

function solve(prob::Problem, x0::AbstractVector, t::AbstractVector)
    return explicitEM(ab!(prob), x0, t, length(x0))
end

function test(prob::Problem, x0::AbstractVector, t::AbstractVector)
    x, W = solve(prob, x0, t)
    x_analytic = solution(prob, x0, t, W)
    return x, x_analytic, W
end

function check(prob::Problem, x0::AbstractVector, t::AbstractVector)
    x, x_analytic, _ = test(prob, x0, t)
    return diff_rms(t, x, x_analytic)
end

#Below are functions to solve with DiffEq
function solve_diffeq(prob::Problem, x0::AbstractVector, t::AbstractVector)
    nrp = zeros(length(x0), mgen(prob, x0))
    prob = SDEProblem(a!(prob), b!(prob), x0, (t[1], t[end]); noise_rate_prototype=nrp)
    sol = solve(prob, dt=t[2]-t[1], adaptive=false; save_noise=true)
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

##Specific problems from Kloden&Platen
struct Problem31 <: Problem
    avec::Vector{Float64}
end

function mgen(prob::Problem31, x0::AbstractVector)
    return length(x0)
end

function a!(prob::Problem31)
    coeff = -prob.avec.^2
    return function (t, x, f)
        f .= coeff.*(x.*(1-x.^2))
    end
end

function b!(prob::Problem31)
    return function (t, x, g)
        g .= diagm(prob.avec.*(1-x.^2))
    end
end

function solution(prob::Problem31, x0, t, Wvec)
    avec = prob.avec
    return [tanh.(avec.*W+atanh.(x0)) for W in Wvec]
end
