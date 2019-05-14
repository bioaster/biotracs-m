%"""
%biotracs.math.originnorm
%Normalize the columns and a numeric array `X` with respect to the first element in each column
%* `X` The N-by-M array to normalize (a list of N array of length M)
%* return The normalized array
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%"""

function [ onX ] = originnorm( X )
	 ncols = size(X,2);
	 onX = X ./ repmat( X(:,1), 1, ncols);
end
