function y = delay(x, delay, feedback, gaindBFS, fs)

        [N, C] = size(x);
        y = zeros(N, C);
        
        delayLine = zeros(round(3*delay*fs), C);
        idx = 1;

        for c = 1:C
            for n = 1:N

                y(n, c) = x(n, c) + 10^(gaindBFS/20)*delayLine(idx);

                temp = x(n, c) + feedback*delayLine(idx);
                delayLine(idx) = temp;

                idx = idx + 1;
                if idx > delay*fs
                    idx = 1;
                end

            end
        end

    end