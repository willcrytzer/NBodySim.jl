using Test
using LinearAlgebra
using GLMakie

include("../body.jl")

@testset "Body" begin
    @testset "construction" begin
        b = Body([0.0, 0.0], [1.0, 2.0], 3.5)
        @test b.r == [0.0, 0.0]
        @test b.v == [1.0, 2.0]
        @test b.mass == 3.5
    end

    @testset "move!" begin
        # No net force -> velocity and position stay put (r += v * dt)
        b = Body([0.0, 0.0], [1.0, 0.0], 5.0)
        move!(b, [0.0, 0.0], 2.0)
        @test b.v ≈ [1.0, 0.0]
        @test b.r ≈ [2.0, 0.0]

        # F = ma -> a = F/m -> v += a * dt -> r += v * dt
        b = Body([0.0, 0.0], [0.0, 0.0], 2.0)
        move!(b, [4.0, 0.0], 2.0)
        @test b.v ≈ [4.0, 0.0]   # (4.0 / 2.0) * 2.0
        @test b.r ≈ [8.0, 0.0]   # (4.0) * 2.0, using the updated velocity
    end

    @testset "forceFrom" begin
        G = 6.67e-11
        b = Body([0.0, 0.0], [0.0, 0.0], 1.0)
        bOther = Body([3.0, 0.0], [0.0, 0.0], 2.0)

        F = forceFrom(b, bOther)

        delta = bOther.r .- b.r
        magnitude = (G * b.mass * bOther.mass) / (norm(delta) * norm(delta))
        @test norm(F) ≈ magnitude
        @test F ≈ (delta ./ norm(delta)) .* magnitude

        # Force on b points from b toward bOther, and vice versa
        @test F[1] ≈ magnitude
        @test forceFrom(bOther, b)[1] ≈ -magnitude
    end

    @testset "draw" begin
        b = Body([0.5, 0.5], [0.0, 0.0], 1.0)
        fig = Figure()
        ax = Axis(fig[1, 1])
        @test_nowarn draw(b, ax)
    end
end
