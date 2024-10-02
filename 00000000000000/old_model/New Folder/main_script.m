%% Main script to perform the analysis
WANT_FIGSAVE = 0; % Initial setting, can still be used for batch mode if needed

% Set the selected filtering technique
selected_filtering_technique = 'Lee';

% Set the selected signal type
selected_signal_type = 'sigmoid';

% Generate parameters based on the selected signal type
P = Parameters(selected_signal_type);

% Generate the original clean signal
signal = getSignal(P);

% Initialize variables for filtered signals
filtered_signal = zeros(P.noOfSamples, length(P.Lee.M_values), P.nRand);  % Adjust size based on the filter if needed
original_signal = zeros(P.noOfSamples, P.nRand);

rng(P.seed);  % Initialize random generator

% Perform the filtering operation using the Lee filter
for rr = 1:P.nRand
    noisy_signal = signal + P.signal_variance * randn(1, P.noOfSamples); % Add noise to the signal
    original_signal(:, rr) = noisy_signal;  % Save the noisy signal

    % Use the Lee filter directly
    filtered_signal(:, :, rr) = LeeFilter(noisy_signal, P.Lee.M_values, P.Lee.noise_variance);
end

%%


% Ensure 'signal' is a column vector
if size(signal, 1) == 1
    signal = signal';
end

% Subtract the original signal from each filtered signal
difference = filtered_signal - signal;

% Compute the metric based on the difference
metric_values = compute_difference_metric(difference);

% Plot the metric across M values
plot_difference_metric(metric_values, P.Lee.M_values);



%%
% Display experimental bias and variance
mean_filtered_signal = mean(filtered_signal, 3);
bias = mean_filtered_signal - signal;  % Use the original clean signal to calculate bias
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
title(sprintf('Original and Noisy Signals (%s) using %s Filter\n [%s]', selected_signal_type, selected_filtering_technique, summary_str));
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
title(sprintf('Mean Filtered Signals (%s) using %s Filter\n [%s]', selected_signal_type, selected_filtering_technique, summary_str));
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
title(sprintf('Bias of Filtered Signal (%s) using %s Filter\n [%s]', selected_signal_type, selected_filtering_technique, summary_str));
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
title(sprintf('Variance of Filtered Signal (%s) using %s Filter\n [%s]', selected_signal_type, selected_filtering_technique, summary_str));
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
title(sprintf('Standard Deviation of Filtered Signal (%s) using %s Filter\n [%s]', selected_signal_type, selected_filtering_technique, summary_str));
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
title(sprintf('Mean Bias, Variance, and Std Dev (%s) using %s Filter\n [%s]', selected_signal_type, selected_filtering_technique, summary_str));
xlabel('Sample Index');
ylabel('Value');
legend({'Mean Bias', 'Mean Variance', 'Mean Std Dev'}, 'Location', 'northeast');
grid on;
figures{end+1} = fig6;
filenames_png{end+1} = generate_filename('Mean_Bias_Variance_StdDev', file_counter, 'png');
file_counter = file_counter + 1;

%% Compute Bias at Each Realization and Its Variance & Std Dev
% Compute the bias at each realization
bias_realizations = filtered_signal - signal;  % Size: [noOfSamples x length(M) x nRand]

% Compute mean bias over realizations (should match existing 'bias' variable)
mean_filtered_signal = mean(filtered_signal, 3);
bias = mean_filtered_signal - signal;  % Mean bias

% Compute variance and standard deviation of the bias
var_bias = var(bias_realizations, 0, 3);  % Variance of the bias
std_bias = sqrt(var_bias);

% Compute mean values over sample points for summary
mean_bias = mean(bias, 1);
mean_variance = mean(variance, 1);
mean_std_dev = mean(standard_deviation, 1);
mean_var_bias = mean(var_bias, 1);
mean_std_bias = mean(std_bias, 1);

% Update summary string
summary_str = sprintf('Bias: %.4f, Variance: %.4f, Std Dev: %.4f, Var(Bias): %.4f, Std Dev(Bias): %.4f', ...
                      mean(mean_bias), mean(mean_variance), mean(mean_std_dev), ...
                      mean(mean_var_bias), mean(mean_std_bias));

% Display experimental bias & variance
disp('Experimental bias & variance');
disp('M_value\tMean_Bias\tMean_Variance\tMean_Var_Bias\tMean_StdDev_Bias');
disp([P.Lee.M_values' mean_bias' mean_variance' mean_var_bias' mean_std_bias']);




%% Plotting Variance and Standard Deviation of the Bias
% 7. Plot the variance of the bias for each filter size
fig7 = figure;
plot(valid_range, var_bias(valid_range, :));
title(sprintf('Variance of Bias (%s) using %s Filter\n [%s]', selected_signal_type, selected_filtering_technique, summary_str));
xlabel('Sample Index');
ylabel('Variance of Bias');
legend(leg, 'Location', 'northeast');
grid on;
figures{end+1} = fig7;
filenames_png{end+1} = generate_filename('Variance_of_Bias', file_counter, 'png');
file_counter = file_counter + 1;

% 8. Plot the standard deviation of the bias for each filter size
fig8 = figure;
plot(valid_range, std_bias(valid_range, :));
title(sprintf('Standard Deviation of Bias (%s) using %s Filter\n [%s]', selected_signal_type, selected_filtering_technique, summary_str));
xlabel('Sample Index');
ylabel('Std Dev of Bias');
legend(leg, 'Location', 'northeast');
grid on;
figures{end+1} = fig8;
filenames_png{end+1} = generate_filename('StdDev_of_Bias', file_counter, 'png');
file_counter = file_counter + 1;


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

