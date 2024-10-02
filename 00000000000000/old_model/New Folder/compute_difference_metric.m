function metric_value = compute_difference_metric(difference)
    % Function to calculate the desired metric based on the difference
    %
    % Input:
    %   difference: [samples x M_values x nRand] matrix of differences
    %
    % Output:
    %   metric_value: [M_values x nRand] matrix of metric values

    % Compute mean absolute error along the first dimension (samples)
    % Resulting in a [1 x M_values x nRand] matrix
    cdm = mean(abs(difference), 1);
    % Squeeze the first dimension to get [M_values x nRand]
    metric_value = squeeze(cdm);
end
