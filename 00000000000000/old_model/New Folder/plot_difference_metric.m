function plot_difference_metric(metric_values, M_values)
    % Function to plot the metric across M values and ensure the legend shows accurate colors
    %
    % Input:
    %   metric_values: [M_values x nRand] matrix of metric values
    %   M_values: vector of M values

    % Plotting the metric across M values
    figure;
    hold on;

    % Plot the first individual trial and get handle
    h_individual = plot(M_values, metric_values(:, 1), 'Color', [0.8, 0.8, 0.8]);

    % Plot the rest of the individual trials without adding to legend
    nRand = size(metric_values, 2);
    for rr = 2:nRand
        plot(M_values, metric_values(:, rr), 'Color', [0.8, 0.8, 0.8]);
    end

    % Plot mean across trials in red and get handle
    mean_metric = mean(metric_values, 2);
    h_mean = plot(M_values, mean_metric, '-x', 'LineWidth', 1, 'Color', 'r');

    % Set plot title and labels
    title('Mean Absolute Error across Different M Values');
    xlabel('M Value');
    ylabel('Mean Absolute Error');
    xticks(M_values);
    grid on;

    % Use the handles in the legend
    legend([h_individual, h_mean], {'Individual Realizations', 'Mean MAE'}, 'Location', 'northeast');

    hold off;
end
