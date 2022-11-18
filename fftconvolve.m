% fftconvolve
addpath('Functions'); addpath('AudioSamples'); clear;clc;close
% Speed Up convolve function
[h, fs] = audioread("AudioSamples/SilverVerb_IR.wav");
[h, hSide] = midSideEncode(h);
[N, C] = size(h);
x = zeros(length(h), C);
x(1) = 1;

LoopLength = 1000;

CircularConvolutionTime = zeros(LoopLength, 1);
LinearConvolutionTime = zeros(LoopLength, 1);

for n = 1:LoopLength
tic
y = ifft(fft(x) .* fft(h)); % Circular Convolution
CircularConvolutionTime(n) = toc;

tic
y2 = conv(x, h, 'full');
LinearConvolutionTime(n) = toc;
end

CircularConvolutionTimeAvg = mean(CircularConvolutionTime)
LinearConvolutionTimeAvg = mean(LinearConvolutionTime)