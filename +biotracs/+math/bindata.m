function [yb,yc] = bindata(y,x,xrg)
    %function [yb,yc] = bindata(y,x,xrg)
    %Computes yb(ii) = mean(y(x>=xrg(ii) & x < xrg(ii+1)) for every ii
    %using a fast algorithm which uses no looping
    %If a bin is empty it returns nan for that bin
    %Also returns yc, the approximation of y using binning (useful for r^2
    %calculations). Example:
    %
    %x = randn(100,1);
    %y = x.^2 + randn(100,1);
    %xrg = linspace(-3,3,10)';
    %[yb,yc] = bindata(y,x,xrg);
    %X = [xrg(1:end-1),xrg(2:end)]';
    %Y = [yb,yb]'
    %plot(x,y,'.',X(:),Y(:),'r-');
    %
    %By Patrick Mineault
    %Refs: http://xcorr.net/?p=3326
    %      http://www-pord.ucsd.edu/~matlab/bin.htm
    [~,~,whichedge] = histcounts(x,xrg(:)');
    bins = min(max(whichedge,1),length(xrg)-1);
    xpos = ones(size(bins,1),1);
    
    nbBins = length(xrg)-1;
    [m,n] = size(y);
    yc = zeros(m,n);
    yb = zeros(nbBins,n);
    
    ns = sparse(bins,xpos,1);
    for i=1:n
        if isa(y, 'single')            
            ysum = sparse(bins,xpos,double(y(:,i)));
        else
            ysum = sparse(bins,xpos,y(:,i));
        end
        yb(:,i) = full(ysum)./(full(ns));
        yc(:,i) = yb(bins,i);
    end
end