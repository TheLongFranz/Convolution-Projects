function y = newZ(x, fs, N)
k2pi = 2 * pi;
T = 1/fs;

%{
Begin Set Parameters
Fs = 1000;  % Sampling Rate (Hz)
T = 1/Fs;   % Sampling Period (s)
f = 5;      % Frequency of complex sinusoid
t = 0:T:1;  % Time Ramp
w = 2*pi*f; % Frequency (rad/s)
n = 150;    % Sample Delay to be applied using Z-operator

e^(jw(t-n)) = e^(jwt) * e^-jwnT
Euler's Eqn: e^(jwt) = cos(wt) + jsin(wt)
             e^(-jwn) = cos(wnT) - jsin(wnT)

Z = cos(wt) + jsin(wt) + cos(wnT) - jsin(wnT)

e = exp(1);

N is the number of subdivisions
k is the sample index, same as n
%}

y = zeros(length(x), 1);

for n = 0:length(x)-1
    w = (k2pi*n)/N;
    Z = cos(w*n) + 1i*sin();
%     y(n+1) = x(n+1) * e^-(1i*k2pi*(K(idx)/N)*n+1);
    y(n+1) = x(n+1) * cos(w*n+1) + x(n+1) * 1i*sin(w*n+1);
end