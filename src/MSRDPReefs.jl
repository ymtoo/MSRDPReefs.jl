module MSRDPReefs

using CSV
using Clustering
using DataFrames
using Dates
using DSP
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

    # clustutils
    visualizeclusters,
    specgram_scatter,

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
    countepisodic,
    getepisodicmetadata

include("utils.jl")
include("data.jl")
include("process.jl")
include("episodic.jl")

function __init__()
    @require PlotlyJS="f0f68f2c-4968-5e81-91da-67840de0976a" begin
        include("plotting.jl")
    end
    @require AbstractPlotting = "537997a7-5e4e-5d89-9595-2241ea00577e" begin
        include("clustutils.jl")
    end
end

end