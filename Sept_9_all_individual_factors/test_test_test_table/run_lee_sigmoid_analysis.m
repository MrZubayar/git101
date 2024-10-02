% Run_Lee_analysis

%% Main script to perform the analysis
WANT_FIGSAVE = 0; % Initial setting, can still be used for batch mode if needed

% Define available filtering techniques
filtering_techniques = {'Lee'};  % Added 'Both' as an option

% Define available signal types
signal_types = {'sigmoid'}; 

% Define the metrics you want to calculate
selected_metrics = {'SNR', 'RMSE', 'PSNR', 'NK', 'AD', 'MD', 'NAE', 'SC', 'UQI', 'MSSIM'};

noise_level_vector = [0.1 1 5];
for mm = 1:length(selected_metrics)
    for ff = 1:length(filtering_techniques)
        for tt = 1:length(signal_types)
            execute_analysis(filtering_techniques{ff}, signal_types{tt}, noise_level_vector, selected_metrics{mm}, WANT_FIGSAVE);
        end
    end
end

