%"""
%biotracs.core.constraint.IsRange
%Constraint that checks if a Parameter value is a numeric range `[a, b]`,
%where `a` and `b` are numeric values
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.constraint.IsNumeric, biotracs.core.mvc.Parameter
%"""

classdef IsRange < biotracs.core.constraint.IsNumeric
    
    properties
        lowerBound = -Inf;
        upperBound = Inf;
        isLowerBoundStrict = false;
        isUpperBoundStrict = false;
    end
    
    methods
        
        function this = IsRange( iBounds, varargin )
            p = inputParser();
            p.addParameter('StrictLowerBound', false, @islogical);
            p.addParameter('StrictUpperBound', false, @islogical);
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            
            this@biotracs.core.constraint.IsNumeric( varargin{:} );
            
            if nargin >= 1
                this.lowerBound = iBounds(1);
                this.upperBound = iBounds(2);
            end
            this.isLowerBoundStrict = p.Results.StrictLowerBound;
            this.isUpperBoundStrict = p.Results.StrictUpperBound;
            this.isScalar = false;
        end
    end
    
    methods(Access = protected)
        
        % @ToDo : Bug to fix !
        function tf = doIsValid( this, iValue )
            if isempty(iValue)
                tf = true; return;
            end
            
            if ~this.doIsValid@biotracs.core.constraint.IsNumeric( iValue )
                tf = false; return;
            end
            
            if length(iValue)~= 2
                tf = false; return;
            end

            tf = ((iValue(1) > this.lowerBound) || (~this.isLowerBoundStrict && iValue(1) == this.lowerBound)) &&...
                ((iValue(2) < this.upperBound) || (~this.isUpperBoundStrict && iValue(2) == this.upperBound));
        end
        
        
    end
    
end

