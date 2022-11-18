    function y = logSineSweep(startFrequency, endFrequency, amplitude, numChannels, lengthInSeconds, fs)

        N = lengthInSeconds * fs;
        t = 1/fs;
        % t = (0:dt:(N-1)*dt);
        phase = 0;

        y = zeros(N, numChannels);  % Output buffer

        f = linspace(log10(startFrequency), log10(endFrequency), N);
        f = transpose(f);
        f = 10.^f;

        for n = 1:N
            y(n, :) = 10^(amplitude/20)*sin(phase);
            phase = phase + 2*pi*f(n)*t;
            if phase > 2*pi*f(n)*t;
                phase = phase - 2*pi;
            end
        end

    end