function [ z ] = mergeArray( x, y, xIndexes, yIndexes, defaultValue )
    n = length(x) + length(y);
    if nargin < 5
        z = nan(n,1);
    else
        z = ones(n,1) .* defaultValue;
    end
    
    z(xIndexes) = x;
    z(yIndexes) = y;
    
    if isrow(x)
        z = z';
    end
end

