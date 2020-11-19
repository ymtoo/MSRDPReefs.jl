function removedc_whiten_lpf_resample(x::AbstractVector{T}, 
                                      fs=acousticsamplingrate(); 
                                      lpfreq=4800, 
                                      rate=1//10) where {T<:Real}
    x = removedc(x .- median(x))
    x = whiten(x, 8192, 0)
    σ = mad(x)
    x = MemorylessNonlinearities.filt(CauchyNL(1 * σ), x)
#    d = AlphaStableDistributions.fit(SymmetricAlphaStable, x)
#    x = MemorylessNonlinearities.filt(SαS(d.α, d.scale, d.location), x)
    lpf = digitalfilter(Lowpass(lpfreq; fs=fs), FIRWindow(hanning(127)))
    resample(filtfilt(lpf, x), rate)
end