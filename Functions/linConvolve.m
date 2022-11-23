% =================================================================
% This function is an implementation of linear time-domain convolution
% The function performs zero padding of the input signal by default
function [y] = linConvolve(h, x)
if ~isvector(h) || ~isvector(x)
    error('Inputs must be vectors.')
end
hLen = length(h); xLen = length(x); % IR = xLen + hLen - 1
N = xLen+hLen-1; % Get the impulse response of the convolution
y = zeros(N,1); % Preallocate storage for the output
% Pad the end of the vector with zeros
% h = zeroPad(h, N-hLen); x = zeroPad(x, N-xLen);
% for every possible shift amount
for n=0:N-1
    for k=0:min(hLen-1,n)
        % Check if we are in bounds
        if ((n-k)+1 < xLen)
            % k is used as the sample index in this context as n is the
            % length of the convolution.
            y(n+1) = y(n+1) + h(k+1)*x((n-k)+1); % Linear Convolution
        end
    end
end
end