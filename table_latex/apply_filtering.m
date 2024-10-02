function filtered_signal = apply_filtering(noisy_signal, P, selected_filtering_technique)
    % Apply the selected filtering technique to the noisy signal
    switch selected_filtering_technique
        case 'Lee'
            % Call LeeFilter with the required noise_variance parameter
            filtered_signal = LeeFilter(noisy_signal, P.Lee.M_values, P.Lee.noise_variance);
            
        case 'Kuan'
            % Call KuanFilter with the required noise_variance parameter
            filtered_signal = KuanFilter(noisy_signal, P.Kuan.M_values, P.Kuan.noise_variance);
            
        % Add more cases for additional filtering techniques here
            
        otherwise
            error('Selected filtering technique not recognized. Please choose a valid technique.');
    end
end
