clear;clc;close
[x, fs]= audioread('AudioSamples/SilverVerb_IR.wav');
bufferSize = 1024;

bufferIdx = getPartitionSize(x, bufferSize);
% Concatenate the input
% This structure must always be followed if the intention is to concatenate
% the chunks together
y = 0;
for n = 0:bufferIdx(end)-1
    [y] = [y  partition(x, bufferSize, bufferIdx(n+1)-1)];
end
y = y';
y(1) = [];

test = partition(x, bufferSize, bufferIdx(57))

% Functions
% The Output from function getPartitionSize is an index which can be stored,
% updated and looped over within the plugin. We can use the index to index
% into the partition function.
function y = getPartitionSize(x, bufferSize)
y = 1:(length(x)/bufferSize);
end
% Partition is a function that returns a chunk of data based on input(x),
% partitionSize(1024), partitionIdx(1).
function y = partition(x, bufferSize, idx)
y = x((bufferSize*idx)+1:bufferSize*(idx+1));
end