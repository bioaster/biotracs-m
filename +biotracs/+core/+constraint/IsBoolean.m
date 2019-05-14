%"""
%biotracs.core.constraint.IsBoolean
%Constraint that checks if a Parameter value is boolean (i.e. logical)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.constraint.IsNumeric, biotracs.core.constraint.IsInteger, biotracs.core.mvc.Parameter
%"""

classdef IsBoolean < biotracs.core.constraint.Constraint
    
    properties(SetAccess = protected)
        isScalar = true;
    end
    
    methods
        
        function this = IsBoolean( varargin )
            this@biotracs.core.constraint.Constraint();
            p = inputParser();
            p.addParameter('IsScalar', true, @islogical);
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            
            this.isScalar = p.Results.IsScalar;
        end
        
    end
    
    methods(Access = protected)
        
        function tf = doIsValid( this, iValue )
            if isempty(iValue)
                tf = true; return;
            end
            
            if this.isScalar && ~isscalar(iValue)
                tf = false; return;
            end
            
            tf = islogical(iValue);
        end
        
    end
    
end

