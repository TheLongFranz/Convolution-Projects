    function [yMid, ySide] = midSideEncode(x)

        % Mid == 1; Side == 2

        left  = x(:, 1);
        right = x(:, 2);

        yMid  = 0.5 * left + right;
        ySide = 0.5 * left - right;

    end