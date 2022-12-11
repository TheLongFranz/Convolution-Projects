function [y] = FIRFilter(x, k, a)
% Convert the input signal to a row vector
x = [x, zeros(k)]; % Zero pad 'x' to allow for the size increase due to the filter order
% in c++ x.push_back(0)
idx = 1; idx1 = 1; % Reset before each loop
% fprintf('\nOutput\n');
for n = 1:length(x)
    %     fprintf(['Loop ' num2str(n) ': ']);
    if n == 1
        y(n) = x(n);
        %         fprintf(['y(' num2str(n) ') = ' num2str(x(n)) '\n']);
    else
        y(n) = x(n) + a*x(idx);
        %         fprintf(['y(' num2str(n) ') = ' num2str(x(n)) '+' num2str(a) '*' num2str(x(idx)) ' = ' num2str(y(n)) '\n']);
    end
    idx = idx1;
    idx1 = n+1;
end
end