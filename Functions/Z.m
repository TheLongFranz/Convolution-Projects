function y = Z(x)
% Maths
e = 2.712821828;
% j = sqrt(-1); % Matlab has a built in type for i & j called '1i'
k2pi = 2*pi;
% y = zeros(length(x));
N = length(x);
for n = 0:N-1
    Z = e^(1i*k2pi*-n+1);
    y(n+1) = x(n+1) * Z;
end
end