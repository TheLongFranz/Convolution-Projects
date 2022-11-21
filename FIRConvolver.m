classdef FIRConvolver < audioPlugin
    % Publicly Accessible Parameters
    properties
        outputGain = -6;    % Gain in dBFS
        mix = .5;           % wet/dry Mix ranging between 0->1
    end
    % Privately Stored Impulse Response
    properties (Access = private)
        h = audioread("AudioSamples/SilverVerb_IRMono.wav"); % Store the IR
        m_hIdx = 1;
        m_cIdx = 1;
    end
    % User Parameters
    properties (Constant)
        PluginInterface = audioPluginInterface(...
            'PluginName','FIR Convolver',...
            audioPluginParameter('outputGain','DisplayName','Output Gain',...
            'Mapping',{'lin',-82,12},'Style','rotaryknob','Label',' dB','Layout',[2,1]),...
            audioPluginParameter('mix','DisplayName','Wet/Dry Mix',...
            'Mapping',{'lin',0,1},'Style','rotaryknob','Layout',[4,1]),...
            audioPluginGridLayout(...
            'RowHeight',[20,120,20,120,20], ...
            'ColumnWidth',100));
    end
    % Where the DSP Lives
    methods
        % =================================================================
        % Gain Normalise
        function y = normalise(plugin, x, gaindBFS)
            % Difference Equation
            % y[n] = gaindBFS * (x[n]/max(x))
            [~, C] = size(x);
            if C == 1
                y = 10^(gaindBFS/20)*(x/max(abs(x))); % Normalise Gain
            else
                dataL = 10^(gaindBFS/20) * (x(:,1)/max(abs(x(:,1)))); % Normalise Gain
                dataR = 10^(gaindBFS/20) * (x(:,2)/max(abs(x(:,2)))); % Normalise Gain
                y = [dataL dataR];
            end
        end
        % =================================================================
        % Mid Side Encode Function
        function [yMid, ySide] = midSideEncode(plugin, x)
            [~, C] = size(x);
            if C == 1
                yMid = x;
                fprintf('Input Signal is already mono.\n')
            else
                % Mid == 1; Side == 2
                yMid  = 0.5 * x(:, 1) + x(:, 2);
                ySide = 0.5 * x(:, 1) - x(:, 2);
            end
        end
        % =================================================================
        % FIRConvolve function
        function [y] = convolve(plugin, h, x)
            if ~isvector(h) || ~isvector(x)
                error('Inputs must be vectors.')
            end
            hLen = length(h); xLen = length(x); % IR = xLen + hLen - 1
            N = xLen+hLen-1; % Get the impulse response of the convolution
            y = zeros(N,1); % Preallocate storage for the output
            % Pad the end of the vector with zeros
            h = plugin.zeroPad(h, N-hLen); x = plugin.zeroPad(x, N-xLen);
            % for every possible shift amount
            for n=0:N-1
                for k=0:min(hLen-1,n)
                    % Check if we are in bounds
                    if ((n-k)+1 < xLen)
                        % k is used as the sample index in this context as n is the
                        % length of the convolution.
                        % This index is counting through
                        y(n+1) = y(n+1) + h(k+1)*x((n-k)+1); % Linear Convolution
                    end
                end
            end
        end
        % =================================================================
        function [y] = fftconvolve(plugin, h, x)
            if ~isvector(h) || ~isvector(x)
                error('Inputs must be vectors.\n')
            end
            hLen = length(h); xLen = length(x); % IR = xLen + hLen - 1
            N = hLen+xLen-1; % Get the impulse response of the convolution
            y = zeros(N,1); % Preallocate storage for the output
            % Pad the end of the vector with zeros
            h = plugin.zeroPad(h, N-hLen); x = plugin.zeroPad(x, N-xLen);
            % Process the output
            y = ifft(fft(x, N) .* fft(h, N)); % Circular Convolution
        end
        % =================================================================
        % Partition is a function that returns a chunk of data based on input(x),
        % partitionSize(1024), partitionIdx(1). This function outputs a maximum
        % index that can be used later.
        function [y, maxIdx] = partition(plugin, x, bufferSize, idx)
            xLen = length(x);
            k = 0:(round(xLen/bufferSize))-1; k = k'; % Index used internally
            maxIdx = max(k)+1;
            % Calculate the difference between the input and buffer size
            sampleOverlap = mod(xLen, bufferSize);
            % If the buffer is too large then make the last
            if sampleOverlap ~= 0 && idx == maxIdx
                y = x((bufferSize+1*k(idx)):sampleOverlap*(k(idx)+1)+1);
            else
                y = x((bufferSize*k(idx))+1:bufferSize*(k(idx)+1));
            end
        end
        % =================================================================
        % This function is used in in convolve and fftconvole to 0 pad the
        % edges of the signal.
        function y = zeroPad(plugin, x, padLen)
            x = x(:);                % Convert input to vector
            x(end+1:end+padLen) = 0; % Pad the end of the vector with zeros
            y = x;
        end
        % =================================================================
        % This function increments a value up to a specified range and
        % resets if it goes out of bounds
        function y = increment(plugin, x, xMax)
            fprintf(['m_hIdx = ' num2str(x) '\n']);
            y = x + 1;
            if y == xMax
                fprintf(['m_hIdx = ' num2str(y) '\n']);
                y = 1;
            end
        end
        % =================================================================
        function out = process(plugin, in)
            %             % Set buffer length
            %             bufferSize = length(in);
            %             % Prepare Impulse response
            %             h = plugin.normalise(plugin.h, -6); % Normalise IR Gain
            %             %--------------------------------------------------------------
            %             % Partition the IR.wav, iterate through on a frame by frame
            %             % basis, increasing the buffer index with each frame and
            %             % reseting it if it goes out of bounds.
            %             [~, hMaxIdx] = partition(h, bufferSize, plugin.m_hIdx);
            %             fprintf(['Max index for h = ' num2str(hMaxIdx) '\n'])
            %             % Increment the buffer
            %             %             plugin.m_hIdx = plugin.m_hIdx + 1
            %             %             %             Check if we're out of bounds
            %             %             if plugin.m_hIdx == hMaxIdx-1
            %             %                 plugin.m_hIdx = 1;
            %             %             end
            %             fprintf(num2str(plugin.m_hIdx));
            %             %             % Convert Input to Mono
            %             [in, ~] = plugin.midSideEncode(in);
            % %             Perform convolution
            %                 [hPartition, ~] = partition(h, bufferSize, plugin.hIdx);
            %                 c = plugin.fftconvolve(hPartition, in);
            %                 c = partition(c, bufferSize, 1);
            %             %             c = plugin.fftconvolve(hPartition, in);
            %
            %             % Partition the convolution, this will be 1024 + 1024 - 1 in
            %             % length and will therefore not fit into a frame. We will need
            %             % to add the residual to the next frame along.
            %             %             [c1, ~] = partition(c, bufferSize, 1);
            %             %             [c2, ~] = partition(c, bufferSize, 2);
            %             % Increment the buffer
            %             %             plugin.m_cIdx = plugin.m_cIdx + 1
            %             %             % Check if we're out of bounds
            %             %             if plugin.m_cIdx == cMaxIdx
            %             %                 plugin.m_cIdx = 1;
            %             %             end
            %             %             fprintf(num2str(plugin.m_cIdx));
            %             % Create a wet/dry mix for the output
            %             %             y = (1-plugin.mix) * in + plugin.mix * c1 + pad(c2, 1);
            %             %             % Apply overall gain to the output
            %             %             y = 10^(plugin.outputGain/20) * y;
            %             %             out = [y y];
            %             out = [in in];

            % Set buffer length
            bufferSize = length(in);

            % Convert input to mono
            in = plugin.midSideEncode(in);

            % Prepare the impulse response
            h = plugin.normalise(plugin.h, -1);               % Normalise the gain of the IR
            [hPartition, hMaxIdx] = plugin.partition(h, bufferSize, plugin.m_hIdx); % Break IR into chunk of N
            % Increment the partition buffer in order to loop through the IR file
            plugin.m_hIdx = plugin.increment(plugin.m_hIdx, hMaxIdx);

            c = plugin.fftconvolve(hPartition, in);
            [cPartition, cMaxIdx] = plugin.partition(c, bufferSize, 1); % Break IR into chunk of N

            y = in + c;

            out = [y y];

        end
        % =================================================================
        function reset(plugin)
            plugin.m_hIdx = 1;
            plugin.m_cIdx = 1;
        end
    end
end