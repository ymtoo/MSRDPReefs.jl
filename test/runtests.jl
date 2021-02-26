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
    sensitivities = [[-179.80,-179.80,-179.80,-179.80],
                     [-179.00,-179.00,-179.00,-179.00]]
    gains = [[16.77, 16.77, 16.77, 16.77],
             [16.72, 16.72, 16.72, 16.72]]
    paths = getpaths(root)
    sites = [["site-1", "site-1", "site-1", "site-1"], 
             ["site-2", "site-2", "site-2", "site-2"]]
    sensors = [["LS1-123456","LS1-123456","LS1-123456","LS1-123456"],
               ["LS1-234567","LS1-234567","LS1-234567","LS1-234567"]]
    depth = [0.06, 0.06, 0.06, 0.02]
    temperature = [27.87, 28.28, 28.29, 27.29]
    red = [3827.0, 645.0, 644.0, 620.0]
    green = [3801.0, 733.0, 732.0, 701.0]
    blue = [3376.0, 712.0, 710.0, 601.0]
    mp = [3, 3, 3, 3]
    divers = [[true, false, false, false], [false, false, false, true]]
    for (path, site, sensor, sensitivity, gain, diver) ∈ zip(paths, sites, sensors, sensitivities, gains, divers)
        mdatadf = MSRDPReefs._metadata(path, dtranges)
        @test mdatadf.Site == site
        @test mdatadf.Sensor == sensor
        @test mdatadf[!,:Sensitivity] == sensitivity
        @test mdatadf[!,:Gain] == gain
        @test mdatadf[!,:Depth] == depth
        @test mdatadf[!,:Temperature] == temperature
        @test mdatadf[!,:Redlight] == red
        @test mdatadf[!,:Greenlight] == green
        @test mdatadf[!,:Bluelight] == blue
        @test mdatadf[!,:Moonphase] == mp
        @test mdatadf[!,:Diver] == diver
    end
end

# @testset "episodic" begin
#     df = DataFrame(:site => ["test", "test"], :wavpath => ["./recordings/site-1/2020-01/2020-01/20200131T115001.wav", "./recordings/site-1/2020-01/2020-01/20200131T115501.wav"], :startind => [10000, 50000], :stopind => [30000, 90000], :score => [1, 1])
#     x = LazyEpisodic(df)
#     @test size(x) == (2,)
#     @test size(x, 2) == size(x, 100) == 1
#     @test length(x) == size(x, 1) == 2
#     @test ndims(x) == 1
#     @test length.(x) == [20001, 40001]
#     @test vec(wavread(df.wavpath[1], subrange=df.startind[1]:df.stopind[1])[1]) == x[1]
#     @test vec(wavread(df.wavpath[2], subrange=df.startind[2]:df.stopind[2])[1]) == x[2]
# end

@testset "utils" begin
    dt = DateTime(2009, 1, 26)
    @test moonphase(dt) == 8#"waning crescent (decreasing from full)"

end

@testset "datacollectionprogress" begin
    root = "recordings"
    df = datacollectionprogress(root)
    df[:, "D1 (%)"] = round.(df[:, "D1 (%)"], digits=5)
    dftrue = DataFrame("Site" => ["site-1","site-2"], 
                       "D1 (%)" => Union{Missing,Real}[1.70139,1.70139],
                       "D2 (%)" => Union{Missing,Real}[missing,missing],
                       "D3 (%)" => Union{Missing,Real}[missing,missing],
                       "D4 (%)" => Union{Missing,Real}[missing,missing],
                       "D5 (%)" => Union{Missing,Real}[missing,missing],
                       "D6 (%)" => Union{Missing,Real}[missing,missing])
    for (col, coltrue) ∈ zip(eachcol(df), eachcol(dftrue))
        @test isequal(col, coltrue)
    end
end
