
function _test(A::Matrix{Float64})
    v = 0
    for i in 1:size(A,2)
        v += sum(view(A,:,i))
    end
end

function test(N::Int, M::Int)
    return _test(randn(M,N))
end

function test2(N::Int, M::Int)
    v = 0
    for i in 1:N
        v += sum(randn(M))
    end
end

#%%
using BenchmarkTools

@time test(100000,1000)
@time test2(100000,1000)


@btime test(100000,1000)
@btime test2(100000,1000)
