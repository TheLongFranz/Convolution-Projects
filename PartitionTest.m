clear;clc;close
[h, fs]= audioread('AudioSamples/SilverVerb_IR.wav'); % Read in the audio
[h, ~] = midSideEncode(h); % Mono
bufferSize = 1024; % set buffer length
hIdx = getPartitionSize(h, bufferSize)

% hSize = getPartitionSize(h, bufferSize);
h = partition(h, bufferSize, 0);
x = impulse(1, length(h)/fs, fs);
tic
c = convolve(h, x)
toc
%                 1024
c1 = partition(c, bufferSize, 0);
%                 1024 - 1
c2 = partition(c, bufferSize-1, 1);
%                 2047

plot(c1)
hold on
plot(c2)