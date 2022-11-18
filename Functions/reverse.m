function y = reverse(x)
tic

[N, C] = size(x);
y = zeros(N, C);

idx = N:-1:1;
reverseIdx = 1:1:N;

for c = 1:C
    y(reverseIdx, c) = x(idx, c);
end
reverseFunctionTimeElapsed = toc
end