function generate_plots_for_filter(filter_name, filtered_signal, signal, P, original_signal, selected_signal_type, noise_level)
    mean_filtered_signal = mean(filtered_signal, 3);
    bias = mean_filtered_signal - signal';  % Use the original clean signal to calculate bias
    variance = var(filtered_signal, 0, 3);
    standard_deviation = sqrt(variance);

    mean_bias = mean(bias, 1);
    mean_variance = mean(variance, 1);
    mean_std_dev = mean(standard_deviation, 1);

    summary_str = sprintf('Bias: %.3g, Variance: %.3g, Std Dev: %.3g', mean(mean_bias), mean(mean_variance), mean(mean_std_dev));

    % Only calculate SNR
    snr_values = quality_evaluation_metrics('SNR', filtered_signal, original_signal, P);

    % Call your plotting function here, passing only SNR values and other necessary data
    plot_and_save_figures(filter_name, signal, original_signal, mean_filtered_signal, ...
                          bias, variance, standard_deviation, summary_str, ...
                          P, snr_values, selected_signal_type, noise_level);

    % Write the LaTeX table for SNR values
    WriteQualityMetricsTable(P, snr_values);
end
