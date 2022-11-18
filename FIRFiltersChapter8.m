%% Add dependencies and reset the environment
% addpath('Functions'); addpath('AudioSamples');
clear;clc;close
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
% ================================================================
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
The impulse response for convolution is x[N] + h[N] - 1. That is the length
of a convolution between two signals

Convolution has the following properties
1. Commutative -  h[n] * x[n] = x[n] * h[n]
2. Associative -  (x[n] * h[n]) * g[n] = x[n] * (h[n] * g[n])
3. Linear      -  x[n]* (a⋅h[n]+b⋅g[n]) = a⋅(x[n] * h[n])+b⋅(x[n] * g[n])
%}
% -------------------------------------------------------------------------
%% 8.4 Cross-correlation
% -------------------------------------------------------------------------
%% 8.5 FIR filter phase
% -------------------------------------------------------------------------
%% 8.6 Designing FIR filters
% -------------------------------------------------------------------------
%% 8.7 Challenges
% -------------------------------------------------------------------------
%% 8.8 Project – FIR filters

%% Summary
h3 = audioread("AudioSamples/SilverVerb_IR.wav");
x3 = impulse(1, 1, 48000);
convHX = convolve(h3, x3)
%% Functions
function [y] = FIRFilter(x, k, a)
% Convert the input signal to a row vector
x = [x, 0]; % Zero pad 'x' to allow for the size increase due to the filter order
% in c++ x.push_back(0)
idx = 1; idx1 = 1; % Reset before each loop
% fprintf('\nOutput\n');
for n = 1:length(x)
    %     fprintf(['Loop ' num2str(n) ': ']);
    if n == 1
        y(n) = x(n);
        %         fprintf(['y(' num2str(n) ') = ' num2str(x(n)) '\n']);
    else
        y(n) = x(n) + a*x(idx);
        %         fprintf(['y(' num2str(n) ') = ' num2str(x(n)) '+' num2str(a) '*' num2str(x(idx)) ' = ' num2str(y(n)) '\n']);
    end
    idx = idx1;
    idx1 = n+1;
end
end
function [y] = convolve(h, x)
% Prepare Output
len = length(x)+length(h)-1;
y=zeros(len,1);
for n=0:len-1
    % for every k from 0 to n; except before complete overlap
    % when we can stop at the length of h
    for k=0:min(length(h)-1,n)
        % check to see if h has shifted beyond the bounds of x
        if ((n-k)+1 < length(x))
            % ‘+1’ in every array argument since Matlab sequences start
            % at index 1 (and not 0, like other programming languages)
            y(n+1) = y(n+1) + h(k+1)*x((n-k)+1);
        end
    end
end
end