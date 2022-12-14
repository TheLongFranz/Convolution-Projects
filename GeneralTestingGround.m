clear;clc;close
addpath("Functions"); addpath("AudioSamples");
[h, fs] = audioread('AudioSamples/Guitar.wav'); % Read in the audio
[h, ~] = midSideEncode(h); % Mono
x = audioread("AudioSamples/SilverVerb_IRMono.wav");
X = Z(x);
x1 = complexSineWave(5, -10, 1, 1, fs);
X1 = Z(x1);
x2 = sineWave(5, -10, 1, 1, fs);
X2 = Z(x2);

plot(X)
hold on
plot(X1)
plot(X2)
axis([-1 1 -1 1])
legend(["Silverb IR" "Complex Sine wave with f = 5Hz" "Sine wave with f = 5Hz"]);

% =========================================================================
% PARTITION
% bufferSize = 1024; % set buffer length
% hLen = length(h);
% [h1, idx] = partition(h, bufferSize, 1)

% =========================================================================
% DISCRETE FOURIER TRANSFORM

% =========================================================================
% OVERLAP/ADD/SAVE





% =========================================================================
% CONVOLUTION
% Gardners fast convolution requires breaking down the ir into chunks
% followed by a special setup of 50% overlap/add. Fortunately we can achieve
% most of this already using our partition function, however we may need to
% look at how the overlap/add works and maybe some internal padding in the
% function.

%{
Notes from https://youtu.be/fYggIQTaVx4

LINEAR Convoltion processing time: 0*(N^2) {
This is too slow for real time processing.}

CIRCULAR convolution processing time: 0*(N log(N))
Very fast.

Zero padding can be used to make circular convolution yield the same
results as linear convolution. It can also be used to ensure that the input
signals are both a length that is a power of two, this is necessary for
the Fast Fourier Transform to work.

Performing circular convolution:
        c[n] = ifft(fft(x[n], k) * fft(h[n], k), k);
Using k point fft and ifft algorithms and then extracting the original
sample size we had before zero padding.



%}

% Nfour = 1024
% Ntwo = .5*Nfour
% N = .25*Nfour

% USE action verbs at the start of comments so you can easily read what
% you're doing

% TODO: COMPARE OVERLAP/ADD & OVERLAP/SAVE SO THAT YOU
% UNDERSTAND IT, THIS COULD BE DONE IN ISOLATION. MAKE THIS AS AN EXTENSION
% OF THE PARTITION FUNCTION SINCE OVERLAP/ADD SEEMS TO BE A COMBINATION OF
% PARTITION AND ZEROPAD. THIS WILL LIKELY NEED TO BE A CLASS SO THAT YOU
% CAN KEEP TRACK OF OVERLAP-1.

% TODO AFTER THAT: MAKE AN IMPLEMENTATION OF GARDNERS FAST CONVOLUTION