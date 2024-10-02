function metric_values = generate_metric_plots(filter_name, filtered_signal, signal, P, original_signal, selected_signal_type, noise_level, selected_metric)
    % Calculate the selected metric
    metric_values = quality_evaluation_metrics(selected_metric, filtered_signal, original_signal, P);

    % Plotting Quality Metrics

    % 7. Plot the selected metric across different M values
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

    % Save the figure
    output_dir = 'SavedFigures';
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end
    filename = fullfile(output_dir, sprintf('07_%s_%s_%s_noise_%.2f.png', selected_metric, filter_name, selected_signal_type, noise_level));
    exportgraphics(fig, filename, 'Resolution', 600);  % Save as PNG
    fprintf('Metric figure %s has been saved.\n', filename);
end

