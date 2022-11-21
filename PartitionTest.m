clear;clc;close
[h, fs] = audioread('AudioSamples/SilverVerb_IR.wav'); % Read in the audio
[h, ~] = midSideEncode(h); % Mono

Nfour = 1024
Ntwo = .5*Nfour
N = .25*Nfour



% bufferSize = 1024; % set buffer length%
% hLen = length(h);
% [h1, idx] = partition(h, bufferSize, 1)

% Gardners fast convolution requires breaking down the ir into chunks 
% followed by a special setup of 50% overlap/add. Fortunately we can achieve
% most of this already using our partition function, however we may need to
% look at how the overlap/add works and maybe some internal padding in the
% function.



% for n = 1:idx
%     n
%     [h1, ~] = partition(h, bufferSize, n);
% end

% x = impulse(1, bufferSize/fs, fs);
% 
% %
% c = convolve(h1, x);
% %                 1024
% [c1, cMaxIdx] = partition(c, bufferSize, 1);
% %                 1024 - 1
% [c2, ~] = partition(c, bufferSize, 2);
% %                 2047
