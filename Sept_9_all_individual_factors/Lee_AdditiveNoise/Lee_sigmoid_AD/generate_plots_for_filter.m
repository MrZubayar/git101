function generate_plots_for_filter(filter_name, filtered_signal, signal, P, original_signal, selected_signal_type, noise_level, noise_level_vector, selected_metric)
    % Calculate and plot the bias, variance, and standard deviation for the filtered signal
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

    % Write the metric values to a LaTeX table immediately after calculation
    write_metric_to_tex(P.Lee.M_values, metric_values, filter_name, selected_signal_type, noise_level_vector, selected_metric);

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

    %% Plot 7: AD Metric
    fig7 = figure;
    hold on;

    for rr = 1:P.nRand
        plot(P.Lee.M_values, metric_values(:, rr), 'Color', [0.8, 0.8, 0.8]);
    end

    plot(P.Lee.M_values, mean(metric_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

    title(strrep(sprintf('Mean %s (Noise: %.2f) across Realizations for Different M Values \n (%s) using %s Filter', selected_metric, noise_level, selected_signal_type, filter_name),'_','\_'));
    xlabel('M Value');
    ylabel(sprintf('%s', selected_metric)); % Correctly label the metric being plotted
    xticks(P.Lee.M_values);
    grid on;
    legend({'Individual Realizations', sprintf('Mean %s', selected_metric)}, 'Location', 'northeast');
    figures{end+1} = fig7;
    filenames_png{end+1} = generate_filename(selected_metric);
    file_counter = file_counter + 1;

    %% Save All Figures
    for i = 1:length(figures)
        exportgraphics(figures{i}, filenames_png{i}, 'Resolution', 600);  % Save as PNG
    end
    fprintf('All figures have been saved.\n');
end

function write_metric_to_tex(M_values, metric_values, filter_name, signal_type, noise_level_vector, selected_metric)
    % Define the filename
    filename = sprintf('%s_%s_%s_Combined.tex', filter_name, signal_type, selected_metric);
    
    % Open file for writing
    fid = fopen(filename, 'w');
    
    % Define column headings
    H = [{'M Value'}, arrayfun(@(x) sprintf('Noise %.2f', x), noise_level_vector, 'UniformOutput', false)];
    
    % Prepare data to be written
    A = cell(length(M_values), length(noise_level_vector) + 1);
    for i = 1:length(M_values)
        A{i, 1} = sprintf('%d', M_values(i));  % M value
        for j = 1:length(noise_level_vector)
            A{i, j + 1} = sprintf('%.2f', metric_values(i, j));
        end
    end
    
    % Write the LaTeX table using the WriteTable function
    WriteTable(fid, A, [], H, sprintf('%s Values for %s with %s across Different Noise Levels', selected_metric, filter_name, signal_type), '\small');
    
    % Close the file
    fclose(fid);
    
    fprintf('Combined %s values saved to %s\n', selected_metric, filename);
end




%%
% function generate_plots_for_filter(filter_name, filtered_signal, signal, P, original_signal, selected_signal_type, noise_level, noise_level_vector, selected_metric)
%     mean_filtered_signal = mean(filtered_signal, 3);
%     bias = mean_filtered_signal - signal';  % Use the original clean signal to calculate bias
%     variance = var(filtered_signal, 0, 3);
%     standard_deviation = sqrt(variance);
% 
%     mean_bias = mean(bias, 1);
%     mean_variance = mean(variance, 1);
%     mean_std_dev = mean(standard_deviation, 1);
% 
%     summary_str = sprintf('Bias: %.3g, Variance: %.3g, Std Dev: %.3g', mean(mean_bias), mean(mean_variance), mean(mean_std_dev));
% 
%     % Calculate the selected metric
%     metric_values = quality_evaluation_metrics(selected_metric, filtered_signal, original_signal, P);
% 
%     % Store the metric values in a persistent variable
%     persistent metric_data;
%     if isempty(metric_data)
%         metric_data = struct('M_values', P.Lee.M_values, 'metric', []);
%     end
%     metric_data.metric = [metric_data.metric, mean(metric_values, 2)];
% 
%     % Check if this is the last noise level
%     if noise_level == noise_level_vector(end)
%         write_metric_to_tex(metric_data, filter_name, selected_signal_type, noise_level_vector, selected_metric);
%         clear metric_data;  % Clear the persistent variable for the next run
%     end
% 
%     % Call your plotting function here, passing only the metric values and other necessary data
%     plot_and_save_figures(filter_name, signal, original_signal, mean_filtered_signal, ...
%                           bias, variance, standard_deviation, summary_str, ...
%                           P, metric_values, selected_signal_type, noise_level, selected_metric);
% end
