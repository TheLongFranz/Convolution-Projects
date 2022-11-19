classdef FIRConvolver < audioPlugin
    % Publicly Accessible Parameters
    properties
        outputGain = -6;    % Gain in dBFS
        mix = .5;           % wet/dry Mix ranging between 0->1
    end
    % Privately Stored Impulse Response
    properties (Access = private)
        %         h = audioread("AudioSamples/SilverVerb_IR.wav");    % Store the IR
        h = audioread("AudioSamples/SilverVerb_IR.wav");    % Store the IR
        bufferSize = 1024;
        hIdx = 0;
        cIdx = 0;
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
            % y[n] = gain * (x[n]/max(x))
            [~, C] = size(x);
            if C == 1
                y = 10^(gaindBFS/20)*(x/max(abs(x))); % Normalise Gain
            else
                dataL = 10^(gaindBFS/20)*(x(:,1)/max(abs(x(:,1)))); % Normalise Gain
                dataR = 10^(gaindBFS/20)*(x(:,2)/max(abs(x(:,2)))); % Normalise Gain
                y = [dataL dataR];
            end
        end
        % =================================================================
        % Mid Side Encode Function
        function [yMid, ySide] = midSideEncode(plugin, x)
            % Mid == 1; Side == 2
            left  = x(:, 1);
            right = x(:, 2);
            yMid  = 0.5 * left + right;
            ySide = 0.5 * left - right;
        end
        % =================================================================
        % FIRConvolve function
        function [y] = convolve(plugin, h, x)
            if ~isvector(h) || ~isvector(x)
                error('Inputs must be vectors.')
            end
            len = length(x)+length(h)-1;    % Get the impulse response of the convolution
            y = zeros(len,1);               % Preallocate storage for the output
            h = pad(h, len-length(h));      % Pad the end of the vector with zeros
            x = pad(x, len-length(x));      % Pad the end of the vector with zeros
            % for every possible shift amount
            for n=0:len-1
                for k=0:min(length(h)-1,n)
                    % Check if we are in bounds
                    if ((n-k)+1 < length(x))
                        % k is used as the sample index in this context as n is the
                        % length of the convolution.
                        % This index is counting through
                        y(n+1) = y(n+1) + h(k+1)*x((n-k)+1);
                    end
                end
            end
        end
        % =================================================================
        function [y] = fftconvolve(plugin, h, x)
            if ~isvector(h) || ~isvector(x)
                error('Inputs must be vectors.')
            end
            N = length(x)+length(h)-1;        % Get the impulse response of the convolution
            y = zeros(N,1);                   % Preallocate storage for the output
            h = pad(h, N-length(h));          % Pad the end of the vector with zeros
            x = pad(x, N-length(x));          % Pad the end of the vector with zeros
            y = ifft(fft(x, N) .* fft(h, N));   % Circular Convolution
        end
        % =================================================================
        % The Output from function getPartitionSize is an index which can
        % be stored, updated and looped over within the plugin. We can use
        % the index to index into the partition function.
        function y = getPartitionSize(plugin, x, bufferSize)
            y = 1:(length(x)/bufferSize);
        end
        % =================================================================
        % Partition is a function that returns a chunk of data based on
        % input(x), partitionSize(1024), partitionIdx(1).
        function y = partition(plugin, x, bufferSize, idx)
            y = x((bufferSize*idx)+1:bufferSize*(idx+1));
        end











        % =================================================================
        function out = process(plugin, in)
            % Set buffer length
            plugin.bufferSize = length(in);
            % Prepare Impulse response
            [h, ~] = plugin.midSideEncode(plugin.h);   % Convert IR to Mono
            h = plugin.normalise(h, -6);               % Normalise IR Gain
            % Partition the IR.wav, iterate through on a frame by frame
            % basis, increasing the buffer index with each frame and
            % reseting it if it goes out of bounds.
            hRange = plugin.getPartitionSize(h, plugin.bufferSize);
            %             hPartition = plugin.partition(h, plugin.bufferSize, hRange(plugin.hIdx+1));
            %             plugin.hIdx = plugin.hIdx + 1;      % Increment the buffer
            %             if plugin.hIdx == hRange
            %                 plugin.hIdx = 0;
            %             end
            %             % Convert Input to Mono
            %             [in, ~] = plugin.midSideEncode(in);
            %             % Perform convolution
            %             % c = convolve(hPartition, in);
            %             c = plugin.fftconvolve(hPartition, in);
            %             % Partition the convolution, this will be 1024 + 1024 - 1 in
            %             % length and will therefore not fit into a frame. We will need
            %             % to add the residual to the next frame along.
            %             if plugin.cIdx == 0
            %                 c = plugin.partition(c, plugin.bufferSize, plugin.cIdx);
            %             else
            %                 c = plugin.partition(c, plugin.bufferSize-1, plugin.cIdx);
            %             end
            %             plugin.cIdx = plugin.cIdx + 1;      % Increment the buffer
            %             if plugin.cIdx == 1
            %                 plugin.cIdx = 0;
            %             end
            %             % Create a wet/dry mix for the output
            %             y = (1-plugin.mix)*in + plugin.mix * c;
            %             % Apply overall gain to the output
            %             out = 10^(plugin.outputGain/20) * y;
            out = in;
        end










        % =================================================================
        function reset(plugin)
            plugin.bufferSize = 1024;
            plugin.hIdx = 0;
            plugin.cIdx = 0;
        end
    end
end