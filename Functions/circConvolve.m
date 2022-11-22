function y = circConvolve(h, x)
y = ifft(fft(x) .* fft(h));   % Circular Convolution
end