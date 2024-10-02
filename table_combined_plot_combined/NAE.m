% NAE Calculation (Normalized Absolute Error)
function NAE_value = NAE(original_signal, filtered_signal)
    NAE_value = sum(abs(filtered_signal - original_signal)) / sum(abs(original_signal));
end

