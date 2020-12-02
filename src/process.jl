"""
Preprocess acoustic data for episodic detection.
"""
function removedc_whiten_lpf_resample(x::AbstractVector{T}, 
                                      fs=acousticsamplingrate(); 
                                      lpfreq=4800, 
                                      rate=1//10) where {T<:Real}
    x = removedc(x .- median(x))
    x = whiten(x, 8192, 0)
    σ = mad(x)
    x = MemorylessNonlinearities.filt(CauchyNL(3 * σ), x)
#    d = AlphaStableDistributions.fit(SymmetricAlphaStable, x)
#    x = MemorylessNonlinearities.filt(SαS(d.α, d.scale, d.location), x)
    bpf = digitalfilter(Bandpass(10, lpfreq; fs=fs), FIRWindow(hanning(16383)))
    resample(filtfilt(bpf, x), rate)
end


function _getfeatures(wavpath::AbstractString, 
                      gs::Vector{T}, 
                      sensitivity, 
                      gain) where {T<:Function}
    try
        x, fs = wavread(wavpath)
        x = vec(x)
        x = removedc(x .- median(x))
    catch
        @warn "Unable to read $(wavpath)"
        return [missing]
    end
    x = pressure(x, sensitivity, gain)
    features = [g(x) for g in gs] 
    vcat(features...)
end
"""
Compute acoustic features and append to `feadf` dataframe.

Metadata `mdata` provides paths to read WAV files for acoustic 
feature computation using input functions `gs` which are labeled
as `feasymbols`. The computed features are appended to `feadf` 
accordingly.

See also: [`getfeatures`](@ref)
"""
_createtempdataframe(mdata::Metadata) = DataFrame(Datetime=mdata.df[!,:datetime], Site=mdata.site)
_createtempdataframe(mdata::MetadataAll) = DataFrame(Datetime=mdata.df[!,:datetime], Site=mdata.df[!,:site])
function getfeatures!(feadf::AbstractDataFrame, 
                      mdata::Union{Metadata,MetadataAll}, 
                      gs::Vector{T}, 
                      feasymbols::Vector{Symbol}; 
                      map=map) where {T<:Function}
    numrows = size(mdata.df, 1)
    numfeas = length(feasymbols)
    xs = @showprogress map((x, y, z) -> _getfeatures(x, gs, y, z), 
                           mdata.df[:,:wavpath], 
                           mdata.df[:,:sensitivity], 
                           mdata.df[:,:gain]) 
    l = maximum(length.(xs))
    idxs = findall(x -> ismissing(first(x)), xs)
    for idx in idxs
        xs[idx] = fill(missing, l)
    end
    X = hcat(xs...)
    feadftmp = _createtempdataframe(mdata)                
    for (i, feasymbol) in enumerate(feasymbols)
        insertcols!(feadftmp, i+2, feasymbol => X[i,:])
    end
    samenames = intersect(names(feadf), names(feadftmp))
    if names(feadf) == samenames
        outerjoin(feadf, feadftmp; on=samenames)
    else
        innerjoin(feadf, feadftmp; on=samenames)
    end
end
"""
Compute acoustic features as a dataframe. 

Metadata `mdata` provides paths to read WAV files for acoustic 
feature computation using input functions `gs` which are labeled
as `feasymbols`.

See also: [`getfeatures!`](@ref)
"""
function getfeatures(mdata::Union{Metadata,MetadataAll}, 
                     gs::Vector{T}, 
                     feasymbols::Vector{Symbol}; 
                     map=map) where {T<:Function}
    feadf = _createtempdataframe(mdata)
    getfeatures!(feadf, mdata, gs, feasymbols; map=map)
end

function getimpulsestats(x) 
    hpf = digitalfilter(Highpass(2000; fs=ACOUSTICSAMPLINGRATE), FIRWindow(hanning(127)))
    x = filtfilt(hpf, x)
    sc = Score(ImpulseStats(ACOUSTICSAMPLINGRATE, 10, 1e-3), x; winlen=960000, noverlap=0, showprogress=false)
    vec(median(sc.s; dims=2))
end

function getentropy(x)
    sc = Score(Entropy(9600, 4800, ACOUSTICSAMPLINGRATE), x; winlen=960000, noverlap=0, showprogress=false)
    vec(median(sc.s; dims=2))
end

function getzerocrossingrate(x)
    sc = Score(ZeroCrossingRate(), x; winlen=960000, noverlap=0, showprogress=false)
    vec(median(sc.s; dims=2))
end
