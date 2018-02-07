#Write a few functions to test for Strong convergence of the SDE solvers.
#Attempt to write it for arbituary dimensions! (Even though the formulas are usually for a 1d case)
#The number corresponds to the number of the formulas in Kloden & Platen 1992 - Chapter 4
import SDEs:integrate

function integrate(prob::Problem, x0::AbstractVector, t::AbstractVector, solver::Solver, seed::Integer; params...)
    return integrate(a!(prob), b!(prob), x0, t, solver::Solver, mgen(prob, x0), seed; params...)
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
