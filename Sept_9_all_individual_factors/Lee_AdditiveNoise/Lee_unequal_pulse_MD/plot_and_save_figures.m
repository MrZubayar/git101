function plot_and_save_figures(filter_name, signal, original_signal, mean_filtered_signal, ...
                               bias, variance, standard_deviation, summary_str, P, ...
                               metric_values, selected_signal_type, noise_level, selected_metric)
    % Define legend for filter sizes
    leg = {};
    for ii = 1:length(P.Lee.M_values)
        leg{ii} = ['M = ', int2str(P.Lee.M_values(ii))];
    end

    output_dir = 'SavedFigures';
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    generate_filename = @(basename, plot_number, ext) fullfile(output_dir, sprintf('%02d_%s_%s_%s_noise_%.2f.%s', plot_number, basename, filter_name, selected_signal_type, noise_level, ext));

    figures = {};
    filenames_png = {};

    file_counter = 1;

    valid_range = 1:(P.noOfSamples - P.noOfTranscendSamples);

    %%
    % 1. Plot the original signal and noisy signal together
    fig1 = figure;
    plot(valid_range, signal(valid_range), 'k--'); hold on;
    plot(valid_range, mean(original_signal(valid_range, :), 2), 'r');
    title(strrep(sprintf('Original and Noisy Signals (Noise: %.2f) (%s) using %s Filter\n [%s]', noise_level, selected_signal_type, filter_name, summary_str),'_','\_'));
    xlabel('Sample Index');
    ylabel('Signal Value');
    legend('Original Signal', 'Noisy Signal', 'Location', 'southeast');
    grid on;
    figures{end+1} = fig1;
    filenames_png{end+1} = generate_filename('Original_Noise_Signal', file_counter, 'png');
    file_counter = file_counter + 1;

    % 2. Plot the mean filtered signals
    fig2 = figure;
    plot(valid_range, mean_filtered_signal(valid_range, :));
    title(strrep(sprintf('Mean Filtered Signals (Noise: %.2f) (%s) using %s Filter\n [%s]', noise_level, selected_signal_type, filter_name, summary_str),'_','\_'));
    xlabel('Sample Index');
    ylabel('Signal Value');
    legend(leg{:}, 'Location', 'southeast');
    grid on;
    figures{end+1} = fig2;
    filenames_png{end+1} = generate_filename('Mean_Filtered_Signal', file_counter, 'png');
    file_counter = file_counter + 1;

    % 3. Plot the bias for each filter size
    fig3 = figure;
    plot(valid_range, bias(valid_range, :));
    title(strrep(sprintf('Bias of Filtered Signal (Noise: %.2f) (%s) using %s Filter\n [%s]', noise_level, selected_signal_type, filter_name, summary_str),'_','\_'));
    xlabel('Sample Index');
    ylabel('Bias');
    legend(leg, 'Location', 'northeast');
    grid on;
    figures{end+1} = fig3;
    filenames_png{end+1} = generate_filename('Bias_Filtered_Signal', file_counter, 'png');
    file_counter = file_counter + 1;

    % 4. Plot the variance for each filter size
    fig4 = figure;
    plot(valid_range, variance(valid_range, :));
    title(strrep(sprintf('Variance of Filtered Signal (Noise: %.2f) (%s) using %s Filter\n [%s]', noise_level, selected_signal_type, filter_name, summary_str),'_','\_'));
    xlabel('Sample Index');
    ylabel('Variance');
    legend(leg, 'Location', 'northeast');
    grid on;
    figures{end+1} = fig4;
    filenames_png{end+1} = generate_filename('Variance_Filtered_Signal', file_counter, 'png');
    file_counter = file_counter + 1;

    % 5. Plot the standard deviation for each filter size
    fig5 = figure;
    plot(valid_range, standard_deviation(valid_range, :));
    title(strrep(sprintf('Standard Deviation of Filtered Signal (Noise: %.2f) (%s) using %s Filter\n [%s]', noise_level, selected_signal_type, filter_name, summary_str),'_','\_'));
    xlabel('Sample Index');
    ylabel('Standard Deviation');
    legend(leg, 'Location', 'northeast');
    grid on;
    figures{end+1} = fig5;
    filenames_png{end+1} = generate_filename('StdDev_Filtered_Signal', file_counter, 'png');
    file_counter = file_counter + 1;

    % 6. Plot the Mean Bias, Variance, and Std Dev
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
    filenames_png{end+1} = generate_filename('Mean_Bias_Variance_StdDev', file_counter, 'png');
    file_counter = file_counter + 1;

    %% Plotting Quality Metrics

    % 7. Plot the selected metric across different M values
    fig7 = figure;
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
    figures{end+1} = fig7;
    filenames_png{end+1} = generate_filename(selected_metric, file_counter, 'png');
    file_counter = file_counter + 1;

    %% Save All Figures
    for i = 1:length(figures)
        exportgraphics(figures{i}, filenames_png{i}, 'Resolution', 600);  % Save as PNG
    end
    fprintf('All figures have been saved.\n');
end
