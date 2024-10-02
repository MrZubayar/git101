% SNR Calculation (Signal-to-Noise Ratio)
function SNR_value = SNR(original_signal, filtered_signal)
    SNR_value = 10 * log10(sum(original_signal.^2) / sum((original_signal - filtered_signal).^2));
end

