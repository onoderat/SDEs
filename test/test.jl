#Write a few functions to test for Strong convergence of the SDE solvers.
#Attempt to write it for arbituary dimensions! (Even though the formulas are usually for a 1d case)
#The number corresponds to the number of the formulas in Kloden & Platen 1992 - Chapter 4

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
    return explicitEM(ab!(prob), x0, t, mgen(prob, x0))
end

function solvepc(prob::Problem, x0::AbstractVector, t::AbstractVector)
    return pcEuler(ab!(prob), x0, t, mgen(prob, x0))
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

function check(prob::Problem, x0::AbstractVector, t::AbstractVector, Ncheck::Int)
    return mean([check(prob, x0, t) for i in 1:Ncheck])
end
