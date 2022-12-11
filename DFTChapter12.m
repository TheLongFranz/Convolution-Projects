%% Add dependencies and reset the environment
addpath('Functions'); addpath('AudioSamples'); clear;clc;close
% -------------------------------------------------------------------------
% Notes for Digital Audio Theory - A Practical Guide Chapter 12: Discrete Fourier transform
% -------------------------------------------------------------------------
%% 12.1 Discretizing a transfer function
%{
The discrete fourier transform is the fourier transform
performed discretely in samples rather than continuously. (No shit Sherlock) 



%}
% -------------------------------------------------------------------------
%% 12.2 Sampling the frequency response
% -------------------------------------------------------------------------
%% 12.3 The DFT and inverse discrete Fourier transform
fs = 48000; x = sineWave(10000, -6, 1, .01, fs); y = dft(x, 64); plot(linspace(0, fs, length(x)), 20*log10(abs(y)));
% -------------------------------------------------------------------------
%% 12.4 Twiddle factor
% -------------------------------------------------------------------------
%% 12.5 Properties of the DFT 
% -------------------------------------------------------------------------
%% 12.6 Revisiting sampling in the frequency domain 
% -------------------------------------------------------------------------
%% 12.7 Frequency interpolation 12.8 Challenges
% -------------------------------------------------------------------------
%% 12.9 Project – spectral filtering
% -------------------------------------------------------------------------