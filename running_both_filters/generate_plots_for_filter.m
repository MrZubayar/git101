function generate_plots_for_filter(filter_name, filtered_signal, signal, P, original_signal, selected_signal_type)
    mean_filtered_signal = mean(filtered_signal, 3);
    bias = mean_filtered_signal - signal';  % Use the original clean signal to calculate bias
    variance = var(filtered_signal, 0, 3);
    standard_deviation = sqrt(variance);

    mean_bias = mean(bias, 1);
    mean_variance = mean(variance, 1);
    mean_std_dev = mean(standard_deviation, 1);

    summary_str = sprintf('Bias: %.3g, Variance: %.3g, Std Dev: %.3g', mean(mean_bias), mean(mean_variance), mean(mean_std_dev));

    snr_values = quality_evaluation_metrics('SNR', filtered_signal, original_signal, P);
    rmse_values = quality_evaluation_metrics('RMSE', filtered_signal, original_signal, P);
    psnr_values = quality_evaluation_metrics('PSNR', filtered_signal, original_signal, P);
    md_values = quality_evaluation_metrics('MD', filtered_signal, original_signal, P);
    ad_values = quality_evaluation_metrics('AD', filtered_signal, original_signal, P);
    nk_values = quality_evaluation_metrics('NK', filtered_signal, original_signal, P);
    nae_values = quality_evaluation_metrics('NAE', filtered_signal, original_signal, P);
    uqi_values = quality_evaluation_metrics('UQI', filtered_signal, original_signal, P);
    sc_values = quality_evaluation_metrics('SC', filtered_signal, original_signal, P);
    mssim_values = quality_evaluation_metrics('MSSIM', filtered_signal, original_signal, P);

    % Call your plotting function here, passing `selected_signal_type`
    plot_and_save_figures(filter_name, signal, original_signal, mean_filtered_signal, ...
                          bias, variance, standard_deviation, summary_str, ...
                          P, snr_values, rmse_values, psnr_values, ...
                          md_values, ad_values, nk_values, nae_values, ...
                          uqi_values, sc_values, mssim_values, selected_signal_type);
end
