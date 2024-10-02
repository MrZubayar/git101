% Run_all_analysis

%% Main script to perform the analysis
WANT_FIGSAVE = 0; % Initial setting, can still be used for batch mode if needed

% Define available filtering techniques
filtering_techniques = {'Lee', 'Kuan', 'Both'};  % Added 'Both' as an option


% Define available signal types
signal_types = {'baseline_constant', 'baseline_sigmoid', 'equal_pulse', ...
                'pos_neg_pulse', 'unequal_pulse', 'baseline_triangle', ...
                'baseline_sinusoid'};

for ff= 1: length(filtering_techniques)

    for tt = 1: length(signal_types)
        execute_analysis (filtering_techniques{ff}, signal_types{tt}, WANT_FIGSAVE)
    end

end