function y = dct(x, dftlen)
[N, C] = size(x);
y = zeros(N, C);
%{
for BIN = 1:dftlen
    for n = 1:dftlen
        y(BIN)  = y(BIN)  + x(n) * exp(-1i*k2pi*BIN*n/dftlen) / dftlen;
        re(BIN) = re(BIN) + x(n) * cos(k2pi*BIN*n/dftlen)     / dftlen;
        im(BIN) = im(BIN) - x(n) * sin(k2pi*BIN*n/dftlen)     / dftlen;
    end
end
              N
X(k) =       sum  x(n)*exp(-j*2*pi*(k-1)*(n-1)/N), 1 <= k <= N.
             n=1
We can use the complex notation or break the complex signal into its real
and imaginary components using Euler's equation.
Eulers Equation: e^(-j*w*n) = cos(w*n) + j*sin(w*n)
%}

for k = 0:N-1
    for n = 0:dftlen-1
        y(k+1) = y(k+1) + x(n+1) * cos(2*pi * k * n/N);
    end
end

end % End of DFT Function