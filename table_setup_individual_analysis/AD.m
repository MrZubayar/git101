% % AD Calculation (Average Difference)
% function AD_value = AD(original_signal, filtered_signal)
%     AD_value = mean(filtered_signal - original_signal);
% end
% 
%%
function AD_value = AD(original_signal, filtered_signal)
    % AD Calculation (Average Difference)
    % Input:
    %   original_signal: The original 1D signal
    %   filtered_signal: The filtered/denoised 1D signal
    % Output:
    %   AD_value: The Average Difference between the original and filtered signals
    
    % Compute the absolute differences between corresponding elements
    absolute_differences = abs(filtered_signal - original_signal);
    
    % Calculate the mean of the absolute differences
    AD_value = mean(absolute_differences);
end
