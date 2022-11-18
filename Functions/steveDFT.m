function y = steveDFT(x, fs)
[N, C] = size(x);
freqSweep = linspace(20, 20000, N);
T = 1/fs;
for c = 1:C
    for n = 1:N
        y(n, c) = x(n, c) * sin(2*pi*n*freqSweep(n)*n*T);
    end
end