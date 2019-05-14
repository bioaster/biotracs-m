%"""
%biotracs.math.centerscale
%Center and scale a numeric array along rows/columns with respect to the mean and standard deviation of a `Xref`
%* `X` The N-by-M array to normalize
%* `Xref` The P-by-M reference array (if not given, `X` is used as reference)
%* return the normalized array
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.math.reversecenterscale
%"""

function [ Xout ] = centerscale( X, Xref, varargin )

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
            
            if dir == 1
                expectedSize = [1, size(X,2)];
            else
                expectedSize = [size(X,1), 1];
            end
            
            if p.Results.Center && ~isequal(size(refMean), expectedSize)
                error('The mean must be %d-by-%d vectors',expectedSize(1),expectedSize(2));
            end
            
             if ~strcmp( p.Results.Scale, 'none') && ~isequal(size(refStd), expectedSize)
                error('The std must be %d-by-%d vectors',expectedSize(1),expectedSize(2));
            end
        end
    end

    if p.Results.Center
        Xout = doCenter( X, refMean, dir );
        if ~strcmp( p.Results.Scale, 'none')
            Xout = doScale( Xout, refStd, p.Results.Scale, dir );
        end
    else
        if ~strcmp( p.Results.Scale, 'none')
            Xout = doScale( X, refStd, p.Results.Scale, dir );
        else
            Xout = X;
        end
    end

end

%--------------------------------------------------------------------------
function [ Xout ] = doCenter( X, refMean, dir )
    if dir == 1
        %nrows = size(X,1);
        %Xout = X - repmat(refMean, nrows, 1);
        Xout = bsxfun(@minus, X, refMean);
    else
        %ncols = size(X,2);
        %Xout = X - repmat(refMean, 1, ncols);
        Xout = bsxfun(@minus, X', refMean');
        Xout = Xout';
    end
end

%--------------------------------------------------------------------------
function [ Xout ] = doScale( X, refStd, scalingType, dir  )
    if dir == 1
        if strcmp( scalingType, 'uv' )
            %Xout = X * diag( 1./refStd );			  % <=> M / diag(std)
            Xout = bsxfun(@times, X, 1./refStd);
        elseif strcmp( scalingType, 'pareto' )
            %Xout = X * diag( 1./refStd.^2 );		  % <=> M / diag(std.^2)
            Xout = bsxfun(@times, X, 1./refStd.^2);
        end
    else
        if strcmp( scalingType, 'uv' )
            %Xout = diag( 1./refStd ) * X;			  % <=> ( M / diag(std) ).'
            Xout = bsxfun(@times, X', 1./refStd');
        elseif strcmp( scalingType, 'pareto' )
            %Xout =  diag( 1./refStd.^2 ) * X;		  % <=> ( M / diag(std.^2) ).'
            Xout = bsxfun(@times, X', 1./refStd');
        end
        Xout = Xout';
    end
end