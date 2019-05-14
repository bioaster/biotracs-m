%"""
%biotracs.core.mvc.model.WorkflowConfig
%Defines the configuration object of a Workflow
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.mvc.model.Workflow
%"""

classdef WorkflowConfig < biotracs.core.mvc.model.ProcessConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = WorkflowConfig()
            biotracs.core.mvc.model.ProcessConfig();
        end

        %-- C --
        
        %-- G --

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        %-- C --

    end
    
end
