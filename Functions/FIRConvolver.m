classdef FIRConvolver < audioPlugin
    % Publicly Accessible Parameters
    properties
        outputGain = -6;    % Gain in dBFS
        mix = .5;           % wet/dry Mix ranging between 0->1
    end
    % Privately Stored Impulse Response
    properties (Access = private)
        %         h = audioread("AudioSamples/SilverVerb_IR.wav");    % Store the IR
        h = audioread("AudioSamples/Single Cycle Bell.wav");    % Store the IR
    end
    % User Parameters
    properties (Constant)
        PluginInterface = audioPluginInterface( ...
            'PluginName','FIR Convolver',...
            audioPluginParameter('outputGain','DisplayName','Output Gain',...
            'Mapping',{'lin',-82,12},'Style','rotaryknob','Label',' dB','Layout',[2,1]),...
            audioPluginParameter('mix','DisplayName','Wet/Dry Mix',...
            'Mapping',{'lin',0,1},'Style','rotaryknob','Layout',[4,1]),...
            audioPluginGridLayout(...
            'RowHeight',[20,120,20,120,20], ...
            'ColumnWidth',[100]));
    end
    % Where the DSP Lives
    methods(Static)
        % Gain Normalise
        function [y] = normalise(x, gaindBFS)
            % Difference Equation
            % y[n] = gain * (x[n]/max(x))
            [N, C] = size(x)
            y = zeros(N, C)
            if C == 1
                y = 10^(gaindBFS/20)*(x/max(abs(x))); % Normalise Gain
            else
                dataL = 10^(gaindBFS/20)*(x(:,1)/max(abs(x(:,1)))); % Normalise Gain
                dataR = 10^(gaindBFS/20)*(x(:,2)/max(abs(x(:,2)))); % Normalise Gain
                y = [dataL dataR]
            end
        end
        % Mid Side Encode Function
        function [yMid, ySide] = midSideEncode(x)
            % Mid == 1; Side == 2
            left  = x(:, 1);
            right = x(:, 2);
            yMid  = 0.5 * left + right;
            ySide = 0.5 * left - right;
        end
        % FIRConvolve function
        function [y] = convolve(h, x)
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
    end % End of Static Methods Block
    % Where the process block lives
    methods
        function out = process(plugin, in)
            % Prepare Impulse response
            [h, ~] = midSideEncode(plugin.h); % Convert IR to Mono
            h = normalise(h, -6); % Normalise IR Gain
            %             h = plugin.h(1:1024, 1); % Partition h for faster processing

            in = midSideEncode(in);             % Convert Input to Mono
            % Perform convolution
            c = convolve(h, in);
            % Create a wet/dry mix for the output
            y = (1-plugin.mix)*in + plugin.mix * c;
            % Apply overall gain to the output
            out = 10^(plugin.outputGain/20) * y;
        end
    end

end