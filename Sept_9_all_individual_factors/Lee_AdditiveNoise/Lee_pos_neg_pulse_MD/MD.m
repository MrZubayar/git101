% MD Calculation (Maximum Difference)
function MD_value = MD(original_signal, filtered_signal)
    MD_value = max(abs(filtered_signal - original_signal));
end

