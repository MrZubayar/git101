%% Main script to perform the analysis
WANT_FIGSAVE = 0; % Initial setting, can still be used for batch mode if needed

% Define available filtering techniques
filtering_techniques = {'Lee', 'Kuan', 'Both'};  % Added 'Both' as an option

% Display the filtering technique options to the user
fprintf('Available filtering techniques:\n');
for i = 1:length(filtering_techniques)
    fprintf('%d: %s\n', i, filtering_techniques{i});
end

% Prompt the user to select a filtering technique
selected_filter_option = input('Select a filtering technique by entering the corresponding number: ');

% Validate user input
if selected_filter_option < 1 || selected_filter_option > length(filtering_techniques)
    error('Invalid selection. Please run the script again and choose a valid option.');
end

% Set the selected filtering technique
selected_filtering_technique = filtering_techniques{selected_filter_option};

% Define available signal types
signal_types = {'baseline_constant', 'baseline_sigmoid', 'equal_pulse', ...
                'pos_neg_pulse', 'unequal_pulse', 'baseline_triangle', ...
                'baseline_sinusoid'};

% Display the signal type options to the user
fprintf('Available signal types:\n');
for i = 1:length(signal_types)
    fprintf('%d: %s\n', i, signal_types{i});
end

% Prompt the user to select a signal type
selected_filtering_technique = input('Select a signal type by entering the corresponding number: ');

% Validate user input
if selected_signal_option < 1 || selected_signal_option > length(signal_types)
    error('Invalid selection. Please run the script again and choose a valid option.');
end

% Set the selected signal type
selected_signal_type = signal_types{selected_signal_option};

% Generate parameters based on the selected signal type
P = Parameters(selected_signal_type);

% Add the noOfTranscendSamples field
P.noOfTranscendSamples = 50;  % Number of samples to exclude at the end

% Generate the original clean signal
signal = getSignal(P);

% Initialize variables for filtered signals
filtered_signal_lee = zeros(P.noOfSamples, length(P.Lee.M_values), P.nRand);  % Lee filter results
filtered_signal_kuan = zeros(P.noOfSamples, length(P.Kuan.M_values), P.nRand); % Kuan filter results
original_signal = zeros(P.noOfSamples, P.nRand);

rng(P.seed);  % Initialize random generator

% Perform the filtering operation using the selected technique
for rr = 1:P.nRand
    noisy_signal = signal + P.signal_variance * randn(1, P.noOfSamples); % Add noise to the signal
    original_signal(:, rr) = noisy_signal;  % Save the noisy signal

    % Apply both filters if "Both" is selected, otherwise apply the selected filter
    if strcmp(selected_filtering_technique, 'Both')
        filtered_signal_lee(:, :, rr) = LeeFilter(noisy_signal, P.Lee.M_values, P.signal_variance);
        filtered_signal_kuan(:, :, rr) = KuanFilter(noisy_signal, P.Kuan.M_values, P.signal_variance);
    elseif strcmp(selected_filtering_technique, 'Lee')
        filtered_signal_lee(:, :, rr) = LeeFilter(noisy_signal, P.Lee.M_values, P.signal_variance);
    elseif strcmp(selected_filtering_technique, 'Kuan')
        filtered_signal_kuan(:, :, rr) = KuanFilter(noisy_signal, P.Kuan.M_values, P.signal_variance);
    end
end

% Generate plots for Lee filter
if ~isempty(filtered_signal_lee)
    generate_plots_for_filter('Lee', filtered_signal_lee, signal, P, original_signal, selected_signal_type);
end

% Generate plots for Kuan filter
if ~isempty(filtered_signal_kuan)
    generate_plots_for_filter('Kuan', filtered_signal_kuan, signal, P, original_signal, selected_signal_type);
end

%% MATLAB code to write a LaTeX table for average SNR values for Lee filter using WriteTable function

% Calculate quality metrics for Lee filter
snr_values_lee = quality_evaluation_metrics('SNR', filtered_signal_lee, original_signal, P);
rmse_values_lee = quality_evaluation_metrics('RMSE', filtered_signal_lee, original_signal, P);
psnr_values_lee = quality_evaluation_metrics('PSNR', filtered_signal_lee, original_signal, P);
md_values_lee = quality_evaluation_metrics('MD', filtered_signal_lee, original_signal, P);
ad_values_lee = quality_evaluation_metrics('AD', filtered_signal_lee, original_signal, P);
nk_values_lee = quality_evaluation_metrics('NK', filtered_signal_lee, original_signal, P);
nae_values_lee = quality_evaluation_metrics('NAE', filtered_signal_lee, original_signal, P);
uqi_values_lee = quality_evaluation_metrics('UQI', filtered_signal_lee, original_signal, P);
sc_values_lee = quality_evaluation_metrics('SC', filtered_signal_lee, original_signal, P);
mssim_values_lee = quality_evaluation_metrics('MSSIM', filtered_signal_lee, original_signal, P);

% Calculate quality metrics for Kuan filter
snr_values_kuan = quality_evaluation_metrics('SNR', filtered_signal_kuan, original_signal, P);
rmse_values_kuan = quality_evaluation_metrics('RMSE', filtered_signal_kuan, original_signal, P);
psnr_values_kuan = quality_evaluation_metrics('PSNR', filtered_signal_kuan, original_signal, P);
md_values_kuan = quality_evaluation_metrics('MD', filtered_signal_kuan, original_signal, P);
ad_values_kuan = quality_evaluation_metrics('AD', filtered_signal_kuan, original_signal, P);
nk_values_kuan = quality_evaluation_metrics('NK', filtered_signal_kuan, original_signal, P);
nae_values_kuan = quality_evaluation_metrics('NAE', filtered_signal_kuan, original_signal, P);
uqi_values_kuan = quality_evaluation_metrics('UQI', filtered_signal_kuan, original_signal, P);
sc_values_kuan = quality_evaluation_metrics('SC', filtered_signal_kuan, original_signal, P);
mssim_values_kuan = quality_evaluation_metrics('MSSIM', filtered_signal_kuan, original_signal, P);

% Write quality metrics to LaTeX table
WriteQualityMetricsTable(P, snr_values_lee, snr_values_kuan, rmse_values_lee, rmse_values_kuan, ...
                         psnr_values_lee, psnr_values_kuan, md_values_lee, md_values_kuan, ...
                         ad_values_lee, ad_values_kuan, nk_values_lee, nk_values_kuan, ...
                         nae_values_lee, nae_values_kuan, uqi_values_lee, uqi_values_kuan, ...
                         sc_values_lee, sc_values_kuan, mssim_values_lee, mssim_values_kuan);

% Display a message to the user
fprintf('LaTeX table for all quality metrics for both filters has been saved.\n');

%% Ask to Save All Figures at the End
save_choice = input('Do you want to save all displayed figures? (y/n): ', 's');
if strcmpi(save_choice, 'y')
    for i = 1:length(figures)
        exportgraphics(figures{i}, filenames_png{i}, 'Resolution', 600);  % Save as PNG
    end
    fprintf('All figures have been saved.\n');
else
    fprintf('Figures were not saved.\n');
end
