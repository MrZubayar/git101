function execute_analysis(selected_filtering_technique, selected_signal_type, noise_level_vector, selected_metrics, WANT_FIGSAVE)

    % Generate parameters based on the selected signal type
    P = Parameters(selected_signal_type);  
    
    % Generate the original clean signal
    signal = getSignal(P);
    
    % Initialize metric_data as an array of structs
    metric_data = struct('M_values', P.Lee.M_values, 'metric', [], 'selected_metric', '');

    for mm = 1:length(selected_metrics)
        metric_data(mm).M_values = P.Lee.M_values;
        metric_data(mm).metric = [];
        metric_data(mm).selected_metric = selected_metrics{mm};
    end

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

        % Generate plots 1-6 for Lee filter (once per noise level)
        if ~isempty(filtered_signal)
            generate_basic_plots(selected_filtering_technique, filtered_signal, signal, P, original_signal, selected_signal_type, noise_level);
        end

        % Now, for each selected_metric, calculate metric_values, generate plot 7, and accumulate metric_data
        for mm = 1:length(selected_metrics)
            selected_metric = selected_metrics{mm};
            % Calculate metric_values and generate plot 7
            metric_values = generate_metric_plots(selected_filtering_technique, filtered_signal, signal, P, original_signal, selected_signal_type, noise_level, selected_metric);

            % Accumulate metric_values into metric_data
            metric_data(mm).metric(:, nn) = mean(metric_values, 2);
        end
    end

    % After processing all noise levels, write the metric data for each selected_metric
    for mm = 1:length(selected_metrics)
        selected_metric = selected_metrics{mm};
        write_metric_to_tex(metric_data(mm), selected_filtering_technique, selected_signal_type, noise_level_vector, selected_metric);
        fprintf('Analysis completed. %s for Lee filter has been calculated.\n', selected_metric);
    end

end

