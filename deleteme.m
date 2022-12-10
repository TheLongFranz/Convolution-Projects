clear;clc;close
addpath('Functions'); addpath('AudioSamples');

fs = 48000;     % Sample Rate
% nyquist = fs/2; % Nyquist
%
% w = [0 -pi/4 -pi/2 -pi pi pi/2 pi/4 0];
% % Z1 = cos(w) + 1i*sin(w);
% Z = exp(1i*w);
%
% plot(Z)
% xline(0, '-', 're'); yline(0, '-','im');

k2pi = 2*pi;

% x = [0 .25 .5 .75 1 1.25];
% x = audioread('AudioSamples/Guitar.wav');
x = sineWave(10000, -6, 1, .1, fs);
% w = linspace(-pi, pi, length(x));
% wk = (k2pi*n)/N; % n is the sample index and N is the number of subdivisions

% for n = 0:999
% vector(n+1) = exp(-1i*k2pi*n+1/1024);
% end
% x = midSideEncode(x);
N = length(x);

dftlen = 1024;

y = zeros(length(x),1);
re = zeros(length(x),1);
im = zeros(length(x),1);

[~, Bins] = partition(x, dftlen, 1);

% TAKEN FROM FFT
%                    N
%      X(k) =       sum  x(n)*exp(-j*2*pi*(k-1)*(n-1)/N), 1 <= k <= N.
%                   n=1

for k = 0:N-1
    for n = 0:N-1
        y(k+1) = y(k+1) + x(n+1) * exp(-1i * k2pi * (k-1) * (n-1)/N);
    end
end

% for BIN = 1:dftlen
%     for n = 1:dftlen
%         y(BIN)  = y(BIN)  + x(n) * exp(-1i*k2pi*BIN*n/dftlen)/dftlen;
% 
%         re(BIN) = re(BIN) + x(n) * cos(k2pi*BIN*n/dftlen)/dftlen;
%         im(BIN) = im(BIN) - x(n) * sin(k2pi*BIN*n/dftlen)/dftlen;
% 
%         %re[BIN] = re[BIN] + x[n] * cos (kTwoPi * BIN * n/DFTLEN)/DFTLEN;
%         %im[BIN] = im[BIN] - x[n] * sin (kTwoPi * BIN * n/DFTLEN)/DFTLEN;
%     end
% end

subplot(4, 1, 1)
plot(linspace(0, fs, N), 20*log10(abs(fft(x))))
xlim([0 20000])
subplot(4, 1, 2)
plot(linspace(0, fs, N), y)
xlim([0 20000])
subplot(4, 1, 3)
plot(linspace(0, fs, N), re)
xlim([0 20000])
subplot(4, 1, 4)
plot(linspace(0, fs, N), im)
xlim([0 20000])