function y = reverse(x)
[N, C] = size(x);       % Get the size of the input
y = zeros(N, C);        % Preallocate storage for the output
reverseIdx = N:-1:1;    % Index counting from max->0
idx = 1:1:N;            % Index counting from 0->max
    for c = 1:C
        y(idx, c) = x(reverseIdx, c);
    end
end