function y = zeroPad(x, padLen)
if ~isvector(x)
    error('Input must be a vector.')
end
x = x(:);                % Convert input to vector
x(end+1:end+padLen) = 0; % Pad the end of the vector with zeros
y = x;
end