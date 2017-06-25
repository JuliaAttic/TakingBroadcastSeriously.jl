module TakingBroadcastSeriously

using Base.Broadcast: broadcast_c, containertype

broadcast_(f, A, Bs...) = broadcast_c(f, containertype(A, Bs...), A, Bs...)

struct Broadcasted{T}
  x::T
end

unwrap(w::Broadcasted) = w.x

# We must hack each function we want to use with un-fused broadcasting.
for f in :[sin, cos, +, -, *, /].args
  @eval Base.$f(a::Broadcasted...) = Broadcasted(broadcast_($f, unwrap.(a)...))
end

macro unfuse(T)
  T = esc(T)
  quote
    Base.broadcast(f, A::$T, Bs...) = f(Broadcasted(A), Broadcasted.(Bs)...) |> unwrap
    Base.broadcast(f, A, B::$T, Cs...) = f(Broadcasted(A), Broadcasted(B), Broadcasted.(Cs)...) |> unwrap
    Base.broadcast(f, A::$T, B::$T, Cs...) = f(Broadcasted(A), Broadcasted(B), Broadcasted.(Cs)...) |> unwrap
  end
end

end # module
