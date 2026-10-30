using GLMakie

include("body.jl")


mutable struct Universe
    bodies::Vector{Body}
    radius::Float64
    ax
    screen
end

function Universe(filepath::String)
    lines = readlines(filepath)
    n = parse(Int64, lines[1])
    radius = parse(Float64, lines[2])
    fig = Figure(size=(800, 800))
    ax = Axis(fig[1,1], limits = (-radius, radius, -radius, radius), aspect = DataAspect())
    hidedecorations!(ax)
    screen = display(fig)

    bodies = Vector{Body}()
    u = Universe(bodies,radius, ax, screen)

    for l in lines[3:end]
        rx, ry, vx, vy, mass = parse.(Float64, split(l))
        r = [rx, ry]
        v = [vx, vy]
        push!(bodies, Body(r, v, mass))
    end
    return u
end

function increaseTime(u::Universe, dt::Float64)
    n = length(u.bodies)
    f = [[0.0, 0.0] for _ in 1:n]
    for i in 1:n
        for j in 1:n
            if i != j
                bodyi = u.bodies[i]
                bodyj = u.bodies[j]
                f[i] = f[i] .+ forceFrom(bodyi, bodyj)
            end
        end
    end

    for i in 1:n
        move!(u.bodies[i], f[i], dt)
    end
end


function draw(u::Universe)
    min_mass = minimum(b.mass for b in u.bodies)

    for body in u.bodies
        draw(body, u.ax, u.radius * (1+log10(1+log10((body.mass/min_mass)))))
    end
end


function (@main)(args)
    filename = args[1]
    dt = parse(Float64, args[2])
    universe = Universe(filename)
    while isopen(universe.screen) 
        increaseTime(universe, dt)
        empty!(universe.ax)
        draw(universe)
        sleep(1/50)
    end
end




