% Run_Lee_analysis

% Main script to perform the analysis
WANT_FIGSAVE = 0; % Initial setting, can still be used for batch mode if needed
%% Define available filtering techniques
filtering_techniques = {'Lee'};  % Added 'Both' as an option
%% Define available signal types
signal_types = {'sigmoid'};
%signal_types = {'baseline_sigmoid', 'baseline_constant', 'baseline_triangle', 'baseline_sinusoid', 'equal_pulse', 'pos_neg_pulse', 'unequal_pulse'};
%% Define the metrics you want to calculate
quality_metrics = {'SNR', 'RMSE', 'PSNR', 'MD', 'AD', 'NK', 'NAE', 'UQI', 'SC', 'MSSIM'};
%%
noise_level_vector = [0.1 1 5];

for nn = 1:length(noise_level_vector)
    for ff = 1:length(filtering_techniques)
        for tt = 1:length(signal_types)
            execute_analysis(filtering_techniques{ff}, signal_types{tt}, noise_level_vector(nn), quality_metrics, WANT_FIGSAVE, noise_level_vector);
        end
    end
end

