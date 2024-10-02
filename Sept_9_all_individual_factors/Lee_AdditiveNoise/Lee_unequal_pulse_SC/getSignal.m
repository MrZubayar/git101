function signal = getSignal(P)
    % Function that defines the signals to use

    switch P.SignalType
        case 'Sigmoid' 
            x = linspace(-10, 10, P.noOfSamples);
            signal = 5 * (1 ./ (1 + exp(-x*P.Sigmoid.transition_width)));  % Sigmoid function scaled to 0-5 range

        case 'Constant'
            signal = P.ConstantSign.DC * ones(1, P.noOfSamples);

        case 'EqualPulse'
            t = linspace(0, P.numReps*2*pi, P.noOfSamples);
            signal = (square(t) + 1) / 2;  % Shifted to range [0, 1]

        case 'PosNegPulse'
            t = linspace(0, P.numReps*2*pi, P.noOfSamples);
            signal = square(t);  % Square wave with values alternating between +1 and -1

        case 'UnequalPulse'
            t = linspace(0, P.numReps*2*pi, P.noOfSamples);
            signal = square(t, 25);  % Unequal duty cycle (25%)

        case 'Triangle'
            t = linspace(0, 1, P.noOfSamples);
            signal = P.Triangle.amplitude * sawtooth(2 * pi * P.Triangle.frequency * t, 0.5);

        case 'Sinusoid'
            t = linspace(0, 1, P.noOfSamples);
            signal = P.Sinusoid.amplitude * sin(2 * pi * P.Sinusoid.frequency * t);

        otherwise
            error (['Signal ',P.SignalType,' is not defined']);
    end
end
