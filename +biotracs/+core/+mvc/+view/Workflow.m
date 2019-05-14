%"""
%biotracs.core.mvc.view.Workflow
%Workflow view object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.mvc.model.Workflow
%"""

classdef Workflow <  biotracs.core.mvc.view.BaseObject
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function this = Workflow( varargin )
            this@biotracs.core.mvc.view.BaseObject( varargin{:} );
        end

    end
    
    methods(Access = protected)

        
    end
end

