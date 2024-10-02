% PSNR Calculation (Peak Signal-to-Noise Ratio)
function PSNR_value = PSNR(original_signal, filtered_signal)
    RMSE_value = RMSE(original_signal, filtered_signal);
    PSNR_value = 20 * log10(255 / RMSE_value);
end

