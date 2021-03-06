using .AbstractPlotting

using Colors

extractindices(res::KmeansResult) = [findall(res.assignments .== i) for i ∈ 1:length(res.counts)]
function extractindices(res::Hclust; k=k)
    assignments = cutree(res; k=k)
    [findall(assignments .== i) for i ∈ 1:maximum(assignments)]
end
extractindices(res::Vector{DbscanCluster}) = [c.core_indices for c ∈ res]
extractindices(res::DbscanResult) = [findall(res.assignments .== i) for i ∈ 1:maximum(res.assignments)]

"""
    visualizeclusters(wavpaths, clusterindices, outlierindices, ndisplayperclass)

Display spectrograms of sounds in `wavpaths` according to the clustering result denoted by `clusterindices`
and `outlierindices`. `ndisplayperclass` defines number of spectrogram per class to be displayed. The axes
are blank if `ndisplayperclass` is larger than cluster size. When a mouse is hovering at thecenter of a spectrogram,
the respective sound is played.

# Example:
```julia-repl
julia> using MSRDPReefs, WAV

julia> using AbstractPlotting, GLMakie

julia> ndata, nclass = 100, 3;

julia> root = mktempdir();

julia> data = randn(4800, ndata);

julia> [wavwrite(col, joinpath(root, string(i)*".wav"); Fs=9600) for (i, col) ∈ 
        enumerate(eachcol(data))];

julia> wavpaths = readdir(root, join=true);

julia> clusterindices, outlierindices = [1:9, 10:70, 71:91], 92:ndata;

julia> visualizeclusters(wavpaths, clusterindices, outlierindices, 10)
GLMakie.Screen(...)
```
"""
function visualizeclusters(wavpaths, clusterindices, outlierindices, ndisplayperclass)
    clusternames = [("#" .* string.(1:length(clusterindices)))..., "Outliers"]
    nclass = length(clusternames)
    swidth, sheight = 1200, 900
    scene, layout = layoutscene(resolution = (1200, 900))
    axes = layout[] = [Axis(scene) for i ∈ 1:nclass, j ∈ 1:ndisplayperclass]
    for i ∈ 1:nclass
        indices = i < nclass ? clusterindices[i] : outlierindices
        for j ∈ 1:ndisplayperclass
            if isempty(indices) && (j == 1)
                hidedecorations!(axes[i,j]; label=false)
                #axes[i,j].ylabel = clusternames[i]
            elseif j <= length(indices)
                index = indices[j]
                x = signal(wavpaths[index])
                spec = spectrogram(samples(x[:]), 128, 64; fs=framerate(x))
                heatmap!(axes[i,j], time(spec), freq(spec), pow2db.(power(spec)'); xticklabelsize=10)
                starttime = floor(minimum(time(spec)); digits=1)
                stoptime = floor(maximum(time(spec)); digits=1)
                axes[i,j].xticks = (starttime:stoptime-starttime:stoptime, ["$(starttime)", "$(stoptime)"])
            else
                hidedecorations!(axes[i,j])
            end
            j == 1 ? (hideydecorations!(axes[i,j], label=false, grid=false); axes[i,j].ylabel = clusternames[i]) : hideydecorations!(axes[i,j], grid=false)
        end
    end
    xoffset = (swidth ÷ ndisplayperclass) * 0.3
    yoffset = (sheight ÷ nclass) * 0.1
    xs = range(xoffset, swidth, length = ndisplayperclass+1) 
    ys = range(yoffset, sheight, length = nclass+1) |> reverse
    xstep = swidth ÷ (2 * ndisplayperclass)
    ystep = sheight ÷ (2 * nclass)
    jpos = ys[1:nclass] .- ystep
    ipos = xs[1:ndisplayperclass] .+ xstep
    ijpos = Iterators.product(ipos, jpos)
    maxdisttoplay = min(xstep, ystep)
    on(scene.events.mouseposition) do mpos
        dists = [sqrt(sum(abs2, mpos .- ijp)) for ijp ∈ ijpos]
        minval, minindex = findmin(dists)
        #cindices = clusterindices[minindex.I[2]]
        if minindex.I[2] == nclass
            if isempty(outlierindices) 
                index = Int[]
            else
                index = minindex.I[1] > length(outlierindices) ? Int[] : outlierindices[minindex.I[1]]
            end
        else
            index = minindex.I[1] > length(clusterindices[minindex.I[2]]) ? Int[] : clusterindices[minindex.I[2]][minindex.I[1]]
        end
        if !isempty(index) && (minval < maxdisttoplay)
            println(clusternames[minindex.I[2]])
            wavpath = wavpaths[index]
            wavplay(wavpath)
        end
    end
    display(scene)
end

"""
    visualizeclusters(wavpaths, res, ndisplayperclass)

Display spectrograms of sounds in `wavpaths` according to the clustering result `res`.
`ndisplayperclass` defines number of spectrogram per class to be displayed. The axes are blank if 
`ndisplayperclass` is larger than cluster size. When a mouse is hovering at thecenter of a spectrogram,
the respective sound is played.

# Examples:
```julia-repl
julia> using Clustering, MSRDPReefs, WAV

julia> using AbstractPlotting, GLMakie

julia> ndata, nclass = 100, 3;

julia> root = mktempdir();

julia> data = randn(4800, ndata);

julia> [wavwrite(col, joinpath(root, string(i)*".wav"); Fs=9600) for (i, col) ∈ 
        enumerate(eachcol(data))];

julia> wavpaths = readdir(root, join=true);

julia> res = kmeans(data, nclass);

julia> visualizeclusters(wavpaths, res, 10)
GLMakie.Screen(...)
```
"""
function visualizeclusters(wavpaths, res, ndisplayperclass; kwargs...)
    clusterindices = extractindices(res; kwargs...)
    outlierindices = [outlierindex for outlierindex ∈ 1:length(wavpaths) 
                      if outlierindex ∉ [index for cindices ∈ clusterindices for index ∈ cindices]]
    visualizeclusters(wavpaths, clusterindices, outlierindices, ndisplayperclass)
end

function specgram_scatter!(ax,
                           x::AbstractVector{T}, 
                           y::AbstractVector{T}, 
                           spec::AbstractVector{DT}; 
                           kwargs...) where {T<:Real,DT<:AbstractMatrix} 
    # spec = [(p=spectrogram(d, nfft, noverlap; fs=fs).power; 
    #         Gray.(Float32.((p .- minimum(p)) ./ (maximum(p)-minimum(p))))) for d in data]
    ns = size.(spec,2)
    for n ∈ unique(ns)
        samesizeindices = findall(n .== ns)
        for inds in Iterators.partition(samesizeindices, 400)
            # subindices = indices[inds]
            #markersizes = [s ./ 100 for s ∈ size.(spec[subindices],2)]
            AbstractPlotting.scatter!(ax, 
                                    x[inds], 
                                    y[inds]; 
                                    marker=spec[inds], 
                                    #markersize=markersizes,
                                    markerspace=SceneSpace,
                                    kwargs...)
        end
    end
end

"""
    specgram_scatter(x, y, data; fs=1, nfft=256, noverlap=128, kwargs...)

Plot a scatter plot with each point is a spectrogram of a WAV file from data.

# Examples:
```julia-repl
julia> using MSRDPReefs, WAV

julia> using AbstractPlotting, GLMakie

julia> root = mktempdir();

julia> [wavwrite(randn(4800), joinpath(root, string(i)*".wav"); Fs=9600) for i ∈ 1:20];

julia> wavpaths = readdir(root, join=true);

julia> X = randn(2, length(wavpaths));

julia> specgram_scatter(X[1,:], X[2,:], wavpaths; fs=9600)
GLMakie.Screen(...)
```
"""
function specgram_scatter(x::AbstractVector{T}, 
                          y::AbstractVector{T}, 
                          data::AbstractVector{DT}; 
                          fs=1, 
                          nfft::Integer=256, 
                          noverlap::Integer=128,
                          kwargs...) where {T<:Real,DT<:AbstractString}
    spec = [(p=spectrogram(vec(first(wavread(d))), nfft, noverlap; fs=fs).power; 
             Gray.(Float32.((p .- minimum(p)) ./ (maximum(p)-minimum(p))))) for d in data]
    fig = Figure(resolution=(1600, 1000))
    ax = fig[1,1] = Axis(fig)
    specgram_scatter!(ax, x, y, spec; kwargs...)
    on(ax.scene.events.keyboardbuttons) do button
        if ispressed(button, Keyboard.s)
            #on(ax.scene.events.mouseposition) do mpos
            mpos = ax.scene.events.mouseposition[]
            xm, ym = Point2f0(mpos) |> x->to_world(ax.scene,x) |> Tuple
            # xm, ym = scene.events.mouseposition
            dist, index = findmin(sqrt.((x .- xm).^2 .+ (y .- ym).^2))
            @info "($(xm), $(ym)), ($(x[index]), $(y[index]))"
            if dist ≤ 0.1
                file = data[index]
                wavplay(file)
            end
            # end
        end
    end
    display(fig)
end

"""
    specgram_scatter(x, y, data; fs=1, nfft=256, noverlap=128, kwargs...)

Plot a scatter plot with each point is a spectrogram of a signal from data.

# Examples:
```julia-repl
julia> using MSRDPReefs

julia> using AbstractPlotting, GLMakie

julia> data = [randn(4800) for i ∈ 1:20];

julia> X = randn(2, length(data));

julia> specgram_scatter(X[1,:], X[2,:], data; fs=9600)
GLMakie.Screen(...)
```
"""
function specgram_scatter(x::AbstractVector{T}, 
                          y::AbstractVector{T}, 
                          data::AbstractVector{DT}; 
                          fs=1, 
                          nfft::Integer=256, 
                          noverlap::Integer=128,
                          kwargs...) where {T<:Real,DT<:AbstractVector{<:Real}} 
    spec = [(p=spectrogram(d, nfft, noverlap; fs=fs).power; 
             Gray.(Float32.((p .- minimum(p)) ./ (maximum(p)-minimum(p))))) for d in data]
    specgram_scatter(x, y, spec; kwargs...)
end