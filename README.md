# TakingBroadcastSeriously

This package implements a hack around broadcast fusion for custom array types. See [the tests](test/runtests.jl) for example usage. You need to:

1. Call `unfuse(ArrayType)` to intercept broadcast calls.
2. Make sure any function you want to use inside broadcast is on the list [here](src/TakingBroadcastSeriously.jl).
3. Overload `broadcast_(f, xs...)` for your array type.
4. Cross your fingers and hope this holds up for the next six months.
