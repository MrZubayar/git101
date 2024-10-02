function write_metrics_to_tex(all_metrics_data, filter_name, signal_type, noise_level_vector)
    % Define the filename
    filename = sprintf('%s_%s_CombinedMetrics.tex', filter_name, signal_type);
    
    % Open file for writing
    fid = fopen(filename, 'w');
    
    % Extract the metric names from the fieldnames of all_metrics_data
    metric_names = fieldnames(all_metrics_data);

    % Define column headings: first column is 'M Value', followed by metrics for each noise level
    H = [{'M Value'}, arrayfun(@(x) sprintf('Noise %.2f', x), noise_level_vector, 'UniformOutput', false)];
    
    % Loop through each metric and prepare data to be written
    for m = 1:length(metric_names)
        selected_metric = metric_names{m};
        
        % Prepare the data for the current metric
        A = cell(1, length(all_metrics_data.(selected_metric).M_values));
        for i = 1:length(all_metrics_data.(selected_metric).M_values)
            row_data = cell(1, length(noise_level_vector) + 1);
            row_data{1} = sprintf('%d', all_metrics_data.(selected_metric).M_values(i));  % M value
            for j = 1:length(noise_level_vector)
                row_data{j + 1} = sprintf('%.2f', all_metrics_data.(selected_metric).metric(i, j));
            end
            A{i} = row_data;
        end
        
        % Write the LaTeX table for the current metric
        WriteTable(fid, A, [], H, sprintf('%s Values for %s with %s across Different Noise Levels', selected_metric, filter_name, signal_type), '\small');
    end
    
    % Close the file
    fclose(fid);
    
    fprintf('Combined metrics values saved to %s\n', filename);
end