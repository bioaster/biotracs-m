%"""
%biotracs.core.constraint.IsInteger
%Constraint that checks if a Parameter value is an numeric integer
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.constraint.IsNumeric, biotracs.core.constraint.IsBoolean, biotracs.core.mvc.Parameter
%"""

classdef IsInteger < biotracs.core.constraint.IsNumeric
    
    properties
    end
    
    methods
        
        function this = IsInteger( varargin )
            p = inputParser();
            p.addParameter('IsScalar', true, @islogical);
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            
            this@biotracs.core.constraint.IsNumeric( 'Type', 'integer', 'IsScalar', p.Results.IsScalar, varargin{:} );
            this.isScalar = p.Results.IsScalar;
        end
        
    end
    
    methods(Access = protected)

    end
    
end

