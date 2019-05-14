%"""
%biotracs.core.constraint.IsNegative
%Constraint that checks if a Parameter value is a negative numeric value
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.constraint.IsBetween, biotracs.core.constraint.IsLessThan, biotracs.core.constraint.IsGreaterThan, biotracs.core.constraint.IsPositive, biotracs.core.mvc.Parameter
%"""

classdef IsNegative < biotracs.core.constraint.IsLessThan
    
    properties
    end
    
    methods
        
        function this = IsNegative( varargin )
            p = inputParser();
            p.addParameter('Strict', false, @islogical);
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            this@biotracs.core.constraint.IsLessThan( 0, 'StrictUpperBound', p.Results.Strict, varargin{:} );
        end
        
    end
    
    methods(Access = protected)
    end
    
end

