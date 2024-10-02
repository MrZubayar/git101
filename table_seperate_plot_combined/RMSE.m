% RMSE Calculation (Root Mean Square Error)
function RMSE_value = RMSE(original_signal, filtered_signal)
    RMSE_value = sqrt(mean((original_signal - filtered_signal).^2));
end

