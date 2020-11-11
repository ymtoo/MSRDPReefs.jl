function removedc_whiten_lpf_resample(x::AbstractVector{T}, 
                                      fs=acousticsamplingrate(); 
                                      lpfreq=4800, 
                                      rate=1//10) where {T<:Real}
    x = removedc(x .- median(x))
    x = whiten(x, 8192, 0)
#    d = AlphaStableDistributions.fit(SymmetricAlphaStable, x)
#    x = MemorylessNonlinearities.filt(SαS(d.α, d.scale, d.location), x)
    σ = mad(x)
    x = MemorylessNonlinearities.filt(Clipping(σ), x)
    lpf = digitalfilter(Lowpass(4800; fs=fs), FIRWindow(hanning(127)))
    x = resample(filtfilt(lpf, x), 1//10)
end