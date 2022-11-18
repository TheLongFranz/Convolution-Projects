function y = GenerateNoise(gaindBFS, ...
    numChannels, ...
    lengthInSeconds, ...
    fs)
% ========================================
% Error Handling
if gaindBFS > 0
    error('Gain value must be less than zero and in dBFS.')
else
    % ========================================
    % Noise Signal Generator
    N = lengthInSeconds * fs;
    y = 10^(gaindBFS/20) * rand(N, numChannels);

end