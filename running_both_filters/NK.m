% NK Calculation (Normalized Cross-Correlation)
function NK_value = NK(original_signal, filtered_signal)
    NK_value = sum(original_signal .* filtered_signal) / sum(original_signal.^2);
end

