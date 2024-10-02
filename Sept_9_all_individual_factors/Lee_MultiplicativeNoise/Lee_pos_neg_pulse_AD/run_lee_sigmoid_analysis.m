% Run_Lee_analysis

%% Main script to perform the analysis
WANT_FIGSAVE = 0; % Initial setting, can still be used for batch mode if needed
% Define available filtering techniques
filtering_techniques = {'Lee'};  % Added 'Both' as an option
% Define available signal types
signal_types = {'pos_neg_pulse'};

% Define the metric you want to calculate (e.g., 'SNR', 'RMSE')
selected_metric = 'AD';

noise_level_vector = [0.1 1 5];
for nn = 1: length(noise_level_vector)
    for ff= 1: length(filtering_techniques)
        for tt = 1: length(signal_types)
            execute_analysis(filtering_techniques{ff}, signal_types{tt}, noise_level_vector(nn), selected_metric, WANT_FIGSAVE, noise_level_vector);
        end
    end
end
