clear;clc;close
addpath("Functions"); addpath("AudioSamples"); 
% [h, fs] = audioread('AudioSamples/Guitar.wav'); % Read in the audio
% [h, ~] = midSideEncode(h); % Mono
% x = audioread("AudioSamples/SilverVerb_IR.wav");
% x = x(:);

h = 1:4;
x = 5:8;

c = linConvolve(h, x)
c1 = conv(h, x)
c2 = circConvolve(h, x)
c3 = circToLinConvolve(h, x)

% =========================================================================
% PARTITION
% bufferSize = 1024; % set buffer length
% hLen = length(h);
% [h1, idx] = partition(h, bufferSize, 1)

% =========================================================================
% OVERLAP/ADD/SAVE

% =========================================================================
% CONVOLUTION
% Gardners fast convolution requires breaking down the ir into chunks 
% followed by a special setup of 50% overlap/add. Fortunately we can achieve
% most of this already using our partition function, however we may need to
% look at how the overlap/add works and maybe some internal padding in the
% function.

% Nfour = 1024
% Ntwo = .5*Nfour
% N = .25*Nfour


% TODO AFTER THAT: COMPARE OVERLAP/ADD & OVERLAP/SAVE SO THAT YOU
% UNDERSTAND IT, THIS COULD BE DONE IN ISOLATION
% TODO AFTER THAT: MAKE AN IMPLEMENTATION OF GARDNERS FAST CONVOLUTION