# SDEs

Barebones library to simulate SDEs. 

Solvers currently supported

1. Euler Maruyama
2. Predictor Corrector Euler - Stochastics and Dynamics, Vol. 8, No. 3 (2008) 561–581

See ipython notebook benchmark to see the performance of the predictor corrector euler algorithm.

Current plan is to use this package as a test bed to learn how to code up these equations before incoorporating these algorithms into [DifferentialEquations.jl](http://docs.juliadiffeq.org/stable/)

[![Build Status](https://travis-ci.org/onoderat/SDEs.jl.svg?branch=master)](https://travis-ci.org/onoderat/SDEs.jl)

[![Coverage Status](https://coveralls.io/repos/onoderat/SDEs.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/onoderat/SDEs.jl?branch=master)

[![codecov.io](http://codecov.io/github/onoderat/SDEs.jl/coverage.svg?branch=master)](http://codecov.io/github/onoderat/SDEs.jl?branch=master)
