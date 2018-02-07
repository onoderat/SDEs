#Parameter file for instiating equation 31 in Kloden & Platen
include("problems.jl")

const avec = [0.8]#, 0.4, 0.9, 0.4, 0.2, 0.21, 0.6, 0.43, 0.21, -0.1]
const prob = Problem31(avec)

#Must be between -1 and 1!
const x0 = [-0.5]#, 0.5, 0.3, -0.2, 0.7, 0.85, 0.0, -0.3, -0.34, 0.62]
const t = linspace(0., 1., 50)
