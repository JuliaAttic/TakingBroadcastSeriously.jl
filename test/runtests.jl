import TakingBroadcastSeriously: @unfuse, broadcast_
using Base.Test

# A fake custom array type

struct FooArray{T,N} <: AbstractArray{T,N}
  data::Array{T,N}
end

Base.size(xs::FooArray, a...) = size(xs.data, a...)
Base.getindex(xs::FooArray, a...) = getindex(xs.data, a...)

# Unfuse stuff

@unfuse FooArray

blist = []

function broadcast_(::typeof(sin), xs::FooArray)
  push!(blist, sin)
  FooArray(sin.(xs.data))
end

function broadcast_(::typeof(cos), xs::FooArray)
  push!(blist, cos)
  FooArray(cos.(xs.data))
end

@testset "Seriously" begin
    xs = rand(5)
    xs′ = FooArray(xs)

    @test cos.(sin.(xs)) == cos.(sin.(xs′))

    @test blist == [sin, cos]

    @test xs.^3.0 == xs′.^3.0
    @test 50 .* xs == 50 .* xs′
    @test xs.^3 == xs′.^3
end
