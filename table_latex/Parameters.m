function P = Parameters(selected_variant)
    % Function that returns parameters used in simulations
    P.selected_variant = selected_variant;

    switch selected_variant
        case 'baseline_constant'
            P.noOfSamples = 500;
            P.noOfTranscendSamples = 50; % Number of samples to exclude at the end
            P.nRand = 500;
            P.seed = 1002;
            P.signal_variance = 1;

            % Lee filter parameters
            P.Lee.M_values = 2:21;  % needs to start at 2 since algorithm divides on "(M-1)"
            P.Lee.noise_variance = 4;

            % Kuan filter parameters
            P.Kuan.M_values = 2:21;
            P.Kuan.noise_variance = 4;

            % Constant signal
            P.ConstantSign.DC = 1;

            % Signal type
            P.SignalType = 'Constant';

        case 'baseline_sigmoid'
            P.noOfSamples = 500;
            P.noOfTranscendSamples = 50; % Number of samples to exclude at the end
            P.nRand = 500;
            P.seed = 1002;
            P.signal_variance = 1;

            % Lee filter parameters
            P.Lee.M_values = 2:21;
            P.Lee.noise_variance = 4;

            % Kuan filter parameters
            P.Kuan.M_values = 2:21;
            P.Kuan.noise_variance = 4;

            % Sigmoid signal
            P.Sigmoid.transition_width = 50;

            % Signal type
            P.SignalType = 'Sigmoid';

        case 'equal_pulse'
            P.noOfSamples = 500;
            P.noOfTranscendSamples = 50; % Number of samples to exclude at the end
            P.nRand = 500;
            P.seed = 1002;
            P.signal_variance = 1;
            P.numReps = 2;  % Number of repetitions for the pulse

            % Lee filter parameters
            P.Lee.M_values = 2:21;
            P.Lee.noise_variance = 4;

            % Kuan filter parameters
            P.Kuan.M_values = 2:21;
            P.Kuan.noise_variance = 4;

            % Signal type
            P.SignalType = 'EqualPulse';

        case 'pos_neg_pulse'
            P.noOfSamples = 500;
            P.noOfTranscendSamples = 50; % Number of samples to exclude at the end
            P.nRand = 500;
            P.seed = 1002;
            P.signal_variance = 1;
            P.numReps = 2;  % Number of repetitions for the pulse

            % Lee filter parameters
            P.Lee.M_values = 2:21;
            P.Lee.noise_variance = 4;

            % Kuan filter parameters
            P.Kuan.M_values = 2:21;
            P.Kuan.noise_variance = 4;

            % Signal type
            P.SignalType = 'PosNegPulse';

        case 'unequal_pulse'
            P.noOfSamples = 500;
            P.noOfTranscendSamples = 50; % Number of samples to exclude at the end
            P.nRand = 500;
            P.seed = 1002;
            P.signal_variance = 1;
            P.numReps = 2;  % Number of repetitions for the pulse

            % Lee filter parameters
            P.Lee.M_values = 2:21;
            P.Lee.noise_variance = 4;

            % Kuan filter parameters
            P.Kuan.M_values = 2:21;
            P.Kuan.noise_variance = 4;

            % Signal type
            P.SignalType = 'UnequalPulse';

        case 'baseline_triangle'
            P.noOfSamples = 500;
            P.noOfTranscendSamples = 50; % Number of samples to exclude at the end
            P.nRand = 500;
            P.seed = 1002;
            P.signal_variance = 1;

            % Lee filter parameters
            P.Lee.M_values = 2:21;
            P.Lee.noise_variance = 4;

            % Kuan filter parameters
            P.Kuan.M_values = 2:21;
            P.Kuan.noise_variance = 4;

            % Triangle signal
            P.Triangle.amplitude = 1;
            P.Triangle.frequency = 5;

            % Signal type
            P.SignalType = 'Triangle';

        case 'baseline_sinusoid'
            P.noOfSamples = 500;
            P.noOfTranscendSamples = 50; % Number of samples to exclude at the end
            P.nRand = 500;
            P.seed = 1002;
            P.signal_variance = 1;

            % Lee filter parameters
            P.Lee.M_values = 2:21;
            P.Lee.noise_variance = 4;

            % Kuan filter parameters
            P.Kuan.M_values = 2:21;
            P.Kuan.noise_variance = 4;

            % Sinusoid signal
            P.Sinusoid.amplitude = 1;
            P.Sinusoid.frequency = 5;

            % Signal type
            P.SignalType = 'Sinusoid';

        otherwise
            error(['Variant ' selected_variant ' not implemented.']);
    end
end
