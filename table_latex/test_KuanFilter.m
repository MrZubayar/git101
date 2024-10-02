% Parameters. Read from own function
% P = Parameters('baseline_sigmoid');
% P = Parameters('baseline_constant');
% P = Parameters('baseline_triangle');
P = Parameters('baseline_sinusoid');  % Select the signal type as needed

signal = getSignal(P);

filtered_signal = zeros(P.noOfSamples, length(P.Kuan.M_values), P.nRand);
original_signal = zeros(P.noOfSamples, P.nRand);

rng(P.seed);  % Initialize random generator

for rr = 1:P.nRand
    
    noisy_signal = signal + P.signal_variance * randn(1, P.noOfSamples);
    original_signal(:, rr) = noisy_signal;  % Saving original signal

    % Use the Kuan filter instead of the Lee filter
    filtered_signal(:, 1:length(P.Kuan.M_values), rr) = KuanFilter(noisy_signal, P.Kuan.M_values, P.Kuan.noise_variance);
    
end

%% Calculate Mean and Standard Deviation for Each M
means = mean(mean(filtered_signal, 1), 3);
stds = mean(std(filtered_signal, 0, 1), 3);

%% Plotting

plot(mean(filtered_signal, 3))

leg = {};
for ii = 1:length(P.Kuan.M_values)
    leg{ii} = int2str(P.Kuan.M_values(ii));
end
legend(leg, 'Location', 'southeast')

% Plotting Mean and Standard Deviation as Function of M
figure;

% Plot mean
subplot(2, 1, 1);
plot(P.Kuan.M_values, squeeze(means));
title('Mean of Filtered Signal vs M');
xlabel('M');
ylabel('Mean');
grid on;

% Plot standard deviation
subplot(2, 1, 2);
plot(P.Kuan.M_values, squeeze(stds));
title('Standard Deviation of Filtered Signal vs M');
xlabel('M');
ylabel('Standard Deviation');
grid on;

%% Analyze
% Use selected signal as input

% Avoid edge effects
indToAnalyze = max(P.Kuan.M_values):length(signal) - max(P.Kuan.M_values) - 1;

% Numerical Display of Diagnostic Metrics
disp('Experimental bias & variance');
diagnostic_matrix = [P.Kuan.M_values' squeeze(means).' squeeze(stds).']

disp('Bias and variance from the original signal');
disp([mean(mean(original_signal, 1)) mean(var(original_signal, 1))])

%% Test with image quality evaluation metrics metrics
quality_evaluation_metrics_kuan('SNR', P);
quality_evaluation_metrics_kuan('RMSE', P);
quality_evaluation_metrics_kuan('PSNR', P);
quality_evaluation_metrics_kuan('MD', P);
quality_evaluation_metrics_kuan('AD', P);
quality_evaluation_metrics_kuan('NK', P);
quality_evaluation_metrics_kuan('NAE', P);
quality_evaluation_metrics_kuan('UQI', P);
quality_evaluation_metrics_kuan('SC', P);
quality_evaluation_metrics_kuan('MSSIM', P);
