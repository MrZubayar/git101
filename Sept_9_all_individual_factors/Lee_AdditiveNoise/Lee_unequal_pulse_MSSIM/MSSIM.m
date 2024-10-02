% MSSIM Calculation (Mean Structural Similarity Index)
function MSSIM_value = MSSIM(original_signal, filtered_signal)
    C1 = (0.01 * 255)^2;
    C2 = (0.03 * 255)^2;
    mean_original = mean(original_signal);
    mean_filtered = mean(filtered_signal);
    var_original = var(original_signal);
    var_filtered = var(filtered_signal);
    covariance = mean((original_signal - mean_original) .* (filtered_signal - mean_filtered));
    SSIM_map = ((2 * mean_original * mean_filtered + C1) * (2 * covariance + C2)) / ((mean_original^2 + mean_filtered^2 + C1) * (var_original + var_filtered + C2));
    MSSIM_value = mean(SSIM_map);
end