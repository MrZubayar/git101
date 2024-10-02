function add_labels(x_values, y_values)
    % Function to add text labels beside each point in the plot
    for i = 1:length(x_values)
        text(x_values(i), y_values(i), sprintf('%.2f', y_values(i)), ...
            'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 8);
    end
end
