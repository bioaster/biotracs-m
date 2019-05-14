%"""
%biotracs.core.constraint.IsInputPath
%Constraint that checks if a Parameter value is a text corresponding to the
%path of a file that exists (i.e. that can be used as input file)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.constraint.IsPath, biotracs.core.constraint.IsInputPath, biotracs.core.constraint.Text, biotracs.core.mvc.Parameter
%"""

classdef IsInputPath < biotracs.core.constraint.IsPath
    
    properties
        
    end
    
    methods

        function this = IsInputPath( varargin ) 
            this@biotracs.core.constraint.IsPath( varargin{:} );
            p = inputParser();
            p.addParameter('PathMustExist', true, @islogical);
            p.parse(varargin{:});
            if ~this.pathMustExist
                this.pathMustExist = p.Results.PathMustExist;
            end
        end

    end
    
    methods(Access = protected)
    end
    
end

