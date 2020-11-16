using MSRDPReefs
#import MSRDPReefs: getlogpaths, Metadata, moonphase
using DataFrames, Dates, SignalAnalysis, Test, WAV

DTRANGES = Dict(
    "site-1" => [(DateTime(2020, 1, 31, 11, 50, 0), DateTime(2020, 2, 1, 0, 6, 0))],
    "site-2" => [(DateTime(2020, 1, 31, 11, 50, 0), DateTime(2020, 2, 1, 0, 6, 0))]
)

@testset "Metadata" begin
    sitepaths = ["./recordings/site-1", "./recordings/site-2"]
    logpaths = ["./recordings/site-1/2020-01/LOG.CSV", "./recordings/site-2/2020-01/LOG.CSV"]

    dtranges = [(DateTime(2019, 6, 1, 0, 0, 0), DateTime(2020, 4, 30, 23, 59, 59))]
    for (sitepath, logpath) in zip(sitepaths, logpaths)
        @test getlogpaths(sitepath, dtranges)[1] == logpath
    end

    root = "./recordings"
    dirs = readdir(root)
    paths = [joinpath(root, dir) for dir in dirs]
    sites = ["site-1", "site-2"]
    depth = [0.06, 0.06, 0.06, 0.02]
    temperature = [27.87, 28.28, 28.29, 27.29]
#    lightintensity = [RGB{Float64}(3827.0,3801.0,3376.0), RGB{Float64}(645.0, 733.0, 712.0), RGB{Float64}(644.0, 732.0, 710.0), RGB(620.0, 701.0, 601.0)]
    red = [3827.0, 645.0, 644.0, 620.0]
    green = [3801.0, 733.0, 732.0, 701.0]
    blue = [3376.0, 712.0, 710.0, 601.0]
    mp = [3, 3, 3, 3]
    for (path, site) in zip(paths, sites)
        mdata = Metadata(path, dtranges)
        @test mdata.site == site
        @test mdata.df[:, :depth] == depth
        @test mdata.df[:, :temperature] == temperature
        @test mdata.df[:, :redlight] == red
        @test mdata.df[:, :greenlight] == green
        @test mdata.df[:, :bluelight] == blue
        @test mdata.df[:, :moonphase] == mp
    end
end

@testset "episodic" begin
    df = DataFrame(:site => ["test", "test"], :wavpath => ["./recordings/site-1/2020-01/2020-01/20200131T115001.wav", "./recordings/site-1/2020-01/2020-01/20200131T115501.wav"], :startind => [10000, 50000], :stopind => [30000, 90000], :score => [1, 1])
    x = LazyEpisodic(df)
    @test size(x) == (2,)
    @test size(x, 2) == size(x, 100) == 1
    @test length(x) == size(x, 1) == 2
    @test ndims(x) == 1
    @test length.(x) == [20001, 40001]
    @test vec(wavread(df.wavpath[1], subrange=df.startind[1]:df.stopind[1])[1]) == x[1]
    @test vec(wavread(df.wavpath[2], subrange=df.startind[2]:df.stopind[2])[1]) == x[2]
end

@testset "utils" begin
    dt = DateTime(2009, 1, 26)
    @test moonphase(dt) == 8#"waning crescent (decreasing from full)"

    nbits = 16
    vref = 1.0
    xvolt = vref .* real(samples(cw(64, 1, 512)))
    xbit = xvolt .* (2 ^ (nbits-1))
    sensitivity = 0
    gain = 0
    p1 = pressure(xvolt, sensitivity, gain)
    p2 = pressure(xbit, sensitivity, gain; volt_params=(nbits, vref))
    @test p1 == p2 
end

@testset "datacollectionprogress" begin
    root = "/home/arl/Data/reefwatch/recordings"
    println(datacollectionprogress(root))
end
