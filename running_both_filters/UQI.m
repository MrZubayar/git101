% UQI Calculation (Universal Quality Index)
function UQI_value = UQI(original_signal, filtered_signal)
    original_mean = mean(original_signal);
    filtered_mean = mean(filtered_signal);
    covariance = mean((original_signal - original_mean) .* (filtered_signal - filtered_mean));
    variance_original = mean((original_signal - original_mean).^2);
    variance_filtered = mean((filtered_signal - filtered_mean).^2);
    UQI_value = (4 * covariance * original_mean * filtered_mean) / ((variance_original + variance_filtered) * (original_mean^2 + filtered_mean^2));
end

