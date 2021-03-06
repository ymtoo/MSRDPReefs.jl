"""
Default datetime ranges for all the sites.

# Example:
```julia-repl
julia> SITEDTRANGES
Dict{String,Array{Tuple{Dates.DateTime,Dates.DateTime},1}} with 10 entries:
  "TPT"        => [(DateTime("2019-11-22T11:30:00"), DateTime("2019-12-31T00:00:00")), (DateTime("202…
  "RL-W"       => [(DateTime("2019-06-21T13:00:00"), DateTime("2019-07-15T11:00:00")), (DateTime("202…
  "Semakau-SW" => [(DateTime("2019-10-11T14:00:00"), DateTime("2019-10-17T03:00:00")), (DateTime("202…
  "SL-SE"      => [(DateTime("2019-10-11T12:00:00"), DateTime("2019-10-25T00:00:00")), (DateTime("202…
  "Seringat"   => [(DateTime("2019-10-11T11:00:00"), DateTime("2019-11-08T00:00:00")), (DateTime("202…
  "Kusu-NE"    => [(DateTime("2019-09-11T11:00:00"), DateTime("2019-10-11T10:30:00")), (DateTime("202…
  "Hantu-W"    => [(DateTime("2019-09-11T13:00:00"), DateTime("2019-10-11T12:00:00")), (DateTime("202…
  "Jong-S"     => [(DateTime("2019-09-11T12:30:00"), DateTime("2019-10-11T12:00:00")), (DateTime("202…
  "Semakau-NW" => [(DateTime("2020-01-08T13:30:00"), DateTime("2020-02-16T00:00:00")), (DateTime("202…
  "SD-NW"      => [(DateTime("2019-11-22T14:00:00"), DateTime("2019-12-02T11:30:00")), (DateTime("202…
```
"""
const SITEDTRANGES = Dict(
    "Hantu-W" => [(DateTime(2019, 9, 11, 13, 0, 0), DateTime(2019, 10, 11, 12, 0, 0)), 
                  (DateTime(2020, 1, 8, 12, 30, 0), DateTime(2020, 2, 16, 0, 11, 31)),
                  (DateTime(2020, 6, 30, 12, 30, 0), DateTime(2020, 7, 30, 21, 0, 0)),
                  (DateTime(2020, 10, 13, 11, 0, 0), DateTime(2020, 11, 13, 10, 0, 0)),
                  (DateTime(2021, 1, 14, 11, 0, 0), DateTime(2021, 2, 17, 3, 0, 0))],
    "Jong-S" => [(DateTime(2019, 9, 11, 12, 30, 0), DateTime(2019, 10, 11, 12, 0, 0)), 
                 (DateTime(2020, 8, 7, 12, 30, 0), DateTime(2020, 9, 11, 11, 0, 0)),
                 (DateTime(2020, 10, 13, 12, 0, 0), DateTime(2020, 11, 13, 11, 0, 0))],
    "Kusu-NE" => [(DateTime(2019, 9, 11, 11, 0, 0), DateTime(2019, 10, 11, 10, 30, 0)),
                  (DateTime(2020, 8, 7, 13, 0, 0), DateTime(2020, 9, 11, 12, 0, 0)),
                  (DateTime(2020, 11, 13, 13, 0, 0), DateTime(2020, 12, 14, 13, 0, 0))],
    "RL-W" => [(DateTime(2019, 6, 21, 13, 0, 0), DateTime(2019, 7, 15, 11, 0, 0)), 
               (DateTime(2020, 1, 8, 10, 30, 0), DateTime(2020, 2, 15, 22, 30, 0)),
               (DateTime(2020, 8, 7, 11, 0, 0), DateTime(2020, 9, 11, 9, 0, 0)),
               (DateTime(2020, 11, 13, 11, 0, 0), DateTime(2020, 12, 14, 10, 0, 0))],
    "SD-NW" => [(DateTime(2019, 11, 22, 14, 0, 0), DateTime(2019, 12, 2, 11, 30, 0)), 
                (DateTime(2020, 3, 19, 12, 30, 0), DateTime(2020, 4, 27, 00, 50, 0)),
                (DateTime(2020, 10, 13, 12, 30, 0), DateTime(2020, 11, 13, 11, 30, 0)),
                (DateTime(2020, 12, 14, 13, 30, 0), DateTime(2021, 1, 14, 12, 30, 0)),
                (DateTime(2021, 1, 14, 13, 0, 0), DateTime(2021, 2, 19, 11, 30, 0))],
    "Semakau-NW" => [(DateTime(2020, 1, 8, 13, 30, 0), DateTime(2020, 2, 16, 0, 0, 0)),
                     (DateTime(2020, 8, 7, 12, 0, 0), DateTime(2020, 9, 11, 10, 0, 0)),
                     (DateTime(2020, 12, 14, 12, 30, 0), DateTime(2021, 1, 14, 11, 0, 0))],
    "Semakau-SW" => [(DateTime(2019, 10, 11, 14, 0, 0), DateTime(2019, 10, 17, 3, 0, 0)),
                     (DateTime(2020, 9, 11, 12, 0, 0), DateTime(2020, 9, 11, 21, 10, 0)),
                     (DateTime(2020, 11, 13, 11, 30, 0), DateTime(2020, 12, 14, 12, 0, 0))],
    "Seringat" => [(DateTime(2019, 10, 11, 11, 0, 0), DateTime(2019, 11, 8, 0, 0, 0)), 
                   (DateTime(2020, 3, 19, 15, 0, 0), DateTime(2020, 4, 27, 1, 40, 0)),
                   (DateTime(2020, 9, 11, 13, 30, 0), DateTime(2020, 10, 13, 12, 0, 0)),
                   (DateTime(2020, 12, 14, 14, 0, 0), DateTime(2021, 1, 14, 13, 0, 0))],
    "SL-SE" => [(DateTime(2019, 10, 11, 12, 0, 0), DateTime(2019, 10, 25, 0, 0, 0)), 
                (DateTime(2020, 3, 19, 15, 0, 0), DateTime(2020, 4, 27, 1, 30, 0)),
                (DateTime(2020, 10, 13, 12, 30, 0), DateTime(2020, 11, 13, 11, 30, 0)),
                (DateTime(2021, 1, 14, 13, 30, 0), DateTime(2021, 2, 18, 6, 35, 0))],
    "TPT" => [(DateTime(2019, 11, 22, 11, 30, 0), DateTime(2019, 12, 31, 0, 0, 0)), 
              (DateTime(2020, 3, 19, 10, 40, 0), DateTime(2020, 4, 26, 22, 50, 0)),
              (DateTime(2020, 9, 11, 12, 0, 0), DateTime(2020, 10, 13, 9, 30, 0)),
              (DateTime(2020, 12, 14, 12, 0, 0), DateTime(2021, 1, 14, 10, 0, 0))]
)

const COLUMNNAMES = ["Datetime", 
                     "Site",
                     "Sensor",
                     "Sensitivity",
                     "Gain",
                     "Wavpath", 
                     "Battery", 
                     "Depth", 
                     "Temperature", 
                     "Redlight", 
                     "Greenlight", 
                     "Bluelight", 
                     "Moonphase",
                     "Diver"]
const COLUMNTYPES = [DateTime[], 
                     String[],
                     String[],
                     Float64[],
                     Float64[],
                     String[], 
                     Union{Missing,Float64}[], 
                     Union{Missing,Float64}[], 
                     Union{Missing,Float64}[], 
                     Union{Missing,Float64}[], 
                     Union{Missing,Float64}[], 
                     Union{Missing,Float64}[], 
                     Int64[],
                     Bool[]]

const WAVFILETIMELENGTH = Minute(5)
const HEADER = 4 # log data starts at 4th row

"""
    getpaths(rootpath)

Get parent paths. The output is a 1-D array containing paths for data 
(acoustic and environmental) collected at all the sites.
"""
getpaths(rootpath::AbstractString) = [joinpath(rootpath, dir) for dir in 
    readdir(rootpath) if dir ∉ ["Semakau-NE", "README.md", "logs", ".DS_Store", "@eaDir"]]

"""
    _metadata(path, 
              dtranges=SITEDTRANGES[split(path, "/")[end]], 
              divinglogpath::AbstractString=joinpath(path, "../logs/diving-log.csv")

Get metadata in DataFrame of data collected at a particular site.
- Datetime
- Site
- Sensor
- Sensitivity
- Gain
- Wavpath
- Battery
- Depth
- Temperature
- Red light
- Blue light
- Green light 
- Diver

# Example:
```julia-repl
julia> df = MSRDPReefs._metadata("/home/arl/Data/reefwatch/recordings/Hantu-W");

julia> first(df, 5)
5×14 DataFrame
│ Row │ Datetime            │ Site    │ Sensor     │ Sensitivity │ Gain    │ Wavpath                                                                         │ Battery  │ Depth    │ Temperature │ Redlight │ Greenlight │ Bluelight │ Moonphase │ Diver │
│     │ DateTime            │ String  │ String     │ Float64     │ Float64 │ String                                                                          │ Float64? │ Float64? │ Float64?    │ Float64? │ Float64?   │ Float64?  │ Int64     │ Bool  │
├─────┼─────────────────────┼─────────┼────────────┼─────────────┼─────────┼─────────────────────────────────────────────────────────────────────────────────┼──────────┼──────────┼─────────────┼──────────┼────────────┼───────────┼───────────┼───────┤
│ 1   │ 2019-09-11T13:02:08 │ Hantu-W │ LS1-437902 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T130208.wav │ 4.31     │ 2.61     │ 30.3        │ 6303.0   │ 10794.0    │ 6907.0    │ 5         │ 0     │
│ 2   │ 2019-09-11T13:07:07 │ Hantu-W │ LS1-437902 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T130707.wav │ 4.3      │ 2.6      │ 30.28       │ 6911.0   │ 10755.0    │ 7262.0    │ 5         │ 0     │
│ 3   │ 2019-09-11T13:12:07 │ Hantu-W │ LS1-437902 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T131207.wav │ 4.3      │ 2.56     │ 30.21       │ 6407.0   │ 10623.0    │ 6929.0    │ 5         │ 0     │
│ 4   │ 2019-09-11T13:17:07 │ Hantu-W │ LS1-437902 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T131707.wav │ 4.28     │ 2.54     │ 30.22       │ 6008.0   │ 10385.0    │ 6814.0    │ 5         │ 0     │
│ 5   │ 2019-09-11T13:22:07 │ Hantu-W │ LS1-437902 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T132207.wav │ 4.28     │ 2.51     │ 30.23       │ 6227.0   │ 10614.0    │ 6899.0    │ 5         │ 0     │
```
"""
function _metadata(path::AbstractString, 
                   dtranges::AbstractVector{Tuple{DateTime, DateTime}}=SITEDTRANGES[split(path, "/")[end]],
                   divinglogpath::AbstractString=joinpath(path, "../logs/diving-log.csv"))
    site = split(path, "/")[end]
    logpaths = getlogpaths(path, dtranges)
    columns = [Symbol(columnname) => columntype for (columnname, columntype) in zip(COLUMNNAMES, COLUMNTYPES)]
    diverdf = CSV.File(divinglogpath; types=[String,DateTime,DateTime]) |> DataFrame
    sitediverdf = @view diverdf[diverdf.Site .== site,:]
    df = DataFrame(columns)
    for (logpath, dtrange) in zip(logpaths, dtranges)
        dftmp = CSV.File(logpath; header=HEADER, types=Dict("Timestamp" => String, 
                                                       " Batt (V)" => Union{Missing, Float64}, 
                                                       " Depth(M)" => Union{Missing, Float64}, 
                                                       " Temp (degC)" => Union{Missing, Float64}, 
                                                       " Red " => Union{Missing, Float64}, 
                                                       " Green " => Union{Missing, Float64}, 
                                                       " Blue " => Union{Missing, Float64})) |> DataFrame
        acousticsensor = DataFrame(CSV.File(logpath; header=0, delim=" ", limit=3))[:,2]
        revisedf!(dftmp, logpath, dtrange, acousticsensor, sitediverdf)
        append!(df, dftmp)
    end
    df
end

"""
    getlogpaths(path, dtranges)

Get paths of all the log files in parent path `path`
"""
function getlogpaths(path::AbstractString, dtranges::AbstractVector{Tuple{DateTime, DateTime}})
    logpaths = Vector{String}()
    dirs = [dir for dir in readdir(path) if dir[1] ∉ ['.', '@']]
    for dtrange in dtranges
        index = findall(x -> x ∈ trunc(dtrange[1], Month):Month(1):trunc(dtrange[2], Month), DateTime.(dirs, "yyyy-mm"))
        if length(index) == 1
            childpath = joinpath(path, dirs[index[1]])
            (_, datedir, file) = first(walkdir(childpath))
            push!(logpaths, joinpath(childpath, file[1]))
        end
    end
    logpaths
end

"""
    revisedf!(df, logpath, dtrange, acousticsensor)    

Modify the dataframe `df` by adding Datetime, Site, Sensitivity, Gain, Wawpath, Moonphase, Diver columns, 
combining Red, Green and Blue into RGB(Red, Green, Blue), renaming the columns and removing rows which 
are not in the datetime range.
"""
function revisedf!(df, logpath, dtrange, acousticsensor, sitediverdf)
    delcolnames = [" Red ", " Green ", " Blue "]
    patharray = split(logpath, "/")
    site = patharray[end-2]
    pathtmp = rsplit(logpath, "/"; limit=2)[1]
    numrows = size(df, 1)
    insertcols!(df, 1, :Datetime => DateTime(2019, 6, 1, 0, 0, 0))
    insertcols!(df, 2, :Site => site)
    insertcols!(df, 3, :Sensor => acousticsensor[1])
    insertcols!(df, 4, :Sensitivity => parse(Float64, acousticsensor[2]))
    insertcols!(df, 5, :Gain => parse(Float64, acousticsensor[3]))
    insertcols!(df, 10, :Redlight => Vector{Union{Missing,Float64}}(undef, numrows))
    insertcols!(df, 11, :Greenlight => Vector{Union{Missing,Float64}}(undef, numrows))
    insertcols!(df, 12, :Bluelight => Vector{Union{Missing,Float64}}(undef, numrows))
    insertcols!(df, 13, :Moonphase => 0)
    insertcols!(df, 14, :Diver => false)
    # notindtrangerowindices = Int[]
    notin = Int[]
    for i in 1:size(df, 1)
        wavfile = df[i, :Timestamp]
        dir = join([wavfile[1:4], wavfile[5:6]], "-")
        dt = DateTime(wavfile[1:end-4], "yyyymmddTHHMMSS")
        if !(dt >= dtrange[1] && dt <= dtrange[2])
            i ∉ notin && push!(notin, i)
        end
        df[i,:Datetime] = dt
        wavpath = joinpath(pathtmp, dir, wavfile)
        if filesize(wavpath) == 0
            i ∉ notin && push!(notin, i)
        end
        df[i,:Timestamp] = wavpath#joinpath(joinpath(pathtmp, dir), wavfile)
        if !ismissing(df[i, Symbol(" Depth(M)")]) && df[i, Symbol(" Depth(M)")] < 0.0 
            df[i, Symbol(" Depth(M)")] = missing
        end
        if (!ismissing(df[i,Symbol(" Red ")]) && df[i,Symbol(" Red ")] == 65535) && (
            !ismissing(df[i,Symbol(" Green ")]) && df[i,Symbol(" Green ")] == 65535) && (
            !ismissing(df[i,Symbol(" Blue ")]) && df[i,Symbol(" Blue ")] == 65535)
            df[i,Symbol(" Red ")] = missing
            df[i,Symbol(" Green ")] = missing
            df[i,Symbol(" Blue ")] = missing
        end
        df[i,:Redlight] = convert(Union{Missing,Float64}, df[i, end-2])
        df[i,:Greenlight] = convert(Union{Missing,Float64}, df[i, end-1])
        df[i,:Bluelight] = convert(Union{Missing,Float64}, df[i, end])
        df[i,:Moonphase] = moonphase(dt)
        !isempty(sitediverdf) && any((dt .>= sitediverdf[!,:Start]) .& (dt .<= sitediverdf[!,:Stop])) && (df[i,:Diver] = true)
    end
    select!(df, Not(Symbol.(delcolnames)))
    rename!(df, COLUMNNAMES)
    delete!(df, notin)
    categorical!(df, :Moonphase)
    #transform!(df, :Moonphase => categorical; renamecols=false)
    df
end

"""
    metadata(paths, dtrangesdict=SITEDTRANGES)

Get metadata in DataFrame of data collected at multiple sites. 
- Datetime
- Site
- Sensitivity
- Gain
- Wavpath
- Battery
- Depth
- Temperature
- Red light
- Blue light
- Green light 
- Diver

# Example:
```julia-repl
julia> df = metadata(["/home/arl/Data/reefwatch/recordings/Hantu-W","/home/arl/Data/reefwatch/recordings/RL-W"]);

julia> first(df, 5)
5×14 DataFrame
│ Row │ Datetime            │ Site    │ Sensor     │ Sensitivity │ Gain    │ Wavpath                                                                         │ Battery  │ Depth    │ Temperature │ Redlight │ Greenlight │ Bluelight │ Moonphase │ Diver │
│     │ DateTime            │ String  │ String     │ Float64     │ Float64 │ String                                                                          │ Float64? │ Float64? │ Float64?    │ Float64? │ Float64?   │ Float64?  │ Int64     │ Bool  │
├─────┼─────────────────────┼─────────┼────────────┼─────────────┼─────────┼─────────────────────────────────────────────────────────────────────────────────┼──────────┼──────────┼─────────────┼──────────┼────────────┼───────────┼───────────┼───────┤
│ 1   │ 2019-09-11T13:02:08 │ Hantu-W │ LS1-437902 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T130208.wav │ 4.31     │ 2.61     │ 30.3        │ 6303.0   │ 10794.0    │ 6907.0    │ 5         │ 0     │
│ 2   │ 2019-09-11T13:07:07 │ Hantu-W │ LS1-437902 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T130707.wav │ 4.3      │ 2.6      │ 30.28       │ 6911.0   │ 10755.0    │ 7262.0    │ 5         │ 0     │
│ 3   │ 2019-09-11T13:12:07 │ Hantu-W │ LS1-437902 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T131207.wav │ 4.3      │ 2.56     │ 30.21       │ 6407.0   │ 10623.0    │ 6929.0    │ 5         │ 0     │
│ 4   │ 2019-09-11T13:17:07 │ Hantu-W │ LS1-437902 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T131707.wav │ 4.28     │ 2.54     │ 30.22       │ 6008.0   │ 10385.0    │ 6814.0    │ 5         │ 0     │
│ 5   │ 2019-09-11T13:22:07 │ Hantu-W │ LS1-437902 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T132207.wav │ 4.28     │ 2.51     │ 30.23       │ 6227.0   │ 10614.0    │ 6899.0    │ 5         │ 0     │

julia> last(df, 5)
5×14 DataFrame
│ Row │ Datetime            │ Site   │ Sensor     │ Sensitivity │ Gain    │ Wavpath                                                                      │ Battery  │ Depth    │ Temperature │ Redlight │ Greenlight │ Bluelight │ Moonphase │ Diver │
│     │ DateTime            │ String │ String     │ Float64     │ Float64 │ String                                                                       │ Float64? │ Float64? │ Float64?    │ Float64? │ Float64?   │ Float64?  │ Int64     │ Bool  │
├─────┼─────────────────────┼────────┼────────────┼─────────────┼─────────┼──────────────────────────────────────────────────────────────────────────────┼──────────┼──────────┼─────────────┼──────────┼────────────┼───────────┼───────────┼───────┤
│ 1   │ 2020-12-14T09:38:16 │ RL-W   │ LS1-437783 │ -180.0      │ 16.77   │ /home/arl/Data/reefwatch/recordings/RL-W/2020-11/2020-12/20201214T093816.wav │ 3.76     │ 4.2      │ 28.77       │ 677.0    │ 1457.0     │ 833.0     │ 8         │ 0     │
│ 2   │ 2020-12-14T09:43:16 │ RL-W   │ LS1-437783 │ -180.0      │ 16.77   │ /home/arl/Data/reefwatch/recordings/RL-W/2020-11/2020-12/20201214T094316.wav │ 3.81     │ 4.2      │ 28.78       │ 635.0    │ 1345.0     │ 782.0     │ 8         │ 0     │
│ 3   │ 2020-12-14T09:48:16 │ RL-W   │ LS1-437783 │ -180.0      │ 16.77   │ /home/arl/Data/reefwatch/recordings/RL-W/2020-11/2020-12/20201214T094816.wav │ 3.85     │ 4.25     │ 28.78       │ 822.0    │ 1774.0     │ 1029.0    │ 8         │ 0     │
│ 4   │ 2020-12-14T09:53:16 │ RL-W   │ LS1-437783 │ -180.0      │ 16.77   │ /home/arl/Data/reefwatch/recordings/RL-W/2020-11/2020-12/20201214T095316.wav │ 3.81     │ 4.22     │ 28.78       │ 861.0    │ 1854.0     │ 1077.0    │ 8         │ 0     │
│ 5   │ 2020-12-14T09:58:17 │ RL-W   │ LS1-437783 │ -180.0      │ 16.77   │ /home/arl/Data/reefwatch/recordings/RL-W/2020-11/2020-12/20201214T095817.wav │ 3.82     │ 4.26     │ 28.78       │ 865.0    │ 1871.0     │ 1088.0    │ 8         │ 0     │
```
"""
function metadata(paths::Vector{String}, 
                  dtrangesdict::Dict{String, Vector{Tuple{DateTime, DateTime}}}=SITEDTRANGES)
    df = DataFrame()
    for path in paths
        site = split(path, "/")[end]
        dtranges = dtrangesdict[site]
        dftmp = _metadata(path, dtranges)
        append!(df, dftmp)
    end
    df
end

"""
    metadata(rootpath, dtrangesdict=SITEDTRANGES)

Get metadata in DataFrame of data collected at all the sites.
- Datetime
- Site
- Sensitivity
- Gain
- Wavpath
- Battery
- Depth
- Temperature
- Red light
- Blue light
- Green light 
- Diver

# Example:
```julia-repl
julia> df = metadata("/home/arl/Data/reefwatch/recordings");

julia> first(df, 5)
5×14 DataFrame
│ Row │ Datetime            │ Site    │ Sensor     │ Sensitivity │ Gain    │ Wavpath                                                                         │ Battery  │ Depth    │ Temperature │ Redlight │ Greenlight │ Bluelight │ Moonphase │ Diver │
│     │ DateTime            │ String  │ String     │ Float64     │ Float64 │ String                                                                          │ Float64? │ Float64? │ Float64?    │ Float64? │ Float64?   │ Float64?  │ Int64     │ Bool  │
├─────┼─────────────────────┼─────────┼────────────┼─────────────┼─────────┼─────────────────────────────────────────────────────────────────────────────────┼──────────┼──────────┼─────────────┼──────────┼────────────┼───────────┼───────────┼───────┤
│ 1   │ 2019-09-11T13:02:08 │ Hantu-W │ LS1-437902 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T130208.wav │ 4.31     │ 2.61     │ 30.3        │ 6303.0   │ 10794.0    │ 6907.0    │ 5         │ 0     │
│ 2   │ 2019-09-11T13:07:07 │ Hantu-W │ LS1-437902 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T130707.wav │ 4.3      │ 2.6      │ 30.28       │ 6911.0   │ 10755.0    │ 7262.0    │ 5         │ 0     │
│ 3   │ 2019-09-11T13:12:07 │ Hantu-W │ LS1-437902 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T131207.wav │ 4.3      │ 2.56     │ 30.21       │ 6407.0   │ 10623.0    │ 6929.0    │ 5         │ 0     │
│ 4   │ 2019-09-11T13:17:07 │ Hantu-W │ LS1-437902 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T131707.wav │ 4.28     │ 2.54     │ 30.22       │ 6008.0   │ 10385.0    │ 6814.0    │ 5         │ 0     │
│ 5   │ 2019-09-11T13:22:07 │ Hantu-W │ LS1-437902 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T132207.wav │ 4.28     │ 2.51     │ 30.23       │ 6227.0   │ 10614.0    │ 6899.0    │ 5         │ 0     │

julia> unique(df.Site)
10-element Array{String,1}:
 "Hantu-W"
 "Jong-S"
 "Kusu-NE"
 "RL-W"
 "SD-NW"
 "SL-SE"
 "Semakau-NW"
 "Semakau-SW"
 "Seringat"
 "TPT"
```
"""
function metadata(rootpath::AbstractString, dtrangesdict::Dict{String, Vector{Tuple{DateTime, DateTime}}}=SITEDTRANGES)
    metadata(getpaths(rootpath), dtrangesdict)
end

"""
    datacollectionprogress(paths)

Show the data collection progress in percentage given multipe parent paths. 
100 percent equals to one month of data.

# Examples:
```julia-repl
julia> datacollectionprogress(["/home/arl/Data/reefwatch/recordings/Hantu-W",
"/home/arl/Data/reefwatch/recordings/RL-W"])
2×7 DataFrame
│ Row │ Site    │ D1 (%)  │ D2 (%)  │ D3 (%)  │ D4 (%)  │ D5 (%)  │ D6 (%)  │
│     │ String  │ Real?   │ Real?   │ Real?   │ Real?   │ Real?   │ Real?   │
├─────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ 1   │ Hantu-W │ 100.788 │ 128.408 │ 77.8376 │ 103.189 │ 112.21  │ missing │
│ 2   │ RL-W    │ 83.6276 │ 128.501 │ 116.384 │ 103.324 │ missing │ missing │
```
"""
function datacollectionprogress(paths::AbstractVector{String})
    columns = [Symbol(columnname) => columntype for (columnname, columntype) in zip(["Site", "D1 (%)", "D2 (%)", "D3 (%)", "D4 (%)", "D5 (%)", "D6 (%)"], [String[], Union{Missing, Real}[], Union{Missing, Real}[], Union{Missing, Real}[], Union{Missing, Real}[], Union{Missing, Real}[], Union{Missing, Real}[]])]
    df = DataFrame(columns)
    for path in paths
        x = []
        site = split(path, "/")[end]
        push!(x, site)
        for p in readdir(path)
            if isfile(joinpath(path, p, "LOG.CSV"))
                logdf = CSV.read(joinpath(path, p, "LOG.CSV"), DataFrame; header=HEADER)
                startwavfile = logdf[:, 1][1]
                endwavfile = logdf[:, 1][end]
                percent = Dates.value(DateTime(endwavfile[1:end-4], "yyyymmddTHHMMSS")-DateTime(startwavfile[1:end-4], "yyyymmddTHHMMSS"))/2592000000*100
                push!(x, percent)
            end
        end
        nmissing = length(columns)-length(x)
        for i in 1:nmissing
            push!(x, missing)
        end
        push!(df, x)
    end
    df
end

"""
    datacollectionprogress(rootpath)

Show the data collection progress in percentage given a root path. 100 percent
equals to one month of data.

# Examples:
```julia-repl
julia> datacollectionprogress("/home/arl/Data/reefwatch/recordings")
10×7 DataFrame
│ Row │ Site       │ D1 (%)  │ D2 (%)  │ D3 (%)  │ D4 (%)  │ D5 (%)  │ D6 (%)  │
│     │ String     │ Real?   │ Real?   │ Real?   │ Real?   │ Real?   │ Real?   │
├─────┼────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ 1   │ Hantu-W    │ 100.788 │ 128.408 │ 77.8376 │ 103.189 │ 112.21  │ missing │
│ 2   │ Jong-S     │ 100.811 │ 116.446 │ 103.188 │ missing │ missing │ missing │
│ 3   │ Kusu-NE    │ 100.452 │ 116.518 │ 103.32  │ missing │ missing │ missing │
│ 4   │ RL-W       │ 83.6276 │ 128.501 │ 116.384 │ 103.324 │ missing │ missing │
│ 5   │ SD-NW      │ 33.1604 │ 44.6388 │ 103.184 │ 103.181 │ 119.79  │ missing │
│ 6   │ SL-SE      │ 44.5767 │ 103.188 │ 115.685 │ missing │ missing │ missing │
│ 7   │ Semakau-NW │ 128.225 │ 116.374 │ 103.11  │ missing │ missing │ missing │
│ 8   │ Semakau-SW │ 18.9137 │ 4.374   │ 103.383 │ missing │ missing │ missing │
│ 9   │ Seringat   │ 90.5111 │ 51.5231 │ 106.451 │ 103.187 │ missing │ missing │
│ 10  │ TPT        │ 128.354 │ 25.6559 │ 106.307 │ 103.043 │ missing │ missing │
```
"""
function datacollectionprogress(rootpath::AbstractString)
    paths = getpaths(rootpath)#[joinpath(root, p) for p in readdir(root) if isdir(joinpath(root), p) && p ∉ ["Semakau-NE", "README.md"]]
    datacollectionprogress(paths)
end