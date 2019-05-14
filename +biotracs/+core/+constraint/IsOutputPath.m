%"""
%biotracs.core.constraint.IsOutputPath
%Constraint that checks if a Parameter value is a text corresponding to a valid
%file path (alias of `biotracs.core.constraint.IsPath` constraint)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.constraint.IsPath, biotracs.core.constraint.IsOutputPath, biotracs.core.constraint.Text, biotracs.core.mvc.Parameter
%"""

classdef IsOutputPath < biotracs.core.constraint.IsPath
    
    properties
        
    end
    
    methods

        function this = IsOutputPath( varargin ) 
            this@biotracs.core.constraint.IsPath(varargin{:});
        end

    end
    
    methods(Access = protected)
    end
    
end

