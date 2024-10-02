function write_metric_to_tex(metric_data, filter_name, signal_type, selected_metrics)
    % Define the filename
    noise_level = metric_data.noise_level;
    filename = sprintf('%s_%s_Noise_%.2f_Combined.tex', filter_name, signal_type, noise_level);
    
    % Open file for writing
    fid = fopen(filename, 'w');
    
    % Define column headings
    H = [{'M Value'}, selected_metrics];
    
    % Prepare data to be written
    A = cell(1, length(metric_data.M_values));
    for i = 1:length(metric_data.M_values)
        row_data = cell(1, length(selected_metrics) + 1);
        row_data{1} = sprintf('%d', metric_data.M_values(i));  % M value
        for j = 1:length(selected_metrics)
            metric_name = selected_metrics{j};
            metric_values = metric_data.metrics.(metric_name);
            row_data{j + 1} = sprintf('%.2f', metric_values(i));
        end
        A{i} = row_data;
    end
    
    % Write the LaTeX table using the WriteTable function
    Caption = sprintf('Metrics for %s with %s at Noise Level %.2f', filter_name, signal_type, noise_level);
    WriteTable(fid, A, [], H, Caption, '\small');
    
    % Close the file
    fclose(fid);
    
    fprintf('Metric values saved to %s\n', filename);
end