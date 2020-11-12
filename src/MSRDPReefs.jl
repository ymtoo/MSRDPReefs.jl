module MSRDPReefs

using AcousticFeatures
using CSV
using DataFrames
using Dates
using DSP
using FindPeaks1D
using MemorylessNonlinearities
using ProgressMeter
using Requires
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

    # preprocess
    removedc_whiten_lpf_resample,

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
    LazyEpisodic,
    load_peakdetect,
    countepisodic,
    saveepisodictowav_wavread

include("utils.jl")
include("preprocess.jl")
include("msrdpreefs.jl")
include("episodic.jl")

function __init__()
    @require PlotlyJS="f0f68f2c-4968-5e81-91da-67840de0976a" begin
        include("plotting.jl")
    end
end

end