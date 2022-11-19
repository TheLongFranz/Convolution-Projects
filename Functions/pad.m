function y = pad(x, padLen)
x = x(:)                 % Convert input to vector
x(end+1:end+padLen) = 0; % Pad the end of the vector with zeros
y = x;
end