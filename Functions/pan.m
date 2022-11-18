function [out] = pan(x, p, pType)

pTransform = (p/200) + 0.5;

if pType == 1
    lAmp = 1-pTransform;
    rAmp = pTransform;
elseif pType == 2
    lAmp = sqrt(1-pTransform);
    rAmp = sqrt(pTransform);
elseif pType == 3
    lAmp = sin(1-pTransform) * (0.5*pi);
    rAmp = sin(pTransform) * (0.5*pi);
end

yL = lAmp .* x(:, 1);
yR = rAmp .* x(:, 2);

out = [yL, yR];

end