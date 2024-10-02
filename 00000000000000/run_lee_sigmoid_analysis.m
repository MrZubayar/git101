% Run_Lee_analysis

%% Main script to perform the analysis
WANT_FIGSAVE = 0; % Initial setting, can still be used for batch mode if needed

% Define available filtering techniques
filtering_techniques = {'Lee'};

% Define available signal types
signal_types = {'sigmoid'};

noise_level_vector = [0.1, 1, 5];

% Loop over filtering techniques and signal types
for ff = 1:length(filtering_techniques)
    for tt = 1:length(signal_types)
        execute_analysis(filtering_techniques{ff}, signal_types{tt}, noise_level_vector, WANT_FIGSAVE);
    end
end

