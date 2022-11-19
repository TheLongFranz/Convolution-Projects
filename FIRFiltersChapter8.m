%% Add dependencies and reset the environment
addpath('Functions'); addpath('AudioSamples'); clear;clc;close
% -------------------------------------------------------------------------
% Notes for Digital Audio Theory - A Practical Guide Chapter 8: FIR Filters
% -------------------------------------------------------------------------
%% 8.1 FIR filters by way of example
%{
A Finite Impulse Response Filter is a feed-forward structure with an 
impulse response that is a finite length. As this structure is feed-
forward there is no delayed version of the output in the difference 
equation used to create feedback, only delayed versions of the input. 
The FIR Filter will have an impulse response whose length in samples 
corresponds to the highest number of taps, this is also called the order.
%}
%           An example FIR filter with the difference equation...
% -------------------------------------------------------------------------
%                          (y[n]=x[n]+ a1x[n − k])
% -------------------------------------------------------------------------
x1 = [.1 .4 .5 .2]; y1 = FIRFilter(x1, 1, .5); % Input->Output
% Expected results [.1 0.45 0.7 0.45 0.1]
% -------------------------------------------------------------------------
%{
"More generally, the output of an FIR filter has a sequence length that
is equal to the length of the input plus the order of the filter."
%}
% -------------------------------------------------------------------------
x2 = [.5 -.4 .3 -.2 .1]; y2 = FIRFilter(x2, 1, .5); % Input->Output
% Expected results [.5 -.15 .1 -.05 .0 .05]
% Analysis
% =========================================================================
subplot(1, 2, 1); FIRPlot(x1, y1); subplot(1, 2, 2); FIRPlot(x2, y2);
% -------------------------------------------------------------------------
%% 8.2 Impulse response
%{
The impulse response of a filter has a finite length of N+1.
Where N is the order of the filter (in the case of our filters the order is 1),
and 1 is the length of x[n]. The impulse response for the first order low 
pass filter from section 8.1 can be calculated as

                 y[0] = x[0] + 0.5*x[0-1] = 1.0 + 0.5*0.0 = 1.0

The impulse response matches the gains of each filter tap, the gains
coressponding to each filter tap is called the filters 'coefficients'.

"FIR filter coefficients are equal to the filter’s IR,
 when each tap corresponds to a unique delay element, z−k."
Coefficients are labeled with increasing subscripts a0,a1,a2...aN.
Assuming a gain of 1, h may be written as
                h[n] = [1.0, 0.5] = [a0, a1]
%}
% -------------------------------------------------------------------------
%% 8.3 Convolution
%{
Convolution can be defined as a Finite Impulse Response Filter with an
impulse response of the length of the first function x[N] + the length of the
second function h[N] -1.

Convolution has the following properties
1. Commutative -  h[n] * x[n] = x[n] * h[n]
2. Associative -  (x[n] * h[n]) * g[n] = x[n] * (h[n] * g[n])
3. Linear      -  x[n]* (a⋅h[n]+b⋅g[n]) = a⋅(x[n] * h[n])+b⋅(x[n] * g[n])

We will demonstrate using filter with the following impulse response 
(Remembering that the impulse response is determined by the coefficients)
h[n] = [a0, a1, a2, a3] on an arbitrary signal x. The convolution matrix
(Generally the IR Signal) can also be called the kernel.
For a full convolution we must zero pad the end of the vectors to match the
length to the impulse response of h[N] + x[N] - 1.
%}
h = 1:4; % h
x = 5:8; % x
N = length(h) + length(x) -1;
yLin = convolve(h, x);  % Linear convolution of x and h
% By using an N point FFT we can force the circular convolution to be
% identical to the linear convolution.
yCirc = ifft(fft(x, N) .* fft(h, N));   % Circular convolution of x and h with an N length FFT
%{
y[0] = h[0]⋅x[0] = (1 * 5) = 5
y[1] = h[0]⋅x[1] + h[1]⋅x[0] = (1 * 6 + 2 * 5) = 16
y[2] = h[0]⋅x[2] + h[1]⋅x[1] + h[2]⋅x[0] = (1 * 7 + 2 * 6 + 3 * 5) = 34
y[3] = h[0]⋅x[3] + h[1]⋅x[2] + h[2]⋅x[1] + h[3]⋅x[0] = (1 * 8 + 2 * 7 + 3 * 6 + 4 * 5) = 60
...etc
%}
% Analysis
% =========================================================================
close; plot(h); hold on; plot(x); plot(yLin); plot(yCirc); hold off; 
legend(["h[n]" "x[n]" "cLin[n]" "cCirc[n]"]);
title(["Convolution of two arbitrary signals " num2str(h) " and " num2str(x)])
xlabel('Time'); ylabel('Magnitude');
% -------------------------------------------------------------------------
%% 8.4 Cross-correlation
%{
Cross-Corellation is related to convolution but with one main difference,
'h' is not time-reversed. This results in a comparison between h & x where
the output measurements are (1) similarity between the time-lagged signals
& (2) the point at which peak similarity occurs. Polarity of the two signals 
does not change the magnitude of the output, only the sign of it. 

8.4.1 Programming Example: Time-Delay Estimation ==========================
This section is a quick overview for the uses of Cross corellation, such as
time delay estimation and matched filtering (transient detection).
%}
% -------------------------------------------------------------------------
%% 8.5 FIR filter phase

% -------------------------------------------------------------------------
%% 8.6 Designing FIR filters
% -------------------------------------------------------------------------
%% 8.7 Challenges
% -------------------------------------------------------------------------
%% 8.8 Project – FIR filters

%% Summary