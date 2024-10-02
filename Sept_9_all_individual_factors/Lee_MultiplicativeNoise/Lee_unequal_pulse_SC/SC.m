% SC Calculation (Structural Content)
function SC_value = SC(original_signal, filtered_signal)
    SC_value = sum(original_signal.^2) / sum(filtered_signal.^2);
end

