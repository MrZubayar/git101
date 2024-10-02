function generate_plots_for_filter(filter_name, filtered_signal, signal, P, original_signal, selected_signal_type, noise_level, noise_level_vector, selected_metric)
    mean_filtered_signal = mean(filtered_signal, 3);
    bias = mean_filtered_signal - signal';  % Use the original clean signal to calculate bias
    variance = var(filtered_signal, 0, 3);
    standard_deviation = sqrt(variance);

    mean_bias = mean(bias, 1);
    mean_variance = mean(variance, 1);
    mean_std_dev = mean(standard_deviation, 1);

    summary_str = sprintf('Bias: %.3g, Variance: %.3g, Std Dev: %.3g', mean(mean_bias), mean(mean_variance), mean(mean_std_dev));

    % Calculate the selected metric
    metric_values = quality_evaluation_metrics(selected_metric, filtered_signal, original_signal, P);

    % Store the metric values in a persistent variable
    persistent metric_data;
    if isempty(metric_data)
        metric_data = struct('M_values', P.Lee.M_values, 'metric', []);
    end
    metric_data.metric = [metric_data.metric, mean(metric_values, 2)];

    % Check if this is the last noise level
    if noise_level == noise_level_vector(end)
        write_metric_to_tex(metric_data, filter_name, selected_signal_type, noise_level_vector, selected_metric);
        clear metric_data;  % Clear the persistent variable for the next run
    end

    % Call your plotting function here, passing only the metric values and other necessary data
    plot_and_save_figures(filter_name, signal, original_signal, mean_filtered_signal, ...
                          bias, variance, standard_deviation, summary_str, ...
                          P, metric_values, selected_signal_type, noise_level, selected_metric);
end
