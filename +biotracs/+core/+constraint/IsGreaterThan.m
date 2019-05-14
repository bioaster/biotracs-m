%"""
%biotracs.core.constraint.IsGreaterThan
%Constraint that checks if a Parameter value is greater than a numeric
%value
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.constraint.IsBetween, biotracs.core.constraint.IsLessThan, biotracs.core.constraint.IsPositive, biotracs.core.constraint.IsNegative, biotracs.core.mvc.Parameter
%"""

classdef IsGreaterThan < biotracs.core.constraint.IsBetween
    
    properties
    end
    
    methods
        
        function this = IsGreaterThan( iLowerBound, varargin )
            p = inputParser();
            p.addParameter('Strict', false, @islogical);
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            
            this@biotracs.core.constraint.IsBetween( [iLowerBound, Inf], 'StrictLowerBound', p.Results.Strict, varargin{:} );
        end
        
    end
    
    methods(Access = protected)
    end
    
end

