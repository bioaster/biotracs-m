%"""
%biotracs.core.constraint.IsPositive
%Constraint that checks if a Parameter value is a positive numeric value
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.constraint.IsBetween, biotracs.core.constraint.IsLessThan, biotracs.core.constraint.IsGreaterThan, biotracs.core.constraint.IsNegative, biotracs.core.mvc.Parameter
%"""

classdef IsPositive < biotracs.core.constraint.IsGreaterThan
    
    properties
    end
    
    methods
        
        function this = IsPositive( varargin )
            p = inputParser();
            p.addParameter('Strict', false, @islogical);
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            this@biotracs.core.constraint.IsGreaterThan( 0, 'Strict', p.Results.Strict, varargin{:} );
        end
        
    end
    
    methods(Access = protected)
    end
    
end

