function y = sineWave(frequency, ...
    gaindBFS, ...
    numChannels, ...
    lengthInSeconds, ...
    fs)
%% Error Handling
if gaindBFS > 0
    error('Gain value must be less than zero and in dBFS.')
else
    if frequency > fs/2
        error('Frequency must not exceed the sample rate bandwidth.')
    end

    %% Processing
    N = lengthInSeconds*fs;
    y = zeros(N, numChannels);
    ts = [0:(lengthInSeconds*fs)-1] * 1/fs';
    for c = 1:numChannels
        y(:, c) = 10^(gaindBFS/20)*sin(2*pi*frequency*ts);
    end

end