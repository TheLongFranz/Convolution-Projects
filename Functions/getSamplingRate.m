function y = getSamplingRate(x)
nSamples = length(x)
samplesPerSecond = 60/nSamples
% 
% sampleRate = nSamples / samplingTime;
% % sr = Nsamples / TotalSamplingtime = numel(t) / (t(end)-t(1))
% y = 1 / sampleRate;
x = x(:, 1);
dt = std(diff(x));
y = 1 / dt;

end