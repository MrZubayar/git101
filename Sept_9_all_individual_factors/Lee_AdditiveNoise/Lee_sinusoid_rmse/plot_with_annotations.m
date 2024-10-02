function plot_with_annotations(metric_values, metric_name, P, selected_signal_type, selected_filtering_technique)
    figure;
    plot(P.Lee.M_values, mean(metric_values, 2), '-o');  % Plot the mean metric across realizations for each M
    title(strrep(sprintf('Mean %s (Var: %.2f) across Realizations for Different M Values (%s) using %s Filter', metric_name, P.signal_variance, selected_signal_type, selected_filtering_technique), '_', '\_'));
    xlabel('M Value');
    ylabel(sprintf('Mean %s', metric_name));
    grid on;
    legend(metric_name, 'Location', 'northeast');
    % Annotate the plot with the average values
    for i = 1:length(P.Lee.M_values)
        text(P.Lee.M_values(i), mean(metric_values(i, :)), sprintf('%.2f', mean(metric_values(i, :))), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end
    figures{end+1} = gcf;
    filenames{end+1} = generate_filename(metric_name);
end