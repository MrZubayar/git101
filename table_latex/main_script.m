%% Main script to perform the analysis
WANT_FIGSAVE = 0; % Initial setting, can still be used for batch mode if needed

% Define available filtering techniques
filtering_techniques = {'Lee', 'Kuan'};  % You can add more techniques as needed

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
selected_signal_option = input('Select a signal type by entering the corresponding number: ');

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
filtered_signal = zeros(P.noOfSamples, length(P.Lee.M_values), P.nRand);  % Adjust size based on the filter if needed
original_signal = zeros(P.noOfSamples, P.nRand);

rng(P.seed);  % Initialize random generator

% Perform the filtering operation using the selected technique
for rr = 1:P.nRand
    noisy_signal = signal + P.signal_variance * randn(1, P.noOfSamples); % Add noise to the signal
    original_signal(:, rr) = noisy_signal;  % Save the noisy signal

    % Use the apply_filtering function to handle the filtering
    filtered_signal(:, :, rr) = apply_filtering(noisy_signal, P, selected_filtering_technique);
end

% Display experimental bias and variance
mean_filtered_signal = mean(filtered_signal, 3);
bias = mean_filtered_signal - signal';  % Use the original clean signal to calculate bias
variance = var(filtered_signal, 0, 3);

% Calculate standard deviation from the variance
standard_deviation = sqrt(variance);

mean_bias = mean(bias, 1);
mean_variance = mean(variance, 1);
mean_std_dev = mean(standard_deviation, 1);

% Create a string with summary statistics for plot titles
summary_str = sprintf('Bias: %.4f, Variance: %.4f, Std Dev: %.4f', mean(mean_bias), mean(mean_variance), mean(mean_std_dev));

disp('Experimental bias & variance');
disp([P.Lee.M_values' mean_bias' mean_variance']);  % Adjust this line if other filters are used

% Evaluate and store quality metrics
snr_values = quality_evaluation_metrics('SNR', filtered_signal, original_signal, P);
rmse_values = quality_evaluation_metrics('RMSE', filtered_signal, original_signal, P);
psnr_values = quality_evaluation_metrics('PSNR', filtered_signal, original_signal, P);
md_values = quality_evaluation_metrics('MD', filtered_signal, original_signal, P);
ad_values = quality_evaluation_metrics('AD', filtered_signal, original_signal, P);
nk_values = quality_evaluation_metrics('NK', filtered_signal, original_signal, P);
nae_values = quality_evaluation_metrics('NAE', filtered_signal, original_signal, P);
uqi_values = quality_evaluation_metrics('UQI', filtered_signal, original_signal, P);
sc_values = quality_evaluation_metrics('SC', filtered_signal, original_signal, P);
mssim_values = quality_evaluation_metrics('MSSIM', filtered_signal, original_signal, P);

%% Plotting and Storing Figures
% Define legend for filter sizes
leg = {};
for ii = 1:length(P.Lee.M_values)  % Adjust if using another filter
    leg{ii} = ['M = ', int2str(P.Lee.M_values(ii))];
end

% Directory to save the figures
output_dir = 'SavedFigures';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% Function to generate unique filenames based on filter, signal type, and execution order
generate_filename = @(basename, plot_number, ext) fullfile(output_dir, sprintf('%02d_%s_%s_%s.%s', plot_number, basename, selected_filtering_technique, selected_signal_type, ext));

% Initialize a cell array to store figures and their filenames
figures = {};
filenames_png = {};

% Initialize a counter for filename numbering
file_counter = 1;

% Define a grayish color for individual curves
gray_color = [0.8 0.8 0.8];

%% Calculate the valid range
valid_range = 1:(P.noOfSamples - P.noOfTranscendSamples);

% 1. Plot the original signal and noisy signal together
fig1 = figure;
plot(valid_range, signal(valid_range), 'k--'); hold on;
plot(valid_range, mean(original_signal(valid_range, :), 2), 'r');
title(strrep(sprintf('Original and Noisy Signals (%s) using %s Filter\n [%s]', selected_signal_type, selected_filtering_technique, summary_str),'_','\_'));
xlabel('Sample Index');
ylabel('Signal Value');
legend('Original Signal', 'Noisy Signal', 'Location', 'southeast');
grid on;
figures{end+1} = fig1;
filenames_png{end+1} = generate_filename('Original_Noise_Signal', file_counter, 'png');
file_counter = file_counter + 1;

% 2. Plot the mean filtered signals
fig2 = figure;
plot(valid_range, mean_filtered_signal(valid_range, :));
title(strrep(sprintf('Mean Filtered Signals (%s) using %s Filter\n [%s]', selected_signal_type, selected_filtering_technique, summary_str),'_','\_'));
xlabel('Sample Index');
ylabel('Signal Value');
legend(leg{:}, 'Location', 'southeast');
grid on;
figures{end+1} = fig2;
filenames_png{end+1} = generate_filename('Mean_Filtered_Signal', file_counter, 'png');
file_counter = file_counter + 1;

% 3. Plot the bias for each filter size
fig3 = figure;
plot(valid_range, bias(valid_range, :));
title(strrep(sprintf('Bias of Filtered Signal (%s) using %s Filter\n [%s]', selected_signal_type, selected_filtering_technique, summary_str),'_','\_'));
xlabel('Sample Index');
ylabel('Bias');
legend(leg, 'Location', 'northeast');
grid on;
figures{end+1} = fig3;
filenames_png{end+1} = generate_filename('Bias_Filtered_Signal', file_counter, 'png');
file_counter = file_counter + 1;

% 4. Plot the variance for each filter size
fig4 = figure;
plot(valid_range, variance(valid_range, :));
title(strrep(sprintf('Variance of Filtered Signal (%s) using %s Filter\n [%s]', selected_signal_type, selected_filtering_technique, summary_str),'_','\_'));
xlabel('Sample Index');
ylabel('Variance');
legend(leg, 'Location', 'northeast');
grid on;
figures{end+1} = fig4;
filenames_png{end+1} = generate_filename('Variance_Filtered_Signal', file_counter, 'png');
file_counter = file_counter + 1;

% 5. Plot the standard deviation for each filter size
fig5 = figure;
plot(valid_range, standard_deviation(valid_range, :));
title(strrep(sprintf('Standard Deviation of Filtered Signal (%s) using %s Filter\n [%s]', selected_signal_type, selected_filtering_technique, summary_str),'_','\_'));
xlabel('Sample Index');
ylabel('Standard Deviation');
legend(leg, 'Location', 'northeast');
grid on;
figures{end+1} = fig5;
filenames_png{end+1} = generate_filename('StdDev_Filtered_Signal', file_counter, 'png');
file_counter = file_counter + 1;

% 6. Plot the Mean Bias, Variance, and Std Dev
fig6 = figure;
plot(valid_range, mean(bias(valid_range, :), 2), 'b'); hold on;
plot(valid_range, mean(variance(valid_range, :), 2), 'g');
plot(valid_range, mean(standard_deviation(valid_range, :), 2), 'm');
title(strrep(sprintf('Mean Bias, Variance, and Std Dev (%s) using %s Filter\n [%s]', selected_signal_type, selected_filtering_technique, summary_str),'_','\_'));
xlabel('Sample Index');
ylabel('Value');
legend({'Mean Bias', 'Mean Variance', 'Mean Std Dev'}, 'Location', 'northeast');
grid on;
figures{end+1} = fig6;
filenames_png{end+1} = generate_filename('Mean_Bias_Variance_StdDev', file_counter, 'png');
file_counter = file_counter + 1;

%% Plotting Quality Metrics

% 7. Plot SNR across different M values
fig7 = figure;
hold on;

% Plot all individual curves in gray
for rr = 1:P.nRand
    h1 = plot(P.Lee.M_values, snr_values(:, rr), 'Color', gray_color);
end

% Plot the average curve with highlighted points
h2 = plot(P.Lee.M_values, mean(snr_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

title(strrep(sprintf('Mean SNR across Realizations for Different M Values \n (%s) using %s Filter', selected_signal_type, selected_filtering_technique), '_', '\_'));
xlabel('M Value');
ylabel('SNR (dB)');
xticks(P.Lee.M_values);
grid on;
legend([h1, h2], {'Individual Realizations', 'Mean SNR'}, 'Location', 'northeast');

figures{end+1} = fig7;
filenames_png{end+1} = generate_filename('SNR_vs_M', file_counter, 'png');
file_counter = file_counter + 1;

% 8. Plot RMSE across different M values
fig8 = figure;
hold on;

% Plot all individual curves in gray
for rr = 1:P.nRand
    h1 = plot(P.Lee.M_values, rmse_values(:, rr), 'Color', gray_color);
end

% Plot the average curve with highlighted points
h2 = plot(P.Lee.M_values, mean(rmse_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

title(strrep(sprintf('Mean RMSE across Realizations for Different M Values \n (%s) using %s Filter', selected_signal_type, selected_filtering_technique), '_', '\_'));
xlabel('M Value');
ylabel('RMSE');
xticks(P.Lee.M_values);
grid on;
legend([h1, h2], {'Individual Realizations', 'Mean RMSE'}, 'Location', 'northeast');

figures{end+1} = fig8;
filenames_png{end+1} = generate_filename('RMSE_vs_M', file_counter, 'png');
file_counter = file_counter + 1;

% 9. Plot PSNR across different M values
fig9 = figure;
hold on;

% Plot all individual curves in gray
for rr = 1:P.nRand
    h1 = plot(P.Lee.M_values, psnr_values(:, rr), 'Color', gray_color);
end

% Plot the average curve with highlighted points
h2 = plot(P.Lee.M_values, mean(psnr_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

title(strrep(sprintf('Mean PSNR across Realizations for Different M Values \n (%s) using %s Filter', selected_signal_type, selected_filtering_technique), '_', '\_'));
xlabel('M Value');
ylabel('PSNR (dB)');
xticks(P.Lee.M_values);
grid on;
legend([h1, h2], {'Individual Realizations', 'Mean PSNR'}, 'Location', 'northeast');

figures{end+1} = fig9;
filenames_png{end+1} = generate_filename('PSNR_vs_M', file_counter, 'png');
file_counter = file_counter + 1;

% 10. Plot MD across different M values
fig10 = figure;
hold on;

% Plot all individual curves in gray
for rr = 1:P.nRand
    h1 = plot(P.Lee.M_values, md_values(:, rr), 'Color', gray_color);
end

% Plot the average curve with highlighted points
h2 = plot(P.Lee.M_values, mean(md_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

title(strrep(sprintf('Mean MD across Realizations for Different M Values \n (%s) using %s Filter', selected_signal_type, selected_filtering_technique), '_', '\_'));
xlabel('M Value');
ylabel('MD');
xticks(P.Lee.M_values);
grid on;
legend([h1, h2], {'Individual Realizations', 'Mean MD'}, 'Location', 'northeast');

figures{end+1} = fig10;
filenames_png{end+1} = generate_filename('MD_vs_M', file_counter, 'png');
file_counter = file_counter + 1;

% 11. Plot AD across different M values
fig11 = figure;
hold on;

% Plot all individual curves in gray
for rr = 1:P.nRand
    h1 = plot(P.Lee.M_values, ad_values(:, rr), 'Color', gray_color);
end

% Plot the average curve with highlighted points
h2 = plot(P.Lee.M_values, mean(ad_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

title(strrep(sprintf('Mean AD across Realizations for Different M Values \n (%s) using %s Filter', selected_signal_type, selected_filtering_technique), '_', '\_'));
xlabel('M Value');
ylabel('AD');
xticks(P.Lee.M_values);
grid on;
legend([h1, h2], {'Individual Realizations', 'Mean AD'}, 'Location', 'northeast');

figures{end+1} = fig11;
filenames_png{end+1} = generate_filename('AD_vs_M', file_counter, 'png');
file_counter = file_counter + 1;

% 12. Plot NK across different M values
fig12 = figure;
hold on;

% Plot all individual curves in gray
for rr = 1:P.nRand
    h1 = plot(P.Lee.M_values, nk_values(:, rr), 'Color', gray_color);
end

% Plot the average curve with highlighted points
h2 = plot(P.Lee.M_values, mean(nk_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

title(strrep(sprintf('Mean NK across Realizations for Different M Values \n (%s) using %s Filter', selected_signal_type, selected_filtering_technique), '_', '\_'));
xlabel('M Value');
ylabel('NK');
xticks(P.Lee.M_values);
grid on;
legend([h1, h2], {'Individual Realizations', 'Mean NK'}, 'Location', 'northeast');

figures{end+1} = fig12;
filenames_png{end+1} = generate_filename('NK_vs_M', file_counter, 'png');
file_counter = file_counter + 1;

% 13. Plot NAE across different M values
fig13 = figure;
hold on;

% Plot all individual curves in gray
for rr = 1:P.nRand
    h1 = plot(P.Lee.M_values, nae_values(:, rr), 'Color', gray_color);
end

% Plot the average curve with highlighted points
h2 = plot(P.Lee.M_values, mean(nae_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

title(strrep(sprintf('Mean NAE across Realizations for Different M Values \n (%s) using %s Filter', selected_signal_type, selected_filtering_technique), '_', '\_'));
xlabel('M Value');
ylabel('NAE');
xticks(P.Lee.M_values);
grid on;
legend([h1, h2], {'Individual Realizations', 'Mean NAE'}, 'Location', 'northeast');

figures{end+1} = fig13;
filenames_png{end+1} = generate_filename('NAE_vs_M', file_counter, 'png');
file_counter = file_counter + 1;

% 14. Plot UQI across different M values
fig14 = figure;
hold on;

% Plot all individual curves in gray
for rr = 1:P.nRand
    h1 = plot(P.Lee.M_values, uqi_values(:, rr), 'Color', gray_color);
end

% Plot the average curve with highlighted points
h2 = plot(P.Lee.M_values, mean(uqi_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

title(strrep(sprintf('Mean UQI across Realizations for Different M Values \n (%s) using %s Filter', selected_signal_type, selected_filtering_technique), '_', '\_'));
xlabel('M Value');
ylabel('UQI');
xticks(P.Lee.M_values);
grid on;
legend([h1, h2], {'Individual Realizations', 'Mean UQI'}, 'Location', 'northeast');

figures{end+1} = fig14;
filenames_png{end+1} = generate_filename('UQI_vs_M', file_counter, 'png');
file_counter = file_counter + 1;

% 15. Plot SC across different M values
fig15 = figure;
hold on;

% Plot all individual curves in gray
for rr = 1:P.nRand
    h1 = plot(P.Lee.M_values, sc_values(:, rr), 'Color', gray_color);
end

% Plot the average curve with highlighted points
h2 = plot(P.Lee.M_values, mean(sc_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

title(strrep(sprintf('Mean SC across Realizations for Different M Values \n (%s) using %s Filter', selected_signal_type, selected_filtering_technique), '_', '\_'));
xlabel('M Value');
ylabel('SC');
xticks(P.Lee.M_values);
grid on;
legend([h1, h2], {'Individual Realizations', 'Mean SC'}, 'Location', 'northeast');

figures{end+1} = fig15;
filenames_png{end+1} = generate_filename('SC_vs_M', file_counter, 'png');
file_counter = file_counter + 1;

% 16. Plot MSSIM across different M values
fig16 = figure;
hold on;

% Plot all individual curves in gray
for rr = 1:P.nRand
    h1 = plot(P.Lee.M_values, mssim_values(:, rr), 'Color', gray_color);
end

% Plot the average curve with highlighted points
h2 = plot(P.Lee.M_values, mean(mssim_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

title(strrep(sprintf('Mean MSSIM across Realizations for Different M Values \n (%s) using %s Filter', selected_signal_type, selected_filtering_technique), '_', '\_'));
xlabel('M Value');
ylabel('MSSIM');
xticks(P.Lee.M_values);
grid on;
legend([h1, h2], {'Individual Realizations', 'Mean MSSIM'}, 'Location', 'northeast');

figures{end+1} = fig16;
filenames_png{end+1} = generate_filename('MSSIM_vs_M', file_counter, 'png');
file_counter = file_counter + 1;

%% MATLAB code to write a LaTeX table for average SNR values for Lee filter using WriteTable function

% Calculate average quality metric values for Lee filter
mean_snr_values_lee = mean(snr_values, 2);    % Mean SNR across all realizations for each M value
mean_rmse_values_lee = mean(rmse_values, 2);  % Mean RMSE
mean_psnr_values_lee = mean(psnr_values, 2);  % Mean PSNR
mean_md_values_lee = mean(md_values, 2);      % Mean MD
mean_ad_values_lee = mean(ad_values, 2);      % Mean AD
mean_nk_values_lee = mean(nk_values, 2);      % Mean NK
mean_nae_values_lee = mean(nae_values, 2);    % Mean NAE
mean_uqi_values_lee = mean(uqi_values, 2);    % Mean UQI
mean_sc_values_lee = mean(sc_values, 2);      % Mean SC
mean_mssim_values_lee = mean(mssim_values, 2);% Mean MSSIM

% Prepare the data for the table
H = {'M Value', 'SNR (dB)', 'RMSE', 'PSNR (dB)', 'MD', 'AD', 'NK', 'NAE', 'UQI', 'SC', 'MSSIM'};  % Table header
A = cell(length(P.Lee.M_values), 1);  % Initialize cell array for table rows

for ii = 1:length(P.Lee.M_values)
    A{ii} = {num2str(P.Lee.M_values(ii)), ...
             sprintf('%.4f', mean_snr_values_lee(ii)), ...
             sprintf('%.4f', mean_rmse_values_lee(ii)), ...
             sprintf('%.4f', mean_psnr_values_lee(ii)), ...
             sprintf('%.4f', mean_md_values_lee(ii)), ...
             sprintf('%.4f', mean_ad_values_lee(ii)), ...
             sprintf('%.4f', mean_nk_values_lee(ii)), ...
             sprintf('%.4f', mean_nae_values_lee(ii)), ...
             sprintf('%.4f', mean_uqi_values_lee(ii)), ...
             sprintf('%.4f', mean_sc_values_lee(ii)), ...
             sprintf('%.4f', mean_mssim_values_lee(ii))};  % Fill each row with all metrics
end

% Define the output file
output_filename = 'QualityMatricsTable.tex';
output_dir = 'SavedFigures';  % Directory to save the .tex file
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end
output_filepath = fullfile(output_dir, output_filename);

% Open the file for writing
fid = fopen(output_filepath, 'w');

% Check if the file opened successfully
if fid == -1
    error('Cannot open file for writing: %s', output_filepath);
end

% Define table format: 'c' for center, 'r' for right-aligned; '|' adds vertical lines
FORMATtable = '|c|c|c|c|c|c|c|c|c|c|c|';

% Write the table using the function
WriteTable(fid, A, FORMATtable, H, 'Average Quality Metrics for Lee Filter', '\small');

% Close the file
fclose(fid);

% Display a message to the user
fprintf('LaTeX table for all quality metrics for Lee filter has been saved to %s.\n', output_filepath);


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
