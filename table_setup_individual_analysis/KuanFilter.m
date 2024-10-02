%
% Function that implements a 1D Lee filter 
%
% Input: 
%   signal  : unfiltered signal (1D signal)
%   M       : size of filters to use (vector)
%
% Output    : filtered signal
%
% Version   : 1.0, July 2 2024: Initial version
%

function [filtered_signal] = KuanFilter(signal, M, noise_variance)

arguments
    signal  (1,:)   % signal is a vector and in function treated as a column vector
    M       (1,:)   % vector of filter sizes
    noise_variance double
end

% Allocate output variable
filtered_signal = zeros(length(signal), length(M));

% For each value of M, calculate mean and variance within filter, then compute the Kuan filter output
for im = 1:length(M)
    
    % Convolve signal with moving average filter of length 'M' that sums to one. 
    local_mean = conv(signal, ones(1, M(im)) / M(im), 'same');
    
    % Convolve signal.^2 with moving average filter of length 'M'
    local_sum_sq = conv(signal.^2, ones(1, M(im)), 'same');  
    
    local_var = (local_sum_sq - M(im) * local_mean.^2) / (M(im) - 1);
    
    % Calculate the Kuan filter coefficient
    K = local_var ./ (local_var + noise_variance * (local_mean.^2 + noise_variance));
    
    % Apply the Kuan filter to the signal
    filtered_signal(:, im) = local_mean + K .* (signal - local_mean);
    
end



    