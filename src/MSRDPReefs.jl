module MSRDPReefs

using AcousticFeatures
using CSV
using DataFrames
using Dates
using DSP
using FFTW
using FindPeaks1D
using MemorylessNonlinearities
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

    # process
    removedc_whiten_lpf_resample,
    getfeatures,
    getfeatures!,
    getimpulsestats,
    getentropy,
    getzerocrossingrate,

    #msrdpreefs
    acousticsamplingrate,
    datacollectionprogress,
    filterfeatures!,
    getlogpaths,
    getpaths,
    Metadata,
    MetadataAll,
    SITEDTRANGES,

    # episodic
    findepisodic,
    load_peakdetect,
    countepisodic,

include("utils.jl")
include("msrdpreefs.jl")
include("process.jl")
include("episodic.jl")

function __init__()
    @require PlotlyJS="f0f68f2c-4968-5e81-91da-67840de0976a" begin
        include("plotting.jl")
    end
end

end