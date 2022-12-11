clear;clc;close
addpath('Functions'); addpath('AudioSamples');

fs = 48000;     % Sample Rate
k2pi = 2*pi;

x = audioread('AudioSamples/Guitar.wav');
x = midSideEncode(x);
x = x(1:.125*length(x));

% x = sineWave(10000, -6, 1, 1, fs);

N = length(x);
dftlen = 2048;

y = zeros(length(x),1);

% TAKEN FROM FFT
%                    N
%      X(k) =       sum  x(n)*exp(-j*2*pi*(k-1)*(n-1)/N), 1 <= k <= N.
%                   n=1

% y = dft(x);

% for k = 0:N-1
%     for n = 0:N-1
%         y(k+1) = y(k+1) + x(n+1) * exp(-1i * k2pi * (k-1) * (n-1)/N);
%     end
% end

% Optimisations based on video
for k = 0:N-1
    for n = 0:dftlen-1
        y(k+1) = y(k+1) + x(n+1) * exp(-1i * k2pi * (k-1) * (n-1)/N);
    end
end

plot(linspace(0, fs, N), 20*log10(abs(fft(x))))
xlim([0 20000])
hold on
plot(linspace(0, fs, N), 20*log10(abs(y)))
xlim([0 20000])
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title('Discrete Fourier Transform Comparison')
legend(["MATLAB FFT Function" "My DFT Algorithm"])