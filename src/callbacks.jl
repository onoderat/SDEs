# Defines a set of standard callback functions

"""
Default callback function that stores x & W of the simulations.
"""
function default_callback(out)
    return function(t,x,W)
    push!(out[1], copy(x))
    push!(out[2], copy(W))
    end
end
