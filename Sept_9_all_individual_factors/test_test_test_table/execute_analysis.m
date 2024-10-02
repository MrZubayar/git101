function execute_analysis(selected_filtering_technique, selected_signal_type, noise_level_vector, selected_metric, WANT_FIGSAVE)

    % Generate parameters based on the selected signal type
    P = Parameters(selected_signal_type);  
    
    % Generate the original clean signal
    signal = getSignal(P);
    
    % Initialize metric_data
    metric_data = struct('M_values', P.Lee.M_values, 'metric', []);
    
    for nn = 1:length(noise_level_vector)
        noise_level = noise_level_vector(nn);
    
        % Initialize variables for filtered signals
        filtered_signal = zeros(P.noOfSamples, length(P.Lee.M_values), P.nRand);  % Lee filter results
        original_signal = zeros(P.noOfSamples, P.nRand);
        
        rng(P.seed);  % Initialize random generator
        
        % Perform the filtering operation using the Lee filter
        for rr = 1:P.nRand
            noisy_signal = signal + noise_level * randn(1, P.noOfSamples); % Add noise to the signal using the noise_level directly
            original_signal(:, rr) = noisy_signal;  % Save the noisy signal
        
            % Apply the Lee filter
            filtered_signal(:, :, rr) = LeeFilter(noisy_signal, P.Lee.M_values, noise_level);
        end
        
        % Generate plots for Lee filter and get metric values
        if ~isempty(filtered_signal)
            metric_values = generate_plots_for_filter(selected_filtering_technique, filtered_signal, signal, P, original_signal, selected_signal_type, noise_level, selected_metric);
        end

        % Accumulate metric_values into metric_data
        metric_data.metric(:, nn) = mean(metric_values, 2);

    end

    % After processing all noise levels, write the metric data
    write_metric_to_tex(metric_data, selected_filtering_technique, selected_signal_type, noise_level_vector, selected_metric);

    % Display a message to the user
    fprintf('Analysis completed. %s for Lee filter has been calculated.\n', selected_metric);

end

