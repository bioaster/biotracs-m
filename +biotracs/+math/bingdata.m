function [yb,yc] = bingdata(y, x, xrg, sigma)
    [~,edges,bins] = histcounts(x,xrg(:)');
    bins = min(max(bins,1),length(xrg)-1);
    minStep = min(diff(xrg));
    if nargin <= 3 || isempty(sigma)
        sigma = minStep/2;
    end

    c = fix(3*sigma/minStep);

    nbBins = length(xrg)-1;
    [m,n] = size(y);
    yc = zeros(m,n);
    yb = zeros(nbBins,n);
    
    %fprintf('\t gaussian binning\n');
	w = biotracs.core.waitbar.Waitbar('Name', sprintf('Gaussian binning (%d bins)', nbBins));
    w.show();	
    for i=1:nbBins
        idx = (bins >= i-c & bins <= i+c);
        t = x(idx);
        m = (edges(i+1) + edges(i))/2;
        g = exp(-0.5*((t-m)./sigma).^2);
        yb(i,:) = sum(y(idx,:) .* g) / length(g);
        cIdx = (bins == i);
        yc(cIdx,:) = repmat(yb(i,:),sum(cIdx),1);
        if mod(i,5000) == 0
            %fprintf('\t %d bins / %d ...\n', i, nbBins);
			w.show(i/nbBins);
        end
    end
    
    %tau = max(y)/max(yb);
    %yb = yb * tau;
    %yc = yc * tau;
end