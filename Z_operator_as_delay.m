%
% Applying Z-operator to create 'n' sample delay
%

% Author: Steve Oxnard
% Date: Oct. 2020

clear; clc; close

% e^(jw(t-n)) = e^(jwt)*e^-jwnT
%
% Euler's Eqn: e^(jwt) = cos(wt) + jsin(wt)
%              e^(-jwn) = cos(wnT) - jsin(wnT)
%
% Multiplying complex numbers:
%
% (cos(wt) + jsin(wt))*(cos(wnT) - jsin(wnT) =
%
% [cos(wt)*cos(wnT) + jsin(wt)*cos(wnT) - jsin(wnT)*cos(wt) + sin(wt)*sin(wnT)]

% Begin Set Parameters
Fs = 1000;  % Sampling Rate (Hz)
T = 1/Fs;   % Sampling Period (s)
f = 5;      % Frequency of complex sinusoid
t = 0:T:1;  % Time Ramp
w = 2*pi*f; % Frequency (rad/s)
n = 150;    % Sample Delay to be applied using Z-operator

% Define the complex sinusoid
% s1 = cos(w*t) + 1i*sin(w*t);
s1 = cos(w*t) + 1i*sin(w*t);
% Plot Real and Imaginary components
figure(1)
% Subplot Real Component (cos(wt))
subplot(2,1,1)
plot(t,real(s1))
title('Real component of e^(jwt), w = 2*pi*f, f = 5 Hz')
xlabel('Time (s)')
ylabel('Amplitude')
% Subplot Imag Component (sin(wt))
subplot(2,1,2)
plot(t,imag(s1),'r')
title('Imaginary component of e^(jwt), w = 2*pi*f, f = 5 Hz')
xlabel('Time (s)')
ylabel('Amplitude')

% Calculate the multiplication of complex sinusoid and 'z = exp(-jwn)'
h1  = cos(w*t) * cos(w*n*T)    + cos(w*n*T) * 1i*sin(w*t)...
    - cos(w*t) * 1i*sin(w*n*T) + sin(w*t)   * sin(w*n*T);

% Plot out real component of original complex sinusoid and real component
% of delayed complex sinusoid
figure(2)
plot(real(s1))
hold on
plot(real(h1))

% End of File