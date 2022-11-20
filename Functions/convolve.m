function [y] = convolve(h, x)
if ~isvector(h) || ~isvector(x)
    error('Inputs must be vectors.')
end
xLen = length(x); hLen = length(h);
len = xLen + hLen-1;    % Get the impulse response of the convolution
y = zeros(len,1);       % Preallocate storage for the output
h = pad(h, len-hLen);   % Pad the end of the vector with zeros
x = pad(x, len-xLen);   % Pad the end of the vector with zeros
% for every possible shift amount
for n=0:len-1
    for k=0:min(hLen-1,n)
        % Check if we are in bounds
        if ((n-k)+1 < xLen)
            % k is used as the sample index in this context as n is the
            % length of the convolution.
            % This index is counting through 
            y(n+1) = y(n+1) + h(k+1) * x((n-k)+1);
        end
    end
end
end