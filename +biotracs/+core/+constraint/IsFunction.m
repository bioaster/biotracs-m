%"""
%biotracs.core.constraint.IsFunction
%Constraint that checks if a Parameter value is a function handle
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.constraint.IsClass, biotracs.core.mvc.Parameter
%"""

classdef IsFunction < biotracs.core.constraint.Constraint
    
    properties
    end
    
    methods
        function this = IsFunction( varargin )
            this@biotracs.core.constraint.Constraint();
        end

    end
    
    methods(Access = protected)
        
        function tf = doIsValid( ~, iValue )
            if isempty(iValue)
                tf = true; return;
            end
            tf = isa(iValue, 'function_handle');
        end
    end
    
end

