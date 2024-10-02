function metric_value = quality_evaluation_metrics(selected_metric, filtered_signal, original_signal, P)
    % Function to calculate quality metrics based on filtered signals

    % Initialize variable to accumulate metric results
    metric_value = zeros(size(filtered_signal, 2), P.nRand);
    for mm = 1: size(filtered_signal, 2)
        for rr = 1:P.nRand
            % Calculate the metric for this realization
            switch selected_metric
                case 'SNR'
                    metric_value(mm, rr) = SNR(original_signal(:, rr), filtered_signal(:, mm, rr));

                case 'RMSE'
                    metric_value(mm, rr) = RMSE(original_signal(:, rr), filtered_signal(:, mm, rr));

                case 'PSNR'
                    metric_value(mm, rr) = PSNR(original_signal(:, rr), filtered_signal(:, mm, rr));

                case 'NK'
                    metric_value(mm, rr) = NK(original_signal(:, rr), filtered_signal(:, mm, rr));

                case 'AD'
                    metric_value(mm, rr) = AD(original_signal(:, rr), filtered_signal(:, mm, rr));

                case 'MD'
                    metric_value(mm, rr) = MD(original_signal(:, rr), filtered_signal(:, mm, rr));

                case 'NAE'
                    metric_value(mm, rr) = NAE(original_signal(:, rr), filtered_signal(:, mm, rr));

                case 'SC'
                    metric_value(mm, rr) = SC(original_signal(:, rr), filtered_signal(:, mm, rr));

                case 'UQI'
                    metric_value(mm, rr)= UQI(original_signal(:, rr), filtered_signal(:, mm, rr));

                case 'MSSIM'
                    metric_value(mm, rr) = MSSIM(original_signal(:, rr), filtered_signal(:, mm, rr));

                otherwise
                    error('Selected metric not recognized. Please choose a valid metric.');
            end
        end
    end
   
    % Calculate the average metric over all realizations for each M
    average_metric = mean(metric_value, 2);
    
    % Display the average results for all individual M values
    fprintf('Average %s for individual M values:\n', selected_metric);
    for mm = 1:length(P.Lee.M_values)
        fprintf('M = %d: %.2f\n', P.Lee.M_values(mm), average_metric(mm));
    end
    
    % Calculate the overall average across all M values
    overall_average = mean(average_metric);
    
    % Display the overall average
    fprintf('Overall Average %s across all M values: %.2f\n', selected_metric, overall_average);
end
