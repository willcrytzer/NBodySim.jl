using LinearAlgebra
using GLMakie

mutable struct Body
    r::Vector{Float64} # location
    v::Vector{Float64} # velocity
    mass::Float64
end

function move!(b::Body, f::Vector{Float64}, dt::Float64)
    # F=ma -> a = F/m -> multiply by dt to get m/s^2 -> m/s
    a = f ./ b.mass
    b.v = b.v + (a .* dt)
    b.r = b.r + (b.v .* dt)
end


function forceFrom(b::Body, bOther::Body)
    G = 6.67e-11
    delta = bOther.r .- b.r
    distance = norm(delta)
    magnitude = (G * b.mass * bOther.mass) / (distance * distance)
    return (delta ./ norm(delta)) .* magnitude
end

function draw(b::Body, ax, radius)
    poly!(ax, Circle(Point2f(b.r[1], b.r[2]), radius * 0.02), color = :blue)
end
