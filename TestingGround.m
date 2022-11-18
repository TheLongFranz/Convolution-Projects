clear;clc;close

% The process of overlaying the impulse response on top of the input stream
% of impulses x(n) and adding up the results to get the final time domain output y(n) is called convolution.

% Add the dependencies to the project path relative to the project folder
addpath('Functions')
addpath('AudioSamples')
% fs = 48000;
% x = kroneckerDelta(2, 1, fs);
[x, fs] = audioread("AudioSamples/Guitar.wav");     % Read in the input file 
[xMid, xSide] = midSideEncode(x);                   % Decompose stereo input signal into mid and side components

test1 = fft(xMid);
test2 = dft(xMid);

subplot(2, 1, 1)
plot(linspace(0, fs, length(x)), 20*log10(abs(test1)));
title("Built in MATLAB function")
subplot(2, 1, 2)
plot(linspace(0, fs, length(x)), 20*log10(abs(test2)));
title("My function")