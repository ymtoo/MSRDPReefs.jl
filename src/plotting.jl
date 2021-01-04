function plot(df::DataFrame, featuresymbol::Symbol, dtranges::Vector{Tuple{DateTime, DateTime}}; color="blue")
    plts = []
    for (i, dtrange) in enumerate(dtranges)
        rowindices = (df[!, :datetime] .>= dtrange[1]) .&
                   (df[!, :datetime] .<= dtrange[2])
        trace = PlotlyJS.scatter(x=df[rowindices, :datetime],
                         y=df[rowindices, featuresymbol],
                         line=attr(color=color),
                         mode="lines",
                         showlegend=false,
                         xaxis="x$i",
                         yaxis="y$i")
        push!(plts, PlotlyJS.plot(trace, Layout(yaxis=attr(title=string(featuresymbol)), title="D$i")))
    end
    vcat(plts...)
end

function plot!(p::PlotlyJS.SyncPlot, df::DataFrame, featuresymbol::Symbol, dtranges::Vector{Tuple{DateTime, DateTime}}; color="blue")
    for (i, dtrange) in enumerate(dtranges)
        rowindices = (df[!, :datetime] .>= dtrange[1]) .&
                   (df[!, :datetime] .<= dtrange[2])
        trace = PlotlyJS.scatter(x=df[rowindices, :datetime],
                         y=df[rowindices, featuresymbol],
                         line=attr(color=color),
                         mode="lines",
                         showlegend=false,
                         xaxis="x$i",
                         yaxis="y$i")
        addtraces!(p, i, trace)
    end
    p
end

spidxfilters = Dict(:redlight => x -> x .> 10,
                    :greenlight => x -> x .> 10,
                    :bluelight => x -> x .> 10)

function scatterplot(df::DataFrame; spidxfilters::Dict=spidxfilters, color="blue")
    feanames = names(df)
    filternames = keys(spidxfilters)
    numfeas = length(feanames)
    traces = AbstractTrace[]
    l = Layout()
    domain = range(0.0, 1.0, length=numfeas+1)
    xspace = (domain[2]-domain[1])/20
    yspace = (domain[2]-domain[1])/20
    for (i, colname) in enumerate(feanames)
        for (j, rowname) in enumerate(feanames)
            idx = (i-1)*numfeas+j
            (colname in filternames) ? (yindices=spidxfilters[colname](df[!, colname])) : yindices=BitArray(ones(size(df, 1)))
            (rowname in filternames) ? (xindices=spidxfilters[rowname](df[!, rowname])) : xindices=BitArray(ones(size(df, 1)))
            retainindices = yindices .& xindices
            # get trace
            if i != j
                trace = PlotlyJS.histogram2dcontour(x=df[retainindices, rowname],
                                           y=df[retainindices, colname],
                                           nbinsx=50,
                                           nbinsy=50,
                                           showscale=false,
                                           mode="markers",
                                           showlegend=false,
                                           xaxis="x$(idx)",
                                           yaxis="y$(idx)")
            else
                trace = PlotlyJS.histogram(x=df[retainindices, rowname],
                                           showlegend=false,
                                           marker_color=color,
                                           xaxis="x$(idx)",
                                           yaxis="y$(idx)")
            end
            push!(traces, trace)
            # get layout
            xax = Dict(:domain => [domain[j], domain[j+1]-xspace],
                       :showticklabels => false)
            yax = Dict(:domain => [domain[i], domain[i+1]-yspace],
                       :showticklabels => false)
            if (i == 1) && (j == 1)
                push!(xax, :title => string(rowname))
                push!(yax, :title => string(colname))
            elseif i == 1
                push!(xax, :title => string(rowname))
            elseif j == 1
                push!(yax, :title => string(colname))
            else
            end
            push!(l.fields, Symbol("xaxis$(idx)") => xax)
            push!(l.fields, Symbol("yaxis$(idx)") => yax)
        end
    end
    push!(l.fields, :width => 1000)
    push!(l.fields, :height => 1000)
    PlotlyJS.plot(traces, l)
end