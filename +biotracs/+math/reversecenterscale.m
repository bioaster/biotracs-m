%"""
%biotracs.math.centerscale
%Reverse centering and scaling of a numeric array along rows/columns with respect to the mean and standard deviation. This function performs the reciprocal operation of biotracs.math.centerscale, i.e. `X = biotracs.math.reversecenterscale( biotracs.math.centerscale(X) )`
%* `X` The N-by-M array to normalize
%* `Xref` The P-by-M reference array (if not given, `X` is used as reference)
%* return the reverse-normalized array
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.math.centerscale
%"""

function [ Xout ] = reversecenterscale( X, Xref, varargin )
	 
	 p = inputParser();
	 p.addParameter('Center', false, @islogical);
	 p.addParameter('Scale', 'none', @ischar);
	 p.addParameter('Direction', 'column', @ischar);
	 p.KeepUnmatched = true;
	 p.parse(varargin{:});

	 if strcmp( p.Results.Direction, 'column')
		  dir = 1;
	 else
		  dir = 2;
	 end
     
     if isempty( Xref )
         refMean = mean(X,dir);
         refStd = std(X,0,dir);
     else
         if isnumeric(Xref)
             refMean = mean(Xref,dir);
             refStd = std(Xref,0,dir);
         elseif iscell(Xref)
             refMean = Xref{1};
             refStd = Xref{2};
         end
         
         if dir == 1
             expectedSize = [1, size(X,2)];
         else
             expectedSize = [size(X,1), 1];
         end
         if ~isequal(size(refMean), expectedSize) || ~isequal(size(refStd), expectedSize)
             error('Mean and Std be %d-by-%d vectors',expectedSize(1),expectedSize(2));
         end
     end
		  
	 if ~strcmp( p.Results.Scale, 'none' )
		  Xout = doScale( X, refStd, p.Results.Scale, dir );
		  if p.Results.Center
				Xout = doCenter( Xout, refMean, dir );
		  end
	 else
		  if p.Results.Center
				Xout = doCenter( X, refMean, dir );
		  else
				Xout = X;
		  end
	 end
	 
%	  if p.Results.Center
%			Xout = doCenter( X, refMean, dir );
%			if ~strcmp( p.Results.Scale, 'none')
%				 Xout = doScale( Xout, refStd, p.Results.Scale, dir );
%			end
%	  else
%			if ~strcmp( p.Results.Scale, 'none')
%				 Xout = doScale( X, refStd, p.Results.Scale, dir );
%			else
%				 Xout = X;
%			end
%	  end
	 
end

%--------------------------------------------------------------------------
function [ Xout ] = doCenter( X, refMean, dir )
    if dir == 1
        %nrows = size(X,1);
        %Xout = X + repmat(refMean, nrows, 1);
        Xout = bsxfun(@plus, X, refMean);
    else
        %ncols = size(X,2);
        %Xout = X + repmat(refMean, 1, ncols);
        Xout = bsxfun(@plus, X', refMean');
        Xout = Xout';
    end
end

%--------------------------------------------------------------------------
function [ Xout ] = doScale( X, refStd, scalingType, dir  )
    if dir == 1
        if strcmp( scalingType, 'uv' )
            %Xout = X * diag( refStd );			  % <=> M * diag(std)
            Xout = bsxfun(@times, X, refStd);
        elseif strcmp( scalingType, 'pareto' )
            %Xout = X * diag( refStd.^2 );		  % <=> M * diag(std.^2)
            Xout = bsxfun(@times, X, refStd.^2);
        end
    else
        if strcmp( scalingType, 'uv' )
            %Xout = diag( refStd ) * X;			  % <=> ( M * diag(std) ).'
            Xout = bsxfun(@times, X', refStd');
        elseif strcmp( scalingType, 'pareto' )
            %Xout =  diag( refStd.^2 ) * X;		  % <=> ( M * diag(std.^2) ).'
            Xout = bsxfun(@times, X', (refStd.^2)');
        end
        Xout = Xout';
    end
end