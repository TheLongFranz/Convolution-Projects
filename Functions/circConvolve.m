% =================================================================
% The circConvolve function is an implementation of circular
% convolution, this will only function if both inputs are the same
% length.
function y = circConvolve(h, x)
if ~isvector(h) || ~isvector(x)
    error('Inputs must be vectors.\n')
else
    if length(h) ~= length(x)
        error('Inputs must be the same size.\n')
    end
end
% Process the output
y = ifft(fft(x) .* fft(h));   % Circular Convolution
end