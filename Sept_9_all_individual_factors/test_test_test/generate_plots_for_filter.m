function generate_plots_for_filter(filter_name, filtered_signal, signal, P, original_signal, selected_signal_type, noise_level, noise_level_vector, quality_metrics)
    % Calculate and plot the bias, variance, and standard deviation for the filtered signal
    mean_filtered_signal = mean(filtered_signal, 3);
    bias = mean_filtered_signal - signal';  % Use the original clean signal to calculate bias
    variance = var(filtered_signal, 0, 3);
    standard_deviation = sqrt(variance);

    mean_bias = mean(bias, 1);
    mean_variance = mean(variance, 1);
    mean_std_dev = mean(standard_deviation, 1);

    summary_str = sprintf('Bias: %.3g, Variance: %.3g, Std Dev: %.3g', mean(mean_bias), mean(mean_variance), mean(mean_std_dev));

    % Prepare for plotting
    figures = {};  % Store figure handles
    filenames_png = {};  % Store corresponding filenames
    file_counter = 1;

    % Define legend for filter sizes
    leg = {};
    for ii = 1:length(P.Lee.M_values)
        leg{ii} = ['M = ', int2str(P.Lee.M_values(ii))];
    end

    output_dir = 'SavedFigures';
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    generate_filename = @(basename) fullfile(output_dir, sprintf('%02d_%s_%s_%s_noise_%.2f.png', file_counter, basename, filter_name, selected_signal_type, noise_level));
    valid_range = 1:(P.noOfSamples - P.noOfTranscendSamples);

    %% Plot 1: Original and Noisy Signal
    fig1 = figure;
    plot(valid_range, signal(valid_range), 'k--'); hold on;
    plot(valid_range, mean(original_signal(valid_range, :), 2), 'r');
    title(strrep(sprintf('Original and Noisy Signals (Noise: %.2f) (%s) using %s Filter\n [%s]', noise_level, selected_signal_type, filter_name, summary_str),'_','\_'));
    xlabel('Sample Index');
    ylabel('Signal Value');
    legend('Original Signal', 'Noisy Signal', 'Location', 'southeast');
    grid on;
    figures{end+1} = fig1;
    filenames_png{end+1} = generate_filename('Original_Noise_Signal');
    file_counter = file_counter + 1;

    %% Plot 2: Mean Filtered Signal
    fig2 = figure;
    plot(valid_range, mean_filtered_signal(valid_range, :));
    title(strrep(sprintf('Mean Filtered Signals (Noise: %.2f) (%s) using %s Filter\n [%s]', noise_level, selected_signal_type, filter_name, summary_str),'_','\_'));
    xlabel('Sample Index');
    ylabel('Signal Value');
    legend(leg{:}, 'Location', 'southeast');
    grid on;
    figures{end+1} = fig2;
    filenames_png{end+1} = generate_filename('Mean_Filtered_Signal');
    file_counter = file_counter + 1;

    %% Plot 3: Bias
    fig3 = figure;
    plot(valid_range, bias(valid_range, :));
    title(strrep(sprintf('Bias of Filtered Signal (Noise: %.2f) (%s) using %s Filter\n [%s]', noise_level, selected_signal_type, filter_name, summary_str),'_','\_'));
    xlabel('Sample Index');
    ylabel('Bias');
    legend(leg, 'Location', 'northeast');
    grid on;
    figures{end+1} = fig3;
    filenames_png{end+1} = generate_filename('Bias_Filtered_Signal');
    file_counter = file_counter + 1;

    %% Plot 4: Variance
    fig4 = figure;
    plot(valid_range, variance(valid_range, :));
    title(strrep(sprintf('Variance of Filtered Signal (Noise: %.2f) (%s) using %s Filter\n [%s]', noise_level, selected_signal_type, filter_name, summary_str),'_','\_'));
    xlabel('Sample Index');
    ylabel('Variance');
    legend(leg, 'Location', 'northeast');
    grid on;
    figures{end+1} = fig4;
    filenames_png{end+1} = generate_filename('Variance_Filtered_Signal');
    file_counter = file_counter + 1;

    %% Plot 5: Standard Deviation
    fig5 = figure;
    plot(valid_range, standard_deviation(valid_range, :));
    title(strrep(sprintf('Standard Deviation of Filtered Signal (Noise: %.2f) (%s) using %s Filter\n [%s]', noise_level, selected_signal_type, filter_name, summary_str),'_','\_'));
    xlabel('Sample Index');
    ylabel('Standard Deviation');
    legend(leg, 'Location', 'northeast');
    grid on;
    figures{end+1} = fig5;
    filenames_png{end+1} = generate_filename('StdDev_Filtered_Signal');
    file_counter = file_counter + 1;

    %% Plot 6: Mean Bias, Variance, and Std Dev
    fig6 = figure;
    plot(valid_range, mean(bias(valid_range, :), 2), 'b'); hold on;
    plot(valid_range, mean(variance(valid_range, :), 2), 'g');
    plot(valid_range, mean(standard_deviation(valid_range, :), 2), 'm');
    title(strrep(sprintf('Mean Bias, Variance, and Std Dev (Noise: %.2f) (%s) using %s Filter\n [%s]', noise_level, selected_signal_type, filter_name, summary_str),'_','\_'));
    xlabel('Sample Index');
    ylabel('Value');
    legend({'Mean Bias', 'Mean Variance', 'Mean Std Dev'}, 'Location', 'northeast');
    grid on;
    figures{end+1} = fig6;
    filenames_png{end+1} = generate_filename('Mean_Bias_Variance_StdDev');
    file_counter = file_counter + 1;

    %% Calculate and plot each quality metric
    for mm = 1:length(quality_metrics)
        selected_metric = quality_metrics{mm};
        metric_values = quality_evaluation_metrics(selected_metric, filtered_signal, original_signal, P);

        % Plotting the metric values
        fig = figure;
        hold on;
        for rr = 1:P.nRand
            plot(P.Lee.M_values, metric_values(:, rr), 'Color', [0.8, 0.8, 0.8]);
        end
        plot(P.Lee.M_values, mean(metric_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');
        title(strrep(sprintf('Mean %s (Noise: %.2f) across Realizations for Different M Values \n (%s) using %s Filter', selected_metric, noise_level, selected_signal_type, filter_name),'_','\_'));
        xlabel('M Value');
        ylabel(sprintf('%s (dB)', selected_metric));
        xticks(P.Lee.M_values);
        grid on;
        legend({'Individual Realizations', sprintf('Mean %s', selected_metric)}, 'Location', 'northeast');
        figures{end+1} = fig;
        filenames_png{end+1} = generate_filename(selected_metric);
        file_counter = file_counter + 1;
    end

    %% Save all figures to the specified folder
    if ~isempty(figures)
        for i = 1:length(figures)
            exportgraphics(figures{i}, filenames_png{i}, 'Resolution', 300);
        end
        fprintf('All figures saved in %s folder.\n', output_dir);
    end
end
