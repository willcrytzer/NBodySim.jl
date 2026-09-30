using GLMakie

RADIUS = 0.05
DT = 20.0

fig = Figure(size=(600, 600))
ax = Axis(fig[1, 1], limits = (-1, 1, -1, 1), aspect = DataAspect())
hidedecorations!(ax)

screen = display(fig)

rx = 0.480
ry = 0.860

vx = 0.05
vy = 0.04

while isopen(screen)
    if abs(rx+vx) + RADIUS > 1.0
        global vx = -vx
    end
    if abs(ry+vy) + RADIUS > 1.0
        global vy = -vy
    end
    global rx = rx + vx
    global ry = ry + vy

    empty!(ax)
    poly!(ax, Circle(Point2f(rx, ry), RADIUS), color = :red)
    sleep(1/50)
end
