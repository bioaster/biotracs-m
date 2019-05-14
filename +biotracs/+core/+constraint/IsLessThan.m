%"""
%biotracs.core.constraint.IsLessThan
%Constraint that checks if a Parameter value is less than a numeric value
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.constraint.IsBetween, biotracs.core.constraint.IsGreaterThan, biotracs.core.constraint.IsPositive, biotracs.core.constraint.IsNegative, biotracs.core.mvc.Parameter
%"""

classdef IsLessThan < biotracs.core.constraint.IsBetween
    
    properties
    end
    
    methods
        
        function this = IsLessThan( iUpperBound, varargin )
            p = inputParser();
            p.addParameter('Strict', false, @islogical);
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            this@biotracs.core.constraint.IsBetween( [-Inf, iUpperBound], 'Strict', p.Results.StrictUpperBound, varargin{:} );
        end
        
    end
    
    methods(Access = protected)
    end
    
end

