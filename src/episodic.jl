"""
Find episodic signals in the recordings based on myriad score function.
"""
function load_peakdetect(wavpath; 
                         winlen, 
                         noverlap, 
                         k, 
                         width, 
                         distance, 
                         preprocess, 
                         site, 
                         fs, 
                         savedir=nothing)
    x, _ = wavread(wavpath)
    wavfile = split(wavpath, "/")[end]
    dir = join([wavfile[1:4], wavfile[5:6]], "-")
    dt = DateTime(wavfile[1:end-4], "yyyymmddTHHMMSS")
    # x = x[:,1]
    y = preprocess(vec(x))
#    p = quantile.(Ref(y), (0.05, 0.95))
#    yc = clamp.(y, p[1], p[2])
    sc = Score(Energy(),
               y;
               winlen=winlen,
               noverlap=noverlap,
               padtype=:reflect,
               map=map,
               showprogress=false)
    s = vec(sc.s)
    center = Statistics.median(s)
    height = center+k*mad(s, center=center, normalize=false)
    pkindices, properties = findpeaks1d(s;
                                        height=height,
                                        width=width,
                                        distance=distance)
    npeaks = length(pkindices)
#    data = Matrix{Any}(undef, npeaks, 3)
    savepaths = Vector{String}(undef, npeaks)
    datetimes = Vector{DateTime}(undef, npeaks)
    startinds = Vector{Int}(undef, npeaks)
    stopinds = Vector{Int}(undef, npeaks)
    pks = Vector{eltype(sc.s)}(undef, npeaks)
    winleniseven = iseven(winlen)
    for i in 1:npeaks
        startinds[i] = sc.indices[trunc(Int, properties["leftips"][i])]
        datetimes[i] = dt + Second(trunc(Int, startinds[i]/fs))
        winleniseven && (startinds[i] += 1) # consistent with the Subsequence implementation
        stopinds[i] = sc.indices[trunc(Int, properties["rightips"][i])]
        pks[i] = sc.s[pkindices[i],1]
        if savedir !== nothing
            filename = split(wavpath, "/")[end][1:end-4] * "-epi-$(lpad(i, 3, "0")).wav"
            savepaths[i] = joinpath(savedir, filename)
            episignal = normalize(y[startinds[i]:stopinds[i]], -0.5, 0.5)
            wavwrite(episignal .- mean(episignal), savepaths[i]; Fs=fs)
        end
#        data[i,:] = [startind, stopind, sc.s[pkindices[i],1]]
    end
#    isempty(startinds) ? nothing : [site, wavpath, vec2string(startinds), vec2string(stopinds), vec2string(pks)]
    npeaks == 0 ? nothing : [site, wavpath, savepaths, datetimes, startinds, stopinds, pks]
end
function findepisodic(f, wavpaths::AbstractVector{String}; map=map, showprogress=true)
    # site = split.(path, "/")[end]
    # dtranges = SITEDTRANGES[site]
    # mdata = Metadata(path, dtranges)
    # wavpaths = mdata.df[!, :wavpath]
    if showprogress
        vdata = @showprogress map(x -> f(x), wavpaths)
    else
        vdata = map(x -> f(x), wavpaths)
    end
    epidf = DataFrame(site=String[],
                      wavpath=String[],
                      savepath=String[],
                      datetime=DateTime[],
                      startind=Int[],
                      stopind=Int[],
                      score=Float64[])
    for data in vdata
        if data !== nothing
            for (savepath, datetime, startind, stopind, pk) in zip(data[3], data[4], data[5], data[6], data[7])
                push!(epidf.site, data[1])
                push!(epidf.wavpath, data[2])
                push!(epidf.savepath, savepath)
                push!(epidf.datetime, datetime)
                push!(epidf.startind, startind)
                push!(epidf.stopind, stopind)
                push!(epidf.score, pk)
            end
        end
    end
    epidf
end
function findepisodic(f, path::AbstractString; map=map, showprogress=true)
    site = split.(path, "/")[end]
    dtranges = SITEDTRANGES[site]
    mdata = Metadata(path, dtranges)
    wavpaths = mdata.df[!, :wavpath]
    findepisodic(f, wavpaths; map=map, showprogress=true)
end

"""
Count the number of detected episodic signals.
"""
countepisodic(epidf::DataFrame) = sum(length.(epidf[:, :startind]))


"""
Treat segments of WAV files (detected episodic signals in a dataframe) as a lazy vector of vectors stored on disk.
"""
struct LazyEpisodic{T,S<:Tuple,FS} <: AbstractVector{AbstractVector{T}}
    df::DataFrame
    size::S
    fs::FS
    preprocess::Function
end
function LazyEpisodic(df::DataFrame; preprocess=x->x)
    r, fs = wavread(df.wavpath[1], subrange=1)
    T = eltype(Base.return_types(preprocess, (Vector{eltype(r)},))[1])#Vector{eltype(r)}
    s = (nrow(df),)
    LazyEpisodic{T,typeof(s),typeof(fs)}(df, s, fs, preprocess)
end

Base.size(f::LazyEpisodic) = f.size
Base.size(f::LazyEpisodic, i::UInt) = (i==1) ? f.size[i] : 1
Base.length(f::LazyEpisodic) = f.size[1]

Base.getindex(f::LazyEpisodic{T,S,FS}, i::Integer) where {T,S,FS} = f.preprocess(vec(wavread(f.df.wavpath[i], subrange=f.df.startind[i]:f.df.stopind[i])[1]))::Array{T}
Base.firstindex(f::LazyEpisodic{T,S,FS}) where {T,S,FS} = 1
Base.lastindex(f::LazyEpisodic{T,S,FS}) where {T,S,FS} = length(f)

function Base.getindex(f::LazyEpisodic{T,S,FS}, i::UnitRange) where {T,S,FS}
    newdf = f.df[i,:]
    s = (nrow(newdf),)
    LazyEpisodic{T,typeof(s),typeof(f.fs)}(newdf, s, f.fs, f.preprocess)
end

function Base.collect(CT::DataType, f::LazyEpisodic{T,S,FS}; map=map, showprogress=true) where {T,S,FS}
    if showprogress
        @showprogress map(i -> CT.(f[i]), 1:length(f))
    else
        map(i -> CT.(f[i]), 1:length(f))
    end
end
Base.collect(f::LazyEpisodic{T,S,FS}; kwargs...) where {T,S,FS} = collect(T, f; kwargs...)

Base.eltype(f::LazyEpisodic{T}) where {T} = T
Base.ndims(f::LazyEpisodic{T}) where {T} = 1

Base.show(io::IO, f::LazyEpisodic{T,S,FS}) where {T,S,FS} = println(io, "LazyEpisodic{$(T), $(f.size), $(FS)}: ", f.df)


# """
# Save episodic signals to WAV files
# """
# function saveepisodictowav(x::AbstractVector, filename::String; fs::Real, isscale::Bool, site::String, savedir::String)
#     isscale && (x = 2 .* (x .- minimum(x)) ./ (maximum(x) .- minimum(x)) .- 1)
#     #savepath = joinpath(savedir, site * "-epi-$(lpad(index, 7, "0")).wav")
#     savepath = joinpath(saveepisodictowav, filename)
#     wavwrite(x, savepath; Fs=fs)
# end
# function saveepisodictowav_wavread(path::AbstractString, 
#                                    startinds::Integer, 
#                                    stopinds::Integer,
#                                    site::String;  
#                                    fs::Real,
#                                    isscale::Bool, 
#                                    savedir::String)
#     x, fstmp = wavread(path)
#     for (index, (startind, stopind)) in enumerate(zip(startinds, stopinds))
#         xt = lpf_downsample_removedc_zeromean(vec(x), fstmp)[startind:stopind]
#         spec = spectrogram(xt, 128, 64; fs=fs)
#         Px = spectrumflatten(log.(spec.power), size(spec.power,1); dims=1)
#         maxfreq = spec.freq[argmax(maximum(Px, dims=2))]
#         if maxfreq < 1200
#             lpf = digitalfilter(Lowpass(1200; fs=fs), FIRWindow(hanning(127)))
#             y = filtfilt(lpf, xt)
#         else
#             y = lowrankfilter(xt, Int(fs*0.01); lag=10)
#         end
#         filename = site * "-" * split(path, "/")[end][1:end-4] * "-epi-$(lpad(index, 2, "0")).wav"
#         saveepisodictowav(y, filename; fs=fs, isscale=isscale, site=site, savedir=savedir)
#     end
# end
# function saveepisodictowav_wavread(epidf::DataFrame;
#                                    fs::Real, 
#                                    isscale::Bool, 
#                                    map::Function,
#                                    savedir::String,
#                                    showprogress=true)
#     xs = []
#     for (i, row) in enumerate(eachrow(epidf))
#         push!(xs, [row[:wavpath],
#                    row[:startind],
#                    row[:stopind],
#                    row[:site]])
#     end
#     if showprogress
#         @showprogress map((args)->saveepisodictowav_wavread(args...; fs=fs, isscale=isscale, savedir=savedir), xs)
#     else
#         map((args)->saveepisodictowav_wavread(args...; fs=fs, isscale=isscale, savedir=savedir), xs)
#     end
# end
