function [filtered_signal, original_signal, signal] = test_filter(P)
    % Function to perform the filtering based on the parameters in P

    signal = getSignal(P);  % Original signal

    filtered_signal = zeros(P.noOfSamples, length(P.Lee.M_values), P.nRand);
    original_signal = zeros(P.noOfSamples, P.nRand);

    rng(P.seed);  % Initialize random generator

    for rr = 1:P.nRand
        noisy_signal = signal + P.signal_variance * randn(1, P.noOfSamples);
        original_signal(:, rr) = noisy_signal; % Save original noisy signal

        filtered_signal(:, 1:length(P.Lee.M_values), rr) = LeeFilter(noisy_signal, P.Lee.M_values, P.Lee.noise_variance);
    end
end
