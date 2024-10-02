function P = Parameters(selected_variant)
    % Function that returns parameters used in simulations
    P.selected_variant = selected_variant;

    switch selected_variant

        case 'sigmoid'
            P.noOfSamples = 500;
            P.noOfTranscendSamples = 50; % Number of samples to exclude at the end
            P.nRand = 500;
            P.seed = 1002;
            P.signal_variance = 1;

            % Lee filter parameters
            P.Lee.M_values = 2:21;
            P.Lee.noise_variance = 4;

            % Sigmoid signal
            P.Sigmoid.transition_width = 50;

            % Signal type
            P.SignalType = 'Sigmoid';

        case 'constant'
            P.noOfSamples = 500;
            P.noOfTranscendSamples = 50; % Number of samples to exclude at the end
            P.nRand = 500;
            P.seed = 1002;
            P.signal_variance = 1;

            % Lee filter parameters
            P.Lee.M_values = 2:21;  % needs to start at 2 since algorithm divides on "(M-1)"
            P.Lee.noise_variance = 4;

            % Constant signal
            P.ConstantSign.DC = 1;

            % Signal type
            P.SignalType = 'Constant';

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

            % Signal type
            P.SignalType = 'EqualPulse';

        otherwise
            error(['Variant ' selected_variant ' not implemented.']);
    end
end
