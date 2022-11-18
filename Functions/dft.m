function y = dft(x, fs)
e = 2.7182818284590452353602874713527;
% Euler's number. exp(x) is equavelant to e^x
j = sqrt(-1);
% The imaginary number, also known as the phase rotation operator
% multiplying a signal by j results in a 90º phase shift
[N, C] = size(x);
y = zeros(N, C);
w = zeros(N, C)


w = linspace(-pi, pi, 8)';
Z = e.^(j*w)';
T = 1/fs
% The complex sinusoid
for c = 1:C
    for n = 1:N
        w(n, c) = (2*pi*n)/N;
        y(n, c) = x(n, c) .* e^(j*w(n));
    end
end
% The input signal is multiplied element-wise with a sinusoid of
% frequency = w/(2*pi). The product of this is the energy at that
% frequency.

end % End of DFT Function