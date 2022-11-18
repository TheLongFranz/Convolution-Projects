function [temp] = linSineSweep(startFrequency, ...
    endFrequency, ...
    gaindBFS, ...
    numChannels, ...
    lengthInSeconds, ...
    fs)

%% Error Handling
if gaindBFS > 0
    error('Gain value must be less than zero and in dBFS.')
else
    if endFrequency > fs/2
        error('Frequency must not exceed the sample rate bandwidth.')
    end

    %% Processing
    N = lengthInSeconds * fs;
    t = 1/fs;
    phase = 0;

    temp = zeros(N, numChannels);  % Output buffer
    f = linspace(startFrequency, endFrequency, N)';
    for c = 1:numChannels
        for n = 1:N
            temp(n, c) = 10^(gaindBFS/20)*sin(phase);
            phase = phase + 2*pi*f(n)*t;
            if phase > 2*pi*f(n)*t
                phase = phase - 2*pi;
            end
        end
    end
    y = [temp(:, 1), temp(:, 1)];
end