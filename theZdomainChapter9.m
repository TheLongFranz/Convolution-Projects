%% Add dependencies and reset the environment
addpath('Functions'); addpath('AudioSamples'); clear;clc;close
% -------------------------------------------------------------------------
% Notes for Digital Audio Theory - A Practical Guide Chapter 9: Z-Domain
% -------------------------------------------------------------------------
%{
The text below is referred to as a difference equation and is used to
define a block diagram in a way that can be implemented in software
       DIFFERENCE EQUATION(y[n]=a0x[n]+a1x[n−1]+a2x[n−2]+...)

TANGENT
Read up on Laplace Transforms and the complex variable 's'.
%}
% -------------------------------------------------------------------------
%% 9.1 Frequency response
%{
The shape of a filter, high-pass, low-pass etc. can be defined as it's
frequency response. How that shape corresponds to level changes across
the frequency spectrum is called the 'Magnitude Response'. The same can
be stated for the 'Phase Response' of a filter as this is the delay that
occurs at each frequency. Because the Frequency Response is complex it
can be subdivided into it's phase and magnitude responses and vice versa.

    Magnitude:  How much of a frequency is allowed to pass.
    Phase:      How long a frequency takes to pass.
    Summary:    Phase + Magnitude = Frequency response.

In order to analyse a filter we need its frequency response, once obtained
we can decompose the frequency response into its component parts using the
following methods.

    Magnitude = abs(f);
    Phase     = angle(f); % via the arc-tangent.

Note:
Generally speaking lower case letters are used to represent sample indexes.
I.e. H(f) is the frequency response of H while h(n) is h at sample n.
%}
% -------------------------------------------------------------------------
%% 9.2 Magnitude response
%{
The magnitude response of a complex phasor is derived from the 
                sqrt(x[im]^2 + x[re]^2);

This also applies when extracting magnitude from the frequency response.
%}
% -------------------------------------------------------------------------
%% 9.3 Comb filters
%{
You know what a comb filter is.
%}
% -------------------------------------------------------------------------
%% 9.4 z-Transform
%{
Z may be used as both a delay operator and a complex variable.

Delaying a signal by k samples is equivelant to multiplying the signal by
Z-k. 

Z is defined in digital systems as...
              Z = A * e^(j*w*Ts) = A * e^((j*2*pi*f)/fs)

Z represents the entire complex plane, often called the Z-Plane because of
this. The Z transform is another way of analysing signals or transfer
functions.

The definition of the Z-Transform is for a digital sequence...
                x(z) = x(n) * z(-n)

This means that x(n)[0.1, 0.2, 0.3, 0.4] is multiplied by z delayed by n 
samples, this is written as...
                X(z)=x(1)*z−0 +x(2)*z−1 +x(3)*z−2 +(x4)*z−3

This means that x(1) is delayed by 0 samples,
                x(2) is delayed by 1 sample,
                x(3) is delayed by 2 samples,
                x(4) is delayed by 3 samples,
                etc...

If we wanted to delay x by 4 samples we would substiite n for 4, where the
difference equation is y = z^-4*X(z). This yields the output sequence...
[0.0, 0.0, 0.0, 0.0, 0.1, 0.2, 0.3, 0.4]
X is capitalised to show that it is being represented in the frequency
domain.

The Z-Transform gives us the transfer function of a system, this is similar
to the frequency response in that it represents the effect a filter will
have on an input. This is described as a ratio of the output over the input.

                                H = y/x;

%}
% x = [.1 .2 .3 .4];
close
clc
fs = 48000;
x = sineWave(1000, -6, 1, .01, fs);

X = Z(x, fs, 8)


% -------------------------------------------------------------------------
%% 9.5 Pole/zero plots
% -------------------------------------------------------------------------
%% 9.6 Filter phase response 9.7 Group delay
% -------------------------------------------------------------------------
%% 9.7 Group Delay
% -------------------------------------------------------------------------
%% 9.8 Challenges