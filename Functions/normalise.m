function [y] = normalise(x, gaindBFS)
% Difference Equation
% y[n] = gain * (x[n]/max(x))
[N, C] = size(x)
y = zeros(N, C)
if C == 1
y = 10^(gaindBFS/20)*(x/max(abs(x))); % Normalise Gain
else
dataL = 10^(gaindBFS/20)*(x(:,1)/max(abs(x(:,1)))); % Normalise Gain
dataR = 10^(gaindBFS/20)*(x(:,2)/max(abs(x(:,2)))); % Normalise Gain
y = [dataL dataR]
end