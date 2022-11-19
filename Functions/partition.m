% Partition is a function that returns a chunk of data based on input(x),
% partitionSize(1024), partitionIdx(1).
function y = partition(x, bufferSize, idx)
y = x((bufferSize*idx)+1:bufferSize*(idx+1));
end