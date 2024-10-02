function plot_and_save_figures(filter_name, signal, original_signal, mean_filtered_signal, ...
                               bias, variance, standard_deviation, summary_str, P, ...
                               snr_values, rmse_values, psnr_values, md_values, ...
                               ad_values, nk_values, nae_values, uqi_values, ...
                               sc_values, mssim_values, selected_signal_type)
    % Define legend for filter sizes
    leg = {};
    for ii = 1:length(P.Lee.M_values)
        leg{ii} = ['M = ', int2str(P.Lee.M_values(ii))];
    end

    % Define gray color for individual curves
    gray_color = [0.8, 0.8, 0.8];

    output_dir = 'SavedFigures';
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    generate_filename = @(basename, plot_number, ext) fullfile(output_dir, sprintf('%02d_%s_%s_%s_var_%.2f.%s', plot_number, basename, filter_name, selected_signal_type, P.signal_variance, ext));

    figures = {};
    filenames_png = {};

    file_counter = 1;

    valid_range = 1:(P.noOfSamples - P.noOfTranscendSamples);

    % 1. Plot the original signal and noisy signal together
    fig1 = figure;
    plot(valid_range, signal(valid_range), 'k--'); hold on;
    plot(valid_range, mean(original_signal(valid_range, :), 2), 'r');
    title(strrep(sprintf('Original and Noisy Signals (Var: %.2f) (%s) using %s Filter\n [%s]', P.signal_variance, selected_signal_type, filter_name, summary_str),'_','\_'));
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
    title(strrep(sprintf('Mean Filtered Signals (Var: %.2f) (%s) using %s Filter\n [%s]', P.signal_variance, selected_signal_type, filter_name, summary_str),'_','\_'));
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
    title(strrep(sprintf('Bias of Filtered Signal (Var: %.2f) (%s) using %s Filter\n [%s]', P.signal_variance, selected_signal_type, filter_name, summary_str),'_','\_'));
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
    title(strrep(sprintf('Variance of Filtered Signal (Var: %.2f) (%s) using %s Filter\n [%s]', P.signal_variance, selected_signal_type, filter_name, summary_str),'_','\_'));
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
    title(strrep(sprintf('Standard Deviation of Filtered Signal (Var: %.2f) (%s) using %s Filter\n [%s]', P.signal_variance, selected_signal_type, filter_name, summary_str),'_','\_'));
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
    title(strrep(sprintf('Mean Bias, Variance, and Std Dev (Var: %.2f) (%s) using %s Filter\n [%s]', P.signal_variance, selected_signal_type, filter_name, summary_str),'_','\_'));
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

    for rr = 1:P.nRand
        plot(P.Lee.M_values, snr_values(:, rr), 'Color', gray_color);
    end

    plot(P.Lee.M_values, mean(snr_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

    title(strrep(sprintf('Mean SNR (Var: %.2f) across Realizations for Different M Values \n (%s) using %s Filter', P.signal_variance, selected_signal_type, filter_name),'_','\_'));
    xlabel('M Value');
    ylabel('SNR (dB)');
    xticks(P.Lee.M_values);
    grid on;
    legend({'Individual Realizations', 'Mean SNR'}, 'Location', 'northeast');
    figures{end+1} = fig7;
    filenames_png{end+1} = generate_filename('SNR_vs_M', file_counter, 'png');
    file_counter = file_counter + 1;

    % 8. Plot RMSE across different M values
    fig8 = figure;
    hold on;

    for rr = 1:P.nRand
        plot(P.Lee.M_values, rmse_values(:, rr), 'Color', gray_color);
    end

    plot(P.Lee.M_values, mean(rmse_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

    title(strrep(sprintf('Mean RMSE (Var: %.2f) across Realizations for Different M Values \n (%s) using %s Filter', P.signal_variance, selected_signal_type, filter_name),'_','\_'));
    xlabel('M Value');
    ylabel('RMSE');
    xticks(P.Lee.M_values);
    grid on;
    legend({'Individual Realizations', 'Mean RMSE'}, 'Location', 'northeast');
    figures{end+1} = fig8;
    filenames_png{end+1} = generate_filename('RMSE_vs_M', file_counter, 'png');
    file_counter = file_counter + 1;

    % 9. Plot PSNR across different M values
    fig9 = figure;
    hold on;

    for rr = 1:P.nRand
        plot(P.Lee.M_values, psnr_values(:, rr), 'Color', gray_color);
    end

    plot(P.Lee.M_values, mean(psnr_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

    title(strrep(sprintf('Mean PSNR (Var: %.2f) across Realizations for Different M Values \n (%s) using %s Filter', P.signal_variance, selected_signal_type, filter_name),'_','\_'));
    xlabel('M Value');
    ylabel('PSNR (dB)');
    xticks(P.Lee.M_values);
    grid on;
    legend({'Individual Realizations', 'Mean PSNR'}, 'Location', 'northeast');
    figures{end+1} = fig9;
    filenames_png{end+1} = generate_filename('PSNR_vs_M', file_counter, 'png');
    file_counter = file_counter + 1;

    % 10. Plot MD across different M values
    fig10 = figure;
    hold on;

    for rr = 1:P.nRand
        plot(P.Lee.M_values, md_values(:, rr), 'Color', gray_color);
    end

    plot(P.Lee.M_values, mean(md_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

    title(strrep(sprintf('Mean MD (Var: %.2f) across Realizations for Different M Values \n (%s) using %s Filter', P.signal_variance, selected_signal_type, filter_name),'_','\_'));
    xlabel('M Value');
    ylabel('MD');
    xticks(P.Lee.M_values);
    grid on;
    legend({'Individual Realizations', 'Mean MD'}, 'Location', 'northeast');
    figures{end+1} = fig10;
    filenames_png{end+1} = generate_filename('MD_vs_M', file_counter, 'png');
    file_counter = file_counter + 1;

    % 11. Plot AD across different M values
    fig11 = figure;
    hold on;

    for rr = 1:P.nRand
        plot(P.Lee.M_values, ad_values(:, rr), 'Color', gray_color);
    end

    plot(P.Lee.M_values, mean(ad_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

    title(strrep(sprintf('Mean AD (Var: %.2f) across Realizations for Different M Values \n (%s) using %s Filter', P.signal_variance, selected_signal_type, filter_name),'_','\_'));
    xlabel('M Value');
    ylabel('AD');
    xticks(P.Lee.M_values);
    grid on;
    legend({'Individual Realizations', 'Mean AD'}, 'Location', 'northeast');
    figures{end+1} = fig11;
    filenames_png{end+1} = generate_filename('AD_vs_M', file_counter, 'png');
    file_counter = file_counter + 1;

    % 12. Plot NK across different M values
    fig12 = figure;
    hold on;

    for rr = 1:P.nRand
        plot(P.Lee.M_values, nk_values(:, rr), 'Color', gray_color);
    end

    plot(P.Lee.M_values, mean(nk_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

    title(strrep(sprintf('Mean NK (Var: %.2f) across Realizations for Different M Values \n (%s) using %s Filter', P.signal_variance, selected_signal_type, filter_name),'_','\_'));
    xlabel('M Value');
    ylabel('NK');
    xticks(P.Lee.M_values);
    grid on;
    legend({'Individual Realizations', 'Mean NK'}, 'Location', 'northeast');
    figures{end+1} = fig12;
    filenames_png{end+1} = generate_filename('NK_vs_M', file_counter, 'png');
    file_counter = file_counter + 1;

    % 13. Plot NAE across different M values
    fig13 = figure;
    hold on;

    for rr = 1:P.nRand
        plot(P.Lee.M_values, nae_values(:, rr), 'Color', gray_color);
    end

    plot(P.Lee.M_values, mean(nae_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

    title(strrep(sprintf('Mean NAE (Var: %.2f) across Realizations for Different M Values \n (%s) using %s Filter', P.signal_variance, selected_signal_type, filter_name),'_','\_'));
    xlabel('M Value');
    ylabel('NAE');
    xticks(P.Lee.M_values);
    grid on;
    legend({'Individual Realizations', 'Mean NAE'}, 'Location', 'northeast');
    figures{end+1} = fig13;
    filenames_png{end+1} = generate_filename('NAE_vs_M', file_counter, 'png');
    file_counter = file_counter + 1;

    % 14. Plot UQI across different M values
    fig14 = figure;
    hold on;

    for rr = 1:P.nRand
        plot(P.Lee.M_values, uqi_values(:, rr), 'Color', gray_color);
    end

    plot(P.Lee.M_values, mean(uqi_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

    title(strrep(sprintf('Mean UQI (Var: %.2f) across Realizations for Different M Values \n (%s) using %s Filter', P.signal_variance, selected_signal_type, filter_name),'_','\_'));
    xlabel('M Value');
    ylabel('UQI');
    xticks(P.Lee.M_values);
    grid on;
    legend({'Individual Realizations', 'Mean UQI'}, 'Location', 'northeast');
    figures{end+1} = fig14;
    filenames_png{end+1} = generate_filename('UQI_vs_M', file_counter, 'png');
    file_counter = file_counter + 1;

    % 15. Plot SC across different M values
    fig15 = figure;
    hold on;

    for rr = 1:P.nRand
        plot(P.Lee.M_values, sc_values(:, rr), 'Color', gray_color);
    end

    plot(P.Lee.M_values, mean(sc_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

    title(strrep(sprintf('Mean SC (Var: %.2f) across Realizations for Different M Values \n (%s) using %s Filter', P.signal_variance, selected_signal_type, filter_name),'_','\_'));
    xlabel('M Value');
    ylabel('SC');
    xticks(P.Lee.M_values);
    grid on;
    legend({'Individual Realizations', 'Mean SC'}, 'Location', 'northeast');
    figures{end+1} = fig15;
    filenames_png{end+1} = generate_filename('SC_vs_M', file_counter, 'png');
    file_counter = file_counter + 1;

    % 16. Plot MSSIM across different M values
    fig16 = figure;
    hold on;

    for rr = 1:P.nRand
        plot(P.Lee.M_values, mssim_values(:, rr), 'Color', gray_color);
    end

    plot(P.Lee.M_values, mean(mssim_values, 2), '-x', 'LineWidth', 1, 'Color', 'r');

    title(strrep(sprintf('Mean MSSIM (Var: %.2f) across Realizations for Different M Values \n (%s) using %s Filter', P.signal_variance, selected_signal_type, filter_name),'_','\_'));
    xlabel('M Value');
    ylabel('MSSIM');
    xticks(P.Lee.M_values);
    grid on;
    legend({'Individual Realizations', 'Mean MSSIM'}, 'Location', 'northeast');
    figures{end+1} = fig16;
    filenames_png{end+1} = generate_filename('MSSIM_vs_M', file_counter, 'png');
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
end
