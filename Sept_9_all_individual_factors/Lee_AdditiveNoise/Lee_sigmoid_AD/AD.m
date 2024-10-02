% AD Calculation (Average Difference)
function AD_value = AD(original_signal, filtered_signal)
    AD_value = mean(filtered_signal - original_signal);
end

