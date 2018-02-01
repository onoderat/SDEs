using BenchmarkTools

function test(A::AbstractArray)
    r = zero(A[1])
    for i = 1:length(A)
        @inbounds r += A[i]
    end
    return r
end

function test2(A::AbstractArray)
    r = zero(A[1])
    for i = 1:length(A)
        r += A[i]
    end
    return r
end

function test3(A::AbstractArray)
    r = zero(A[1])
    for i = 1:length(A)
        @inbounds r .+= A[i]
    end
    return r
end

function test4(A::AbstractArray)
    r = zero(A[1])
    for i = 1:length(A)
        r .+= A[i]
    end
    return r
end

#%%
const a = [randn(200) for i in 1:100];

#%%
@btime test(a);
@btime test2(a);
@btime test3(a);
@btime test4(a);
