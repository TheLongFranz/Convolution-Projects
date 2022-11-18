    function y = impulse(numChannels, ...
            lengthInSeconds, ...
            fs)

        N = lengthInSeconds * fs;
        x = zeros(N, numChannels);
        x(1, :) = 1;

        y = x;

    end