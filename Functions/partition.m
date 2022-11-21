% Partition is a function that returns a chunk of data based on input(x),
% partitionSize(1024), partitionIdx(1). This function outputs a maximum
% index that can be used later.
% function [y, maxIdx] = partition(x, bufferSize, idx)
% xLen = length(x);
% k = 0:(round(xLen/bufferSize))-1; k = k'; % Index used internally
% maxIdx = max(k)+1;
% % Calculate the difference between the input and buffer size
% sampleOverlap = mod(xLen, bufferSize);
% % If the buffer is too large then make the last 
% if sampleOverlap ~= 0 & idx == maxIdx
%     y = x((bufferSize+1*k(idx)):sampleOverlap*(k(idx)+1)+1);
% else
%     y = x((bufferSize*k(idx))+1:bufferSize*(k(idx)+1));
% end
% fprintf(['idx = ' num2str(idx) '\n'])
% fprintf(['K = ' num2str(k(idx)+1) '\n'])
% end

function [y, maxIdx] = partition(x, bufferSize, idx)
xLen = length(x);
k = 0:(round(xLen/bufferSize))-1; k = k'; % Index used internally
maxIdx = max(k)+1;
% Calculate the difference between the input and buffer size
sampleOverlap = mod(xLen, bufferSize)
% If the buffer is too large then make the last 
if sampleOverlap ~= 0 && idx == maxIdx
    y = x((bufferSize+1*k(idx)):sampleOverlap*(k(idx)+1)+1);
else
    y = x((bufferSize*k(idx))+1:bufferSize*(k(idx)+1));
end
fprintf(['idx = ' num2str(idx) '\n'])
fprintf(['K = ' num2str(k(idx)+1) '\n'])
end