function [xcf, lags] = ixcorr( X, Y, maxlag )
% Index cross-correlation estimate
% Replaces all non-zero data in X and Y by 1 and then estimates
% the cross-correlation function between X and Y
%
% This function estimates how the indexes of X and Y where data is
% significant (> 0) are correlated.
	 
	 n = length(X); 
	 for i=1:n
		  if X(i) > 0, X(i) = 1; end
		  if Y(i) > 0, Y(i) = 1; end
	 end
	 [xcf, lags] = biotracs.math.xcorr( X, Y, maxlag );
end