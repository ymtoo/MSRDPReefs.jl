const DEFAULTDTRANGES = (DateTime(2019, 6, 1, 0, 0, 0), DateTime(2021, 4, 30, 23, 59, 59))
const SITEDTRANGES = Dict(
    "Hantu-W" => [(DateTime(2019, 9, 11, 13, 0, 0), DateTime(2019, 10, 11, 12, 0, 0)), 
                  (DateTime(2020, 1, 8, 12, 30, 0), DateTime(2020, 2, 16, 0, 11, 31)),
                  (DateTime(2020, 6, 30, 12, 30, 0), DateTime(2020, 7, 30, 21, 0, 0)),
                  (DateTime(2020, 10, 13, 11, 0, 0), DateTime(2020, 11, 13, 10, 0, 0))],
    "Jong-S" => [(DateTime(2019, 9, 11, 12, 30, 0), DateTime(2019, 10, 11, 12, 0, 0)), 
                 (DateTime(2020, 8, 7, 12, 30, 0), DateTime(2020, 9, 11, 11, 0, 0)),
                 (DateTime(2020, 10, 13, 12, 0, 0), DateTime(2020, 11, 13, 11, 0, 0))],
    "Kusu-NE" => [(DateTime(2019, 9, 11, 11, 0, 0), DateTime(2019, 10, 11, 10, 30, 0)),
                  (DateTime(2020, 8, 7, 13, 0, 0), DateTime(2020, 9, 11, 12, 0, 0))],
    "RL-W" => [(DateTime(2019, 6, 21, 13, 0, 0), DateTime(2019, 7, 15, 11, 0, 0)), 
               (DateTime(2020, 1, 8, 10, 30, 0), DateTime(2020, 2, 15, 22, 30, 0)),
               (DateTime(2020, 8, 7, 11, 0, 0), DateTime(2020, 9, 11, 9, 0, 0))],
    "SD-NW" => [(DateTime(2019, 11, 22, 14, 0, 0), DateTime(2019, 12, 2, 11, 30, 0)), 
                (DateTime(2020, 3, 19, 12, 30, 0), DateTime(2020, 4, 27, 00, 50, 0)),
                (DateTime(2020, 10, 13, 12, 30, 0), DateTime(2020, 11, 13, 11, 30, 0))],
    "Semakau-NW" => [(DateTime(2020, 1, 8, 13, 30, 0), DateTime(2020, 2, 16, 0, 0, 0)),
                     (DateTime(2020, 8, 7, 12, 0, 0), DateTime(2020, 9, 11, 10, 0, 0))],
    "Semakau-SW" => [(DateTime(2019, 10, 11, 14, 0, 0), DateTime(2019, 10, 17, 3, 0, 0)),
                     (DateTime(2020, 9, 11, 12, 0, 0), DateTime(2020, 9, 11, 21, 10, 0))],
    "Seringat" => [(DateTime(2019, 10, 11, 11, 0, 0), DateTime(2019, 11, 8, 0, 0, 0)), 
                   (DateTime(2020, 3, 19, 15, 0, 0), DateTime(2020, 4, 27, 1, 40, 0)),
                   (DateTime(2020, 9, 11, 13, 30, 0), DateTime(2020, 10, 13, 12, 0, 0))],
    "SL-SE" => [(DateTime(2019, 10, 11, 12, 0, 0), DateTime(2019, 10, 25, 0, 0, 0)), 
                (DateTime(2020, 3, 19, 15, 0, 0), DateTime(2020, 4, 27, 1, 30, 0)),
                (DateTime(2020, 10, 13, 12, 30, 0), DateTime(2020, 11, 13, 11, 30, 0))],
    "TPT" => [(DateTime(2019, 11, 22, 11, 30, 0), DateTime(2019, 12, 31, 0, 0, 0)), 
              (DateTime(2020, 3, 19, 10, 40, 0), DateTime(2020, 4, 26, 22, 50, 0)),
              (DateTime(2020, 9, 11, 12, 0, 0), DateTime(2020, 10, 13, 9, 30, 0))]
    )

const COLUMNNAMES = ["datetime", 
                     "sensitivity",
                     "gain",
                     "wavpath", 
                     "battery", 
                     "depth", 
                     "temperature", 
                     "redlight", 
                     "greenlight", 
                     "bluelight", 
                     "moonphase"]
const COLUMNTYPES = [DateTime[], 
                     Float64[],
                     Float64[],
                     String[], 
                     Union{Missing,Float64}[], 
                     Union{Missing,Float64}[], 
                     Union{Missing,Float64}[], 
                     Union{Missing,Float64}[], 
                     Union{Missing,Float64}[], 
                     Union{Missing,Float64}[], 
                     Int64[]]

const WAVFILETIMELENGTH = Minute(5)

"""
    getpaths(rootpath)

Get parent paths. The output is a 1-D array containing paths for data 
(acoustic and environmental) collected in all the sites.
"""
getpaths(rootpath::AbstractString) = [joinpath(rootpath, dir) for dir in 
    readdir(rootpath) if dir ∉ ["Semakau-NE", "README.md"]]

struct Metadata
    path::AbstractString
    site::AbstractString
    dtranges::AbstractVector{Tuple{DateTime, DateTime}}
    df::AbstractDataFrame
end

"""
    Metadata(path, dtranges=SITEDTRANGES[split(path, "/")[end]])

Get Metadata describing the collected data at a particular site. It composes 
of a root path `path` to the data, a site name `site`, datatime ranges `dtranges` 
and a DataFrame `df` for metadata: 
- datetime
- sensitivity
- gain
- wavpath
- battery
- depth
- temperature
- red light
- blue light
- green light 

# Example:
```julia-repl
julia> Metadata("/home/arl/Data/reefwatch/recordings/Hantu-W")
Metadata of Hantu-W during [(Dates.DateTime("2019-09-11T13:00:00"),
Dates.DateTime("2019-10-11T12:00:00")), (Dates.DateTime("2020-01-08T12:30:00"),
Dates.DateTime("2020-02-16T00:11:31")), (Dates.DateTime("2020-06-30T12:30:00"),
Dates.DateTime("2020-07-30T21:00:00")), (Dates.DateTime("2020-10-13T11:00:00"),
Dates.DateTime("2020-11-13T10:00:00"))]
5×11 DataFrame
│ Row │ datetime            │ sensitivity │ gain    │ wavpath                                                                         │ battery  │ depth    │ temperature │ redlight │ greenlight │ bluelight │ moonphase │
│     │ Dates.DateTime      │ Float64     │ Float64 │ String                                                                          │ Float64? │ Float64? │ Float64?    │ Float64? │ Float64?   │ Float64?  │ Int64     │
├─────┼─────────────────────┼─────────────┼─────────┼─────────────────────────────────────────────────────────────────────────────────┼──────────┼──────────┼─────────────┼──────────┼────────────┼───────────┼───────────┤
│ 1   │ 2019-09-11T13:02:08 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T130208.wav │ 4.31     │ 2.61     │ 30.3        │ 6303.0   │ 10794.0    │ 6907.0    │ 5         │
│ 2   │ 2019-09-11T13:07:07 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T130707.wav │ 4.3      │ 2.6      │ 30.28       │ 6911.0   │ 10755.0    │ 7262.0    │ 5         │
│ 3   │ 2019-09-11T13:12:07 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T131207.wav │ 4.3      │ 2.56     │ 30.21       │ 6407.0   │ 10623.0    │ 6929.0    │ 5         │
│ 4   │ 2019-09-11T13:17:07 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T131707.wav │ 4.28     │ 2.54     │ 30.22       │ 6008.0   │ 10385.0    │ 6814.0    │ 5         │
│ 5   │ 2019-09-11T13:22:07 │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T132207.wav │ 4.28     │ 2.51     │ 30.23       │ 6227.0   │ 10614.0    │ 6899.0    │ 5         │
```
"""
function Metadata(path::AbstractString, dtranges::AbstractVector{Tuple{DateTime, DateTime}}=SITEDTRANGES[split(path, "/")[end]])
    site = split(path, "/")[end]
    logpaths = getlogpaths(path, dtranges)
    columns = [Symbol(columnname) => columntype for (columnname, columntype) in zip(COLUMNNAMES, COLUMNTYPES)]
    df = DataFrame(columns)
    for (logpath, dtrange) in zip(logpaths, dtranges)
        dftmp = DataFrame(CSV.File(logpath; header=3, types=Dict("Timestamp" => String, 
                                                                 " Batt (V)" => Union{Missing, Float64}, 
                                                                 " Depth(M)" => Union{Missing, Float64}, 
                                                                 " Temp (degC)" => Union{Missing, Float64}, 
                                                                 " Red " => Union{Missing, Float64}, 
                                                                 " Green " => Union{Missing, Float64}, 
                                                                 " Blue " => Union{Missing, Float64})))
        acousticsensor = DataFrame(CSV.File(logpath; header=0, delim=" ", limit=2))[:,2]
        revisedf!(dftmp, logpath, dtrange, acousticsensor)
        append!(df, dftmp)
    end
    Metadata(path, site, dtranges, df)
end
function Metadata(path::AbstractString, index::Integer)
    Metadata(path, SITEDTRANGES[split(path, "/")[end]][index:index])
end

function Base.show(io::IO, ::MIME"text/plain", x::Metadata) 
    println(io, "Metadata of $(x.site) during $(x.dtranges)")
    println(io, first(x.df, 5))
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

Modify the dataframe `df` by adding DateTime and WAV path columns, 
combining Red, Green and Blue into RGB(Red, Green, Blue), renaming 
the columns and removing rows which are not in the datetime range.
"""
function revisedf!(df, logpath, dtrange, acousticsensor)
#    colnames = names(df)#["Datetime", "WAV path", "Batt (V)", "Depth (m)", "Temp (degC)", "Light Intensity"]
    delcolnames = [" Red ", " Green ", " Blue "]
    patharray = split(logpath, "/")
    site = patharray[end-2]
    pathtmp = rsplit(logpath, "/"; limit=2)[1]
    numrows = size(df, 1)
    insertcols!(df, 1, :datetime => DateTime(2019, 6, 1, 0, 0, 0))
    insertcols!(df, 2, :sensitivity => acousticsensor[1])
    insertcols!(df, 3, :gain => acousticsensor[2])
    insertcols!(df, 8, :redlight => Vector{Union{Missing,Float64}}(undef, numrows))
    insertcols!(df, 9, :greenlight => Vector{Union{Missing,Float64}}(undef, numrows))
    insertcols!(df, 10, :bluelight => Vector{Union{Missing,Float64}}(undef, numrows))
#    insertcols!(df, 6, :light => RGB{Float64}(0.0, 0.0, 0.0))
    insertcols!(df, 11, :moonphase => 0)
    notindtrangerowindices = Int[]
    for i in 1:size(df, 1)
        wavfile = df[i, :Timestamp]
        dir = join([wavfile[1:4], wavfile[5:6]], "-")
        dt = DateTime(wavfile[1:end-4], "yyyymmddTHHMMSS")
        if !(dt >= dtrange[1] && dt <= dtrange[2])
            push!(notindtrangerowindices, i)
        end
        df[i, :datetime] = dt#DateTime(wavfile[1:end-4], "yyyymmddTHHMMSS")
        df[i, :Timestamp] = joinpath(joinpath(pathtmp, dir), wavfile)
        if !ismissing(df[i, Symbol(" Depth(M)")]) && df[i, Symbol(" Depth(M)")] < 0.0 
            df[i, Symbol(" Depth(M)")] = missing
        end
        if (!ismissing(df[i, Symbol(" Red ")]) && df[i, Symbol(" Red ")] == 65535) && (
            !ismissing(df[i, Symbol(" Green ")]) && df[i, Symbol(" Green ")] == 65535) && (
            !ismissing(df[i, Symbol(" Blue ")]) && df[i, Symbol(" Blue ")] == 65535)
            df[i, Symbol(" Red ")] = missing
            df[i, Symbol(" Green ")] = missing
            df[i, Symbol(" Blue ")] = missing
        end
        df[i, :redlight] = convert(Union{Missing,Float64}, df[i, end-2])
        df[i, :greenlight] = convert(Union{Missing,Float64}, df[i, end-1])
        df[i, :bluelight] = convert(Union{Missing,Float64}, df[i, end])
#        df[i, :light] = RGB(Float64(df[i, end-2]), Float64(df[i, end-1]), Float64(df[i, end]))
        df[i, :moonphase] = moonphase(dt)
    end
    select!(df, Not(Symbol.(delcolnames)))
    rename!(df, COLUMNNAMES)
    delete!(df, notindtrangerowindices)
    categorical!(df, :moonphase)
    df
end

struct MetadataAll
    path::Vector{AbstractString}
    dtranges::Dict{AbstractString, Vector{Tuple{DateTime, DateTime}}}
    df::AbstractDataFrame
end

function MetadataAll(paths::Vector{<:AbstractString}, 
                     dtrangesdict::Dict{String, Vector{Tuple{DateTime, DateTime}}}=SITEDTRANGES)
    df = DataFrame()
    for path in paths
        site = split(path, "/")[end]
        dtranges = dtrangesdict[site]
        mdatatmp = Metadata(path, dtranges)
        insertcols!(mdatatmp.df, 2, :site => mdatatmp.site)
        append!(df, mdatatmp.df)
    end
    MetadataAll(paths, dtrangesdict, df)
end
"""
    MetadataAll(path, dtrangesdict=SITEDTRANGES)

Get MetadataAll describing the collected data at all the sites. It composes 
of a root path `path` to the data, datatime ranges `dtrangesdict` 
and a DataFrame `df` for metadata: 
- datetime
- sensitivity
- gain
- wavpath
- battery
- depth
- temperature
- red light
- blue light
- green light 

# Example:
```julia-repl
julia> MetadataAll("/home/arl/Data/reefwatch/recordings")
Metadata of all the sites
5×12 DataFrame
│ Row │ datetime            │ site     │ sensitivity │ gain    │ wavpath                                                                         │ battery  │ depth    │ temperature │ redlight │ greenlight │ bluelight │ moonphase │
│     │ Dates.DateTime      │ SubStri… │ Float64     │ Float64 │ String                                                                          │ Float64? │ Float64? │ Float64?    │ Float64? │ Float64?   │ Float64?  │ Int64     │
├─────┼─────────────────────┼──────────┼─────────────┼─────────┼─────────────────────────────────────────────────────────────────────────────────┼──────────┼──────────┼─────────────┼──────────┼────────────┼───────────┼───────────┤
│ 1   │ 2019-09-11T13:02:08 │ Hantu-W  │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T130208.wav │ 4.31     │ 2.61     │ 30.3        │ 6303.0   │ 10794.0    │ 6907.0    │ 5         │
│ 2   │ 2019-09-11T13:07:07 │ Hantu-W  │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T130707.wav │ 4.3      │ 2.6      │ 30.28       │ 6911.0   │ 10755.0    │ 7262.0    │ 5         │
│ 3   │ 2019-09-11T13:12:07 │ Hantu-W  │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T131207.wav │ 4.3      │ 2.56     │ 30.21       │ 6407.0   │ 10623.0    │ 6929.0    │ 5         │
│ 4   │ 2019-09-11T13:17:07 │ Hantu-W  │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T131707.wav │ 4.28     │ 2.54     │ 30.22       │ 6008.0   │ 10385.0    │ 6814.0    │ 5         │
│ 5   │ 2019-09-11T13:22:07 │ Hantu-W  │ -179.8      │ 16.77   │ /home/arl/Data/reefwatch/recordings/Hantu-W/2019-09/2019-09/20190911T132207.wav │ 4.28     │ 2.51     │ 30.23       │ 6227.0   │ 10614.0    │ 6899.0    │ 5         │
```
"""
function MetadataAll(path::AbstractString, dtrangesdict::Dict{String, Vector{Tuple{DateTime, DateTime}}}=SITEDTRANGES)
    MetadataAll(getpaths(path), dtrangesdict)
end

function Base.show(io::IO, ::MIME"text/plain", x::MetadataAll) 
    println(io, "Metadata of all the sites")
    println(first(x.df, 5))
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
│ 1   │ Hantu-W │ 100.788 │ 128.408 │ 77.8376 │ 103.189 │ missing │ missing │
│ 2   │ RL-W    │ 83.6276 │ 128.501 │ 116.384 │ missing │ missing │ missing │
```
"""
function datacollectionprogress(paths::AbstractVector{String})
    columns = [Symbol(columnname) => columntype for (columnname, columntype) in zip(["Site", "D1 (%)", "D2 (%)", "D3 (%)", "D4 (%)", "D5 (%)", "D6 (%)"], [String[], Union{Missing, Real}[], Union{Missing, Real}[], Union{Missing, Real}[], Union{Missing, Real}[], Union{Missing, Real}[], Union{Missing, Real}[]])]
    df = DataFrame(columns)
#    sites = [p for p in readdir(root) if isdir(joinpath(root), p)]
    for path in paths
        x = []
        site = split(path, "/")[end]
        push!(x, site)
#        pathtmp = joinpath(root, site)
        for p in readdir(path)
            if isfile(joinpath(path, p, "LOG.CSV"))
                logdf = CSV.read(joinpath(path, p, "LOG.CSV"), DataFrame; header=3)
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
    datacollectionprogress(path)

Show the data collection progress in percentage given a root path. 100 percent
equals to one month of data.

# Examples:
```julia-repl
julia> datacollectionprogress("/home/arl/Data/reefwatch/recordings")
10×7 DataFrame
│ Row │ Site       │ D1 (%)  │ D2 (%)  │ D3 (%)  │ D4 (%)  │ D5 (%)  │ D6 (%)  │
│     │ String     │ Real?   │ Real?   │ Real?   │ Real?   │ Real?   │ Real?   │
├─────┼────────────┼─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ 1   │ Hantu-W    │ 100.788 │ 128.408 │ 77.8376 │ 103.189 │ missing │ missing │
│ 2   │ Jong-S     │ 100.811 │ 116.446 │ 103.188 │ missing │ missing │ missing │
│ 3   │ Kusu-NE    │ 100.452 │ 116.518 │ missing │ missing │ missing │ missing │
│ 4   │ RL-W       │ 83.6276 │ 128.501 │ 116.384 │ missing │ missing │ missing │
│ 5   │ SD-NW      │ 33.1604 │ 44.6388 │ 103.184 │ missing │ missing │ missing │
│ 6   │ SL-SE      │ 44.5767 │ 103.188 │ missing │ missing │ missing │ missing │
│ 7   │ Semakau-NW │ 128.225 │ 116.374 │ missing │ missing │ missing │ missing │
│ 8   │ Semakau-SW │ 18.9137 │ 4.374   │ missing │ missing │ missing │ missing │
│ 9   │ Seringat   │ 90.5111 │ 51.5231 │ 106.451 │ missing │ missing │ missing │
│ 10  │ TPT        │ 128.354 │ 25.6559 │ 106.307 │ missing │ missing │ missing │
```
"""
function datacollectionprogress(root::AbstractString)
    paths = [joinpath(root, p) for p in readdir(root) if isdir(joinpath(root), p) && p ∉ ["Semakau-NE", "README.md"]]
    datacollectionprogress(paths)
end

# """
# Filter extreme feature values.
# """
# function filterfeatures!(df::DataFrame, feas::Vector{Symbol})
#     numrows = size(df, 1)
#     for fea in feas
#         x = df[!, fea]
#         if fea == :nₛ
#             low = percentile(x, 1)
#             indices = findall(x -> x<low, x)
#         elseif fea == :μₜ
#             high = percentile(x, 99)
#             indices = findall(x -> x>high, x)
#         elseif fea == :varₜ
#             high = percentile(x, 99)
#             indices = findall(x -> x>high, x)
#         elseif fea == :α
#             high = percentile(x, 99)
#             indices = findall(x -> x>high, x)
#         elseif fea == :scale
#             low, high = percentile(x, [1, 99])
#             indices = findall(x -> (x<low) || (x>high), x)
#         end
#         df[indices, fea] .= median(x)
#     end
#     df
# end
