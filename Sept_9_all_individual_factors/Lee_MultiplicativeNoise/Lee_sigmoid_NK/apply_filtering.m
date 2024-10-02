function [filtered_signal_lee, filtered_signal_kuan] = apply_filtering(noisy_signal, P, selected_filtering_technique)
    % Apply the selected filtering technique(s) to the noisy signal
    switch selected_filtering_technique
        case 'Lee'
            filtered_signal_lee = LeeFilter(noisy_signal, P.Lee.M_values, P.Lee.noise_variance);
            filtered_signal_kuan = [];  % No Kuan filter applied
            
        case 'Kuan'
            filtered_signal_kuan = KuanFilter(noisy_signal, P.Kuan.M_values, P.Kuan.noise_variance);
            filtered_signal_lee = [];  % No Lee filter applied
            
        case 'Both'
            filtered_signal_lee = LeeFilter(noisy_signal, P.Lee.M_values, P.Lee.noise_variance);
            filtered_signal_kuan = KuanFilter(noisy_signal, P.Kuan.M_values, P.Kuan.noise_variance);
            
        otherwise
            error('Selected filtering technique not recognized. Please choose a valid technique.');
    end
end
