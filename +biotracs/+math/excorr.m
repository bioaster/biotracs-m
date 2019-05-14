function [ corr, pvalue ] = excorr( X, Y, where )
	 % Compute exclusive correlation (only-non zero data are used for
	 % correlation)
	 % X:		  n-by-1 vector (left signal)
	 % Y:		  n-by-1 vector (right signal)
	 % where:	 'left' for X, 'right' for Y or 'both' for both X and Y. 
	 %			  Signal where non-zero data must be excluded (i.e. set to zero) before computed correlation
	 %
	 %
	 % e.g.: 
	 %			  X = [1, 2, 3, 0, 5, 6]; 
	 %			  Y = [1, 2, 3, 4, 0, 6];
	 %			  math.excorr(X,Y, 'both') => 1;
	 %			  math.excorr(X,Y, 'right') => 0.605753588859093;
	 %			  math.excorr(X,Y, 'left') => 0.730798148647035
	 
	 if nargin == 2 || strcmp(where, 'both')
		  % Return a correlation = 1 if both non-zero data in X and Y exactly match
	 	excludedXIndexes =  X > 0;
		  excludedYIndexes =  Y > 0;
		  [R, P] = corrcoef(  X.*excludedYIndexes, Y.*excludedXIndexes );
	 elseif strcmp(where, 'left')
		  % Return a correlation = 1 if non-zero data in X are in Y.
		  % Exclude non-zero data from X
		  excludedYIndexes =  Y > 0;
		  [R, P] = corrcoef(  X.*excludedYIndexes, Y );
	 elseif strcmp(where, 'right')
		  % Return a correlation = 1 if non-zero data in Y are in X.
		  % Exclude non-zero data from Y
		  excludedXIndexes =  X > 0;
		  [R, P] = corrcoef(  X, Y.*excludedXIndexes );
	 elseif strcmp(where, 'none')
		  [R, P] = corrcoef(  X, Y );
	 else
		  error('Invalid reference signal')
	 end
	 corr = R(1,2);
	 pvalue = P(1,2);
end