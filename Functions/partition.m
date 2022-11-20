% Partition is a function that returns a chunk of data based on input(x),
% partitionSize(1024), partitionIdx(1).
function y = partition(x, bufferSize, idx)

    k = 0:(length(x)/bufferSize)-1; k = k';
    y = x((bufferSize*k(idx))+1:bufferSize*(k(idx)+1));
end