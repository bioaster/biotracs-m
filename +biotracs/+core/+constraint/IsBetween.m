%"""
%biotracs.core.constraint.IsBetween
%Constraint that checks if a Parameter value is in given boudaries
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.constraint.IsGreaterThan, biotracs.core.constraint.IsLessThan, biotracs.core.mvc.Parameter
%"""

classdef IsBetween < biotracs.core.constraint.IsNumeric
    
    properties(SetAccess = protected)
        lowerBound = Inf;
        upperBound = -Inf;
        isLowerBoundStrict = false;
        isUpperBoundStrict = false;
    end
    
    methods
        
        function this = IsBetween( iBounds, varargin )
            p = inputParser();
            p.addParameter('StrictLowerBound', false, @islogical);
            p.addParameter('StrictUpperBound', false, @islogical);
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            
            this@biotracs.core.constraint.IsNumeric( varargin{:} );
            this.lowerBound = iBounds(1);
            this.upperBound = iBounds(2);
            this.isLowerBoundStrict = p.Results.StrictLowerBound;
            this.isUpperBoundStrict = p.Results.StrictUpperBound;
        end

    end
    
    methods(Access = protected)
        
        function tf = doIsValid( this, iValue )
            if isempty(iValue)
                tf = true; return;
            end
            
            if ~this.doIsValid@biotracs.core.constraint.IsNumeric( iValue )
                tf = false; return;
            end
            
            for i=1:length(iValue)
                val = iValue(i);
                tf =  (val > this.lowerBound && val < this.upperBound) || ...
                    (~this.isLowerBoundStrict && val == this.lowerBound) || ...
                    (~this.isUpperBoundStrict && val == this.upperBound);
                if ~tf, break; end
            end
        end
        
    end
    
end

