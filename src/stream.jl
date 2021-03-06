# Stream management

export
    CuStream, CuDefaultStream, synchronize, destroy


typealias CuStream_t Ptr{Void}

immutable CuStream
    handle::CuStream_t
end

Base.unsafe_convert(::Type{CuStream_t}, s::CuStream) = s.handle
Base.:(==)(a::CuStream, b::CuStream) = a.handle == b.handle

function CuStream(flags::Integer=0)
    handle_ref = Ref{CuStream_t}()
    @apicall(:cuStreamCreate, (Ptr{CuStream_t}, Cuint),
                              handle_ref, flags)
    CuStream(handle_ref[])
end

CuDefaultStream() = CuStream(convert(CuStream_t, C_NULL))

destroy(s::CuStream) = @apicall(:cuStreamDestroy, (CuStream_t,), s)

synchronize(s::CuStream) = @apicall(:cuStreamSynchronize, (CuStream_t,), s)
