% The Output from function getPartitionSize is an index which can be stored,
% updated and looped over within the plugin. We can use the index to index
% into the partition function.
function y = getPartitionSize(x, bufferSize)
y = 1:(length(x)/bufferSize);
end