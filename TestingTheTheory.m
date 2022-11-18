clear;clc;close
% Add the dependencies to the project path relative to the project folder
addpath('Functions')
addpath('AudioSamples')

% Documentation
% Euler's Identity [e^j0 = cos(0) + jsin(0)]
% Euler's Identity is used to split complex numbers into their 'real' and
% 'imaginary' parts. 

% [x, fs] = audioread('AudioSamples/Guitar.wav');
% [xMid, xSide] = midSideEncode(x);
% [N, C] = size(xMid);

fs = 48000;
L = 1;
N = L*fs;
x = GenerateSine(500, -6, 2, L, fs);

% w = linspace(-pi, pi/4, pi);
% 
% e = 2.7182818284590452353602874713527;
% % Euler's number. exp(x) is equavelant to e^x
% j = sqrt(-1);
% % The imaginary number, also known as the phase rotation operator
% % multiplying a signal by j results in a 90º phase shift
% % Z = e.^(j*w)
% k = N/1024;  % numberOfBins

test = steveDFT(x, fs);
subplot(2, 1, 1)
semilogx(x)
% axis([0 2*pi -1 1])

% k = fs/N;

% for n = 1:N
% DFT(n) = xMid(n) * e^(-j*2*pi*k*n/N);
% % DFT(n) = xMid(n);
% end

% plot(linspace(0, fs, N), steveDFT(xMid, fs));
% hold on
% plot(linspace(0, fs, N), (DFT))
% legend(["Input Signal" "Output Signal"])