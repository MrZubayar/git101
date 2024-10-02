function write_metric_to_tex(metric_data, filter_name, signal_type, noise_level_vector, selected_metric)
    % Define the filename
    filename = sprintf('%s_%s_%s_Combined.tex', filter_name, signal_type, selected_metric);
    
    % Open file for writing
    fid = fopen(filename, 'w');
    
    % Define column headings
    H = [{'M Value'}, arrayfun(@(x) sprintf('Noise %.2f', x), noise_level_vector, 'UniformOutput', false)];
    
    % Find the maximum value for each noise level
    min_values = min(metric_data.metric, [], 1);
    
    % Prepare data to be written, with the highest value in each column bolded
    A = cell(1, length(metric_data.M_values));
    for i = 1:length(metric_data.M_values)
        row_data = cell(1, length(noise_level_vector) + 1);
        row_data{1} = sprintf('%d', metric_data.M_values(i));  % M value
        for j = 1:length(noise_level_vector)
            if metric_data.metric(i, j) == min_values(j)
                row_data{j + 1} = sprintf('\\textbf{%.2f}', metric_data.metric(i, j));
            else
                row_data{j + 1} = sprintf('%.2f', metric_data.metric(i, j));
            end
        end
        A{i} = row_data;
    end
    
    % Write the LaTeX table using the WriteTable function
    WriteTable(fid, A, [], H, sprintf('%s Values for %s with %s across Different Noise Levels', selected_metric, filter_name, signal_type), '\small');
    
    % Close the file
    fclose(fid);
    
    fprintf('Combined %s values saved to %s\n', selected_metric, filename);
end
