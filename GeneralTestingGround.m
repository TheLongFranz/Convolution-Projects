clear;clc;close
addpath("Functions"); addpath("AudioSamples"); 
% [h, fs] = audioread('AudioSamples/Guitar.wav'); % Read in the audio
% [h, ~] = midSideEncode(h); % Mono
% x = audioread("AudioSamples/SilverVerb_IR.wav");
% x = x(:);

x = 1:4;
h = 5:8;

% c = linConvolve(h, x);
% c1 = conv(h, x);
c2 = circConvolve(h, x);
% c3 = circToLinConvolve(h, x);

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


% TODO: COMPARE OVERLAP/ADD & OVERLAP/SAVE SO THAT YOU
% UNDERSTAND IT, THIS COULD BE DONE IN ISOLATION. MAKE THIS AS AN EXTENSION
% OF THE PARTITION FUNCTION SINCE OVERLAP/ADD SEEMS TO BE A COMBINATION OF
% PARTITION AND ZEROPAD. THIS WILL LIKELY NEED TO BE A CLASS SO THAT YOU
% CAN KEEP TRACK OF OVERLAP-1.

% TODO AFTER THAT: MAKE AN IMPLEMENTATION OF GARDNERS FAST CONVOLUTION