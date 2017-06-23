import TakingBroadcastSeriously: unfuse, broadcast_
using Base.Test

# A fake custom array type

struct FooArray{T,N} <: AbstractArray{T,N}
  data::Array{T,N}
end

Base.size(xs::FooArray, a...) = size(xs.data, a...)
Base.getindex(xs::FooArray, a...) = getindex(xs.data, a...)

# Unfuse stuff

unfuse(FooArray)

blist = []

function broadcast_(::typeof(sin), xs::FooArray)
  push!(blist, sin)
  FooArray(sin.(xs.data))
end

function broadcast_(::typeof(cos), xs::FooArray)
  push!(blist, cos)
  FooArray(cos.(xs.data))
end

xs = rand(5)
xs′ = FooArray(xs)

cos.(sin.(xs)) == cos.(sin.(xs′))

@test blist == [sin, cos]
