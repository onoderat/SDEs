function test(N::Int, M::Int)
    out = [Vector{Float64}(M) for j in 1:N]
    for j in 1:N
        randn!(out[j])
    end
end

function test2(N::Int, M::Int)
    out = Matrix{Float64}(M,N)
    randn!(out)
end

function test3(N::Int, M::Int)
    out = Vector{Vector{Float64}}(N)
    for j in 1:N
        out[j] = randn(M)
    end
end

function test4(N::Int, M::Int)
    out = Vector(N)
    for j in 1:N
        out[j] = randn(M)
    end
end

#%%
using BenchmarkTools


@time test(100000,1000)
@time test2(100000,1000)
@time test3(100000,1000)
@time test4(100000,1000)

#%%

@btime test(100000,1000)
@btime test2(100000,1000)
@btime test3(100000,1000)
@btime test4(100000,1000)
