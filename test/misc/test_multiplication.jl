using BenchmarkTools

N = 1000
k1 = 2.
k2 = 3.
A1 = randn(N, N)
A2 = randn(N, N)
b = randn(N)

#%%

@btime (k1 * A1 + k2 * A2) * b;
@btime k1 * (A1 * b) + k2 * (A2 * b);

#%%
@btime k1*A1*b
@btime k1*(A1*b)
