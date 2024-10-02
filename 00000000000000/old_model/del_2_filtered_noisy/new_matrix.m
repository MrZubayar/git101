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

%% 1. Subtract the Original Signal from the Filtered Signal

% Initialize the error matrix
error_matrix = zeros(P.noOfSamples, length(P.Lee.M_values), P.nRand);

% Subtract the original clean signal from the filtered signals
for rr = 1:P.nRand
    % For each filter size
    for im = 1:length(P.Lee.M_values)
        error_matrix(:, im, rr) = filtered_signal(:, im, rr) - signal';
    end
end

%% 2. Compute New Metrics (Mean Squared Error)

% Compute the Mean Squared Error (MSE) across samples and random runs for each filter size
MSE_per_M = zeros(1, length(P.Lee.M_values));

for im = 1:length(P.Lee.M_values)
    % Extract the error for the current filter size across all samples and random runs
    current_error = squeeze(error_matrix(:, im, :));  % Size [N_x, Nrand]
    
    % Compute the MSE: Mean of the squared errors
    MSE_per_M(im) = mean(current_error(:).^2);
end

% Display the MSE for each filter size
disp('Mean Squared Error for each filter size M:');
disp(table(P.Lee.M_values', MSE_per_M', 'VariableNames', {'Filter_Size_M', 'MSE'}));

%% 3. Plot the MSE against the Filter Sizes

fig_mse = figure;
plot(P.Lee.M_values, MSE_per_M, 'o-', 'LineWidth', 2);
title(strrep(sprintf('Mean Squared Error vs. Filter Size (%s) using %s Filter', selected_signal_type, selected_filtering_technique),'_','\_'));
xlabel('Filter Size M');
ylabel('Mean Squared Error (MSE)');
grid on;
figures{end+1} = fig_mse;
filenames_png{end+1} = generate_filename('MSE_vs_FilterSize', file_counter, 'png');
file_counter = file_counter + 1;

%% Optional: Plot the Error Distribution for a Selected Filter Size

% Select a filter size (e.g., M = 10)
selected_M_index = find(P.Lee.M_values == 10);
if isempty(selected_M_index)
    selected_M_index = round(length(P.Lee.M_values)/2);  % Choose the middle one if M=10 not found
end

% Extract the errors for the selected filter size
selected_errors = squeeze(error_matrix(:, selected_M_index, :));  % Size [N_x, Nrand]

% Flatten the errors to a single vector
flattened_errors = selected_errors(:);

% Plot the histogram of errors
fig_error_hist = figure;
histogram(flattened_errors, 50);
title(strrep(sprintf('Error Distribution for Filter Size M = %d (%s) using %s Filter', P.Lee.M_values(selected_M_index), selected_signal_type, selected_filtering_technique),'_','\_'));
xlabel('Error');
ylabel('Frequency');
grid on;
figures{end+1} = fig_error_hist;
filenames_png{end+1} = generate_filename('Error_Distribution', file_counter, 'png');
file_counter = file_counter + 1;

%% Save New Figures if Desired

% Ask to save the new figures
save_choice_new = input('Do you want to save the new figures? (y/n): ', 's');
if strcmpi(save_choice_new, 'y')
    for i = length(figures)-1:length(figures)
        exportgraphics(figures{i}, filenames_png{i}, 'Resolution', 600);  % Save as PNG
    end
    fprintf('New figures have been saved.\n');
else
    fprintf('New figures were not saved.\n');
end
