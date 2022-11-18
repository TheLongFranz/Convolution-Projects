   function [y] = midSideDecode(xMid, xSide)

        left  = xMid + xSide;
        right = xMid - xSide;

        y = [left, right];

    end