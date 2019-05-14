function [ Y, X ] = lowess( x, y, factor, xf )
    if factor == 1
        X = x;
    elseif factor > 0 && factor < 1
        nbpoints = fix(length(x)/factor);
        step = (x(end)-x(1)) / nbpoints;
        X = 1:step:x(end);
    else
        error('Factor must be in > 0 and <= 1');
    end
    
    Y = interp1(x,y,X,'pchip');
    Y(1) = y(1);
    Y = mslowess(X(:), Y(:));
        
    if nargin == 4
        Y = interp1(X,Y,xf,'pchip');
        X = xf;
    elseif factor ~= 1
        Y = interp1(X,Y,x,'pchip');
        X = x;
    end
end

