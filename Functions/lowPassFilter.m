   function y = lowPassFilter(x, frequency, q, fs)

        % Filter Parameters
        d = 1/q;

        lpfTheta = (2*pi*frequency)/fs;
        lpfBeta = 0.5 * (1-(d/2)*sin(lpfTheta)) / (1+(d/2)*sin(lpfTheta));
        lpfGamma = (0.5+lpfBeta)*cos(lpfTheta);

        lA0 = (0.5+lpfBeta-lpfGamma) / 2.0;
        lA1 = (0.5+lpfBeta-lpfGamma);
        lA2 = (0.5+lpfBeta-lpfGamma) / 2.0;

        lB1 = -2*lpfGamma;
        lB2 = 2*lpfBeta;

        lXz1 = 0;
        lXz2 = 0;
        lBz1 = 0;
        lBz2 = 0;

        [N, C] = size(x);
        y = zeros(N, C);

        for c = 1:C
            for n = 1:N
                % Calculate the Filter Sum
                lpfs = lA0*x(n, c) + lA1*lXz1 + lA2*lXz2 - lB1*lBz1 - lB2*lBz2;

                % Write samples to the output buffer
                y(n, c) = lpfs;

                % Update High Pass Filter Coefficients
                lXz2 = lXz1;
                lXz1 = x(n, c);
                lBz2 = lBz1;
                lBz1 = lpfs;
            end
        end

    end