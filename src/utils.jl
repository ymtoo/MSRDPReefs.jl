const ACOUSTICSAMPLINGRATE = 96000
"""
Get samling rate of the acoustic data
"""
acousticsamplingrate() = ACOUSTICSAMPLINGRATE

"""
Calculate the moon phase of a given datetime.

    1 = 🌑 new (totally dark)
    2 = 🌒 waxing crescent (increasing to full)
    3 = 🌓 in its first quarter (increasing to full)
    4 = 🌔 waxing gibbous (increasing to full)
    5 = 🌕 full (full light)
    6 = 🌖 waning gibbous (decreasing from full)
    7 = 🌗 in its last quarter (decreasing from full)
    8 = 🌘 waning crescent (decreasing from full)

Reference:
https://www.daniweb.com/programming/software-development/code/453788/moon-phase-at-a-given-date-python
"""
function moonphase(dt::DateTime)
    ages = [18, 0, 11, 22, 3, 14, 25, 6, 17, 28, 9, 20, 1, 12, 23, 4, 15, 26, 7]
    offsets = [-1, 1, 0, 1, 2, 3, 4, 5, 7, 7, 9, 9]
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    yeardt, monthdt, daydt = year(dt), month(dt), day(dt)
    if daydt == 31
        daydt = 1
    end
    days_into_phase = ((ages[((yeardt + 1) % 19) + 1] + ((daydt + offsets[monthdt]) % 30) + (yeardt < 1900)) % 30)
    index = trunc(Int, (days_into_phase + 2) * 16/59.0) + 1
    if index > 8
        index = 8
    end
    index
end

"""
Read all the WAV files in the directory.
"""
function wavreadall(savedir::AbstractString, T::DataType=Float32)
    filenames = sort(readdir(savedir))
    _, fs = wavread(joinpath(savedir, filenames[1]), subrange=1)
    xs = map(filenames) do filename
        x, fs1 = wavread(joinpath(savedir, filename))
        fs1 != fs && throw(ErrorException("Sampling rate has to be the same for all WAV files."))
        T.(vec(x))
    end
    xs, fs
end

"""
Convert an integer vector to a string
"""
function vec2string(x::AbstractVector{T}) where T<:Real
    s = string(x)[2:end-1]
    filter(y -> !isspace(y), s)
end

"""
Convert a string to an integer vector
"""
function string2vec(DT::DataType, x::AbstractString)
    parse.(DT, split(x, ","))
end

"""
Normalize values of an array to be between `minval` and `maxval`.
"""
function normalize(x::AbstractArray{T}, minval::T, maxval::T) where {T<:Real} 
    minval .+ (maxval - minval) .* (x .- minimum(x)) ./ (maximum(x) .- minimum(x))
end

# """
# Inverse Short Time Fourier Transform.
# """
# function istft(X::AbstractMatrix{Complex{T}}, 
#     n::Int, 
#     noverlap::Int; 
#     onesided::Bool=true, 
#     window::Union{Function,AbstractVector,Nothing}=nothing) where {T<:AbstractFloat}
#     (window === nothing) && (window = rect)
#     win, norm2 = Periodograms.compute_window(window, n)

#     nstep = n - noverlap
#     nseg = size(X, 2)
#     outputlength = n + (nseg-1) * nstep

#     iX = onesided ? irfft(X, n, 1) : ifft(X, 1)
#     iX .*= win
#     x = zeros(eltype(iX), outputlength)
#     norm = zeros(T, outputlength)
#     for i = 1:nseg
#     x[1+(i-1)*nstep:n+(i-1)*nstep] += iX[:,i]
#     norm[1+(i-1)*nstep:n+(i-1)*nstep] += win .^ 2
#     end

#     (sum(norm[n÷2:end-n÷2] .> 1e-10) != length(norm[n÷2:end-n÷2])) && (
#     @warn "NOLA condition failed, STFT may not be invertible")
#     x .*= nstep/norm2
# end

# """
# Spectral whitening.
# """
# function whiten(x::AbstractVector{T}, 
#      n::Int, 
#      noverlap::Int; 
#      window::Union{Function,AbstractVector,Nothing}=nothing,
#      γ=1) where {T}
#     xstft = stft(x, n, noverlap; window=window)
#     mag = log.(abs.(xstft .+ eps(T)))
#     mag .-= γ * mean(mag; dims=2)
#     istft(exp.(mag) .* exp.(im .* angle.(xstft)), n, noverlap; window=window) 
# end