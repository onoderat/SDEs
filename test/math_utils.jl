#Functions to for computing the difference between sampled functions.
"""
Approximating the integral of a function using the right hand side only.
This function does not really belong to this library... Figure out where to put it exactly.
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
