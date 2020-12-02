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
    println(wavpath)
    try
        x, fs = wavread(wavpath)
    catch
        @warn "Unable to read $(wavpath)"
        return [missing for g in gs]
    end
    x = pressure(vec(x), sensitivity, gain)
    [g(x) for g in gs]
end
function getfeatures!(feadf::AbstractDataFrame, 
                      mdata::Metadata, 
                      gs::Vector{T}, 
                      feasymbols::Vector{Symbol}; 
                      map=map) where {T<:Function}
    numrows = size(mdata.df, 1)
    numfeas = length(feasymbols)
    X = @showprogress map((x, y, z) -> _getfeatures(x, gs, y, z), 
                          mdata.df[:,:wavpath], 
                          mdata.df[:,:sensitivity], 
                          mdata.df[:,:gain])
    for (i, feasymbol) in enumerate(feasymbols)
        insertcols!(feadf, i+2, feasymbol => X[i,:])
    end
    feadf
end
"""
Get acoustic features.
"""
function getfeatures(mdata::Metadata, 
                     gs::Vector{T}, 
                     feasymbols::Vector{Symbol}; 
                     map=map) where {T<:Function}
    # numrows = size(mdata.df, 1)
    # numfeas = length(feasymbols)
    # X = map(x -> _getfeatures(x, gs, sensitivity, gain), wavpaths)
    # X =  SharedArray{Float64,2}((numrows, numfeas))#Array{Union{DateTime, Float64, Int64}, 2}(undef, numrows, numfeas+1)#
    # @showprogress "Computing..." @distributed for i in 1:numrows
    #     p, fs = wavreadtopressure(mdata.df[i, :wavpath], sensitivity, gain)
    #     xtmp = []
    #     for g in gs
    #         append!(xtmp, g(p))
    #     end
    #     X[i, :] = xtmp
    # end
    feadf = DataFrame(Datetime=mdata.df[!, :datetime], Site=mdata.site)
    getfeatures!(feadf, mdata, gs, feasymbols; map=map)
    # for (i, feasymbol) in enumerate(feasymbols)
    #     insertcols!(feadf, i+2, feasymbol => X.s[i, :])
    # end
    # feadf
end

function getimpulsestats(x) 
    hpf = digitalfilter(Highpass(2000; fs=acousticsamplingrate()), FIRWindow(hanning(127)))
    x = filtfilt(hpf, x)
    sc = Score(ImpulseStats(acousticsamplingrate(), 10, 1e-3), x; winlen=960000, noverlap=0, showprogress=false)
    median(vec(sc.s))
end