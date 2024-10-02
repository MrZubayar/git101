function execute_analysis(selected_filtering_technique, selected_signal_type, noise_level, WANT_FIGSAVE)

    % Generate parameters based on the selected signal type
    P = Parameters(selected_signal_type);  % Ensure Parameters function handles selected_signal_type correctly
    
    % Add the noOfTranscendSamples field
    P.noOfTranscendSamples = 50;  % Number of samples to exclude at the end
    
    % Generate the original clean signal
    signal = getSignal(P);
    
    % Initialize variables for filtered signals
    filtered_signal_lee = zeros(P.noOfSamples, length(P.Lee.M_values), P.nRand);  % Lee filter results
    original_signal = zeros(P.noOfSamples, P.nRand);
    
    rng(P.seed);  % Initialize random generator
    
    % Perform the filtering operation using the Lee filter
    for rr = 1:P.nRand
        noisy_signal = signal + noise_level * randn(1, P.noOfSamples); % Add noise to the signal using the noise_level directly
        original_signal(:, rr) = noisy_signal;  % Save the noisy signal
    
        % Apply the Lee filter
        filtered_signal_lee(:, :, rr) = LeeFilter(noisy_signal, P.Lee.M_values, noise_level);
    end
    
    % Generate plots for Lee filter
    if ~isempty(filtered_signal_lee)
        generate_plots_for_filter('Lee', filtered_signal_lee, signal, P, original_signal, selected_signal_type, noise_level);
    end
        
    % Display a message to the user
    fprintf('Analysis completed. SNR for Lee filter has been calculated.\n');
    
end
