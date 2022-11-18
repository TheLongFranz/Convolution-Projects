   function y = LPFDelay(x, decay, g, amplitude, LPFfrequency, q, fs)

        % Filter Parameters
        d = 1/q;

        lpfTheta = (2*pi*LPFfrequency)/fs;
        lpfBeta = 0.5 * (1-(d/2)*sin(lpfTheta)) / (1+(d/2)*sin(lpfTheta));
        lpfGamma = (0.5+lpfBeta)*cos(lpfTheta);

        lA0 = (0.5+lpfBeta-lpfGamma) / 2.0;
        lA1 = (0.5+lpfBeta-lpfGamma);
        lA2 = (0.5+lpfBeta-lpfGamma) / 2.0;

        lB1 = -2*lpfGamma;
        lB2 = 2*lpfBeta;

        lXz1 = 0;   % Filter memory z=0
        lXz2 = 0;   % Filter memory z=-1
        lBz1 = 0;   % Filter memory z=0
        lBz2 = 0;   % Filter memory z=-1

        [N, C] = size(x);   % Array with dimensions() = input
        y = zeros(N, C);    % Output Buffer

        % DelayLine length set using equation 17.8 from the reverb chapter from
        % Designing Audio Effects with C++
        delayLine = zeros(round((3*decay*fs)/log(1/g)), C);
        idx = 1;

        for c = 1:C
            for n = 1:N
                % Calculate the Filter Sum
                lpfs = lA0*x(n, c) + lA1*lXz1 + lA2*lXz2 - lB1*lBz1 - lB2*lBz2;

                % Write samples to the output buffer
                y(n, c) = x(n, c) + amplitude*delayLine(idx);

                temp = lpfs + g*delayLine(idx);
                delayLine(idx) = temp;

                % Increment the index for the delay line
                idx = idx + 1;
                if idx > decay*fs
                    idx = 1;
                end

                % Update High Pass Filter Coefficients
                lXz2 = lXz1;
                lXz1 = x(n, c);
                lBz2 = lBz1;
                lBz1 = lpfs;
            end
        end

    end