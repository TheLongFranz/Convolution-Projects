function y = circToLinConvolve(h, x)
N = length(x)+length(h)-1;        % Get the impulse response of the convolution
y = zeros(N,1);                   % Preallocate storage for the output
h = zeroPad(h, N-length(h));          % Pad the end of the vector with zeros
x = zeroPad(x, N-length(x));          % Pad the end of the vector with zeros
y = ifft(fft(x, N) .* fft(h, N));   % Circular Convolution
end