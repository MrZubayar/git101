function AD_value = AD(original_signal, filtered_signal)
    AD_value = mean(abs(filtered_signal - original_signal));
end
