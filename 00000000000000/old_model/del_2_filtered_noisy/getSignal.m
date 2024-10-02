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

        otherwise
            error (['Signal ',P.SignalType,' is not defined']);
    end
end
