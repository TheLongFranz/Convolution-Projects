% The Output from function getPartitionSize is an index which can be stored,
% updated and looped over within the plugin. We can use the index to index
% into the partition function.
% =========================================================================
% DEPRECATED
% =========================================================================
function y = getPartitionSize(x, bufferSize)
% y = 0:(length(x)/bufferSize)-1;
y = 0:(length(x)/bufferSize)-1;
end