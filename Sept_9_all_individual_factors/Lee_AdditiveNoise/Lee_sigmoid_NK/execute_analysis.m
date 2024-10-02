function execute_analysis(selected_filtering_technique, selected_signal_type, noise_level, selected_metric, WANT_FIGSAVE, noise_level_vector)

    % Generate parameters based on the selected signal type
    P = Parameters(selected_signal_type);  
    
    % Generate the original clean signal
    signal = getSignal(P);
    
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
    
    % Generate plots for Lee filter
    if ~isempty(filtered_signal)
        generate_plots_for_filter(selected_filtering_technique, filtered_signal, signal, P, original_signal, selected_signal_type, noise_level, noise_level_vector, selected_metric);
    end
        
    % Display a message to the user
    fprintf('Analysis completed. %s for Lee filter has been calculated.\n', selected_metric);
    
end
