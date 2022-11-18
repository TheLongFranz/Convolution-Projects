addpath('Functions'); addpath('AudioSamples'); clear;clc;close
% Speed Up convolve function
[h, fs] = audioread("AudioSamples/SilverVerb_IR.wav");
[N, C] = size(h);
x = impulse(C, 1, fs);

% Prepare Output
lenh = length(h)
lenx = length(x)
len = lenx + lenh - 1; % The impulse response of convolution
y = zeros(len, C); % Prea
%
% Original Convolve
% for c = 1:C   % Loop Through Channels
% for n=0:len-1 % Loop Through channel data
%     % for every k from 0 to n; except before complete overlap
%     % when we can stop at the length of h
%     for k=0:min(length(h)-1,n)
%         % check to see if h has shifted beyond the bounds of x
%         if ((n-k)+1 < length(x))
%             % ‘+1’ in every array argument since Matlab sequences start
%             % at index 1 (and not 0, like other programming languages)
%             y(n+1) = y(n+1) + h(k+1)*x((n-k)+1)
%         end
%     end
% end
% end

% Fast Convolve
% Interleaved processing
h = fft(h);
x = fft(x);
for c = 1:C   % Loop Through Channels
    for n = 0:len-1 % Loop Through channel data
        % for every k from 0 to n; except before complete overlap
        % when we can stop at the length of h
        for k = 0:min(lenh-1,n)
            % check to see if h has shifted beyond the bounds of x
            if ((n-k)+1 < lenx)
                % ‘+1’ in every array argument since Matlab sequences start
                % at index 1 (and not 0, like other programming languages)
                y(n+1, c) = ifft(y(n+1, c) + h(k+1, c)*x((n-k)+1, c));
            end
        end
    end
end