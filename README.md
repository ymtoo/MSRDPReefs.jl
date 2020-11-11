# MSRDPReefs

This package provides functions to load and display acoustic data and the corresponding metadata

The implemented constants and functions are:

ACOUSTICSAMPLINGRATE: samling rate of the acoustic data

acousticsamplingrate: Get sampling rate of the acoustic data

getpaths: Get parent paths. The output is a 1-D array conataining paths for data (acoustic and environmental) collected in all the sites.

DEFAULTDTRANGES: Default datetime range of the collected data. The output is a 2-element tuple with the first element is the start datetime and the second element is the end datetime.

SITEDTRANGESS: Datetime ranges of the collected data at all the sites. The output is a dictonary with each key is a site name and the corresponding value is a default datetime range of the collected data at the site.

COLUMNNAMES: Column names. The output is a 1-D array containing column names of the metadata.

COLUMNTYPES: Column types. The output is a 1-D array containing column types of the metadata

Metadata: Metadata describing the collected data at a particular site. The output is a Metadata (a new type) containing a root path of the data, a site name, a datatime range and a metadata DataFrame.

MetadataAll: Metadata describing all the collected data. The output is a MetadataAll (a new type) containing a root path of the data, a datatime range and a metadata DataFrame.

datacollectionprogress: Estimate the progress of the data collection. The output is a DataFrame displaying percentages of the data colllected with respect to the sites and the deployments (D1, D2, D3, D4, D5, D6). Hundred percent denotes 30 days data collected.

## Usage
```julia
julia> using MSRDPReefs

julia> root = "/mnt/arl-nas-01/msrdp-reef-monitoring/recordings"

julia> dirs = readdir(root)

julia> paths = [joinpath(root, dir) for dir in dirs if dir ∉ ["Semakau-NE", "README.md"]]

julia> mdata = Metadata(paths[1])

julia> mdataall = MetadataAll(paths)

julia> datacollectionprogress(root)
```
