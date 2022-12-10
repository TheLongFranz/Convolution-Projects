function y = Z(x,f, fs, k)
% Maths
% e = exp(1);
% j = sqrt(-1); % Matlab has a built in type for i & j called '1i'
k2pi = 2*pi;
% y = zeros(length(x));
N = length(x);
y = zeros(length(x), 1);

for n = 0:N-1
%     Z = e^-(1i*wk*n);
    Z = cos((k2pi*n)/fs) + 1i*cos((k2pi*n)/fs);
    y(n+1) = x(n+1) * Z;
end
end