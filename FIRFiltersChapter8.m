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
Convolution can be defined as a Finite Impulse Response Filter with an impulse response of the length of the first function x[N] + the length of the second function h[N] -1.

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
close; plot(h); hold on; plot(x); plot(yLin); %plot(yCirc); hold off; 
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
%{
Magnitude:  How much of a frequency is allowed to pass.
Phase:      How long a frequency takes to pass.

The phase of a system signifies how many cycles are required for a given
frequency to pass through the system. 
Looking at the derivatives of a system we get the 'phase distortion', also
called 'group delay'. The group delay can be measured continuously or
discretly and shows the transmission time at various frequenies. The group
delay is the negative derivative of the phase. Phase is measured in
radians, frequency is measured in radians/second, applying the derivative
leaves seconds.
Hd
Tg = -(d*rad/d*rad/sec)

A variation in the delay at certain frequencies causes phase distortion,
this is noticable in the midrange at 1ms but is more noticable in the bass
between 2-3ms.

8.5.1 Linear phase ========================================================
Linear phase occurs when the group delay across all frequencies is the
same, resulting in a flat phase response. Only FIR filters can produce
linear phase responses, and only when the coefficients are symmetrical i.e.
                    h[n]=h[N −n−1],n=0,1,..., N −1

The phase distortion of a linear phase filter is a constant value called
its 'Latency', written as...
                    td = (N-1/2*fs)
The number of taps in a Linear Phase FIR Filter should always be a maximum
of 2x the buffer length.

As common sense would suggest, the longer the filter, the higher the
latency. Linear Phase filters introduce an artifact known as pre-echo,
where ringing occurs around the centre of the filter, due to the
symmetrical coefficients.

The pre-echo is the biggest downside of linear phase filters, since the
pre-echo becomes more noticable with steeper filters. The way to counteract
this is to use a higher order filter, but this requires more taps which
results in more latency.

8.5.2 Minimum phase =======================================================
Minimum Phase Filters sacrifice higher amounts of phase distortion for a
lack of pre-echo and latency. They have the shallowest phase slope of any
FIR filter, therefore having the least group delay. They are also
garuanteed to be stable.
%}
% =========================================================================
% IGNORE THESE SECTIONS
% =========================================================================
% -------------------------------------------------------------------------
% 8.6 Designing FIR filters
% -------------------------------------------------------------------------
% 8.7 Challenges
% -------------------------------------------------------------------------
% 8.8 Project – FIR filters
% Summary