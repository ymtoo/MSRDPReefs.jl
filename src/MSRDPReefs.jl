module MSRDPReefs

using CSV
using DataFrames
using Dates
using DSP
using FFTW
using FindPeaks1D
using ProgressMeter
using Requires
using SignalAnalysis
using Statistics
using StatsBase
using WAV

export

    # utils
    moonphase,
    vec2string,
    string2vec,
    wavreadall,
    pressure,

    # data
    acousticsamplingrate,
    datacollectionprogress,
    getlogpaths,
    getpaths,
    metadata,
    SITEDTRANGES,

    # process
    removedc_whiten_lpf_resample,
    getfeatures,
    getfeatures!,
    getimpulsestats,
    getentropy,
    getzerocrossingrate,

    # episodic
    findepisodic,
    load_peakdetect,
    countepisodic

include("utils.jl")
include("data.jl")
include("process.jl")
include("episodic.jl")

function __init__()
    @require PlotlyJS="f0f68f2c-4968-5e81-91da-67840de0976a" begin
        include("plotting.jl")
    end
end

end