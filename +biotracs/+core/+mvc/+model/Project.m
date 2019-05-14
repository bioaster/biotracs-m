%"""
%biotracs.core.mvc.model.Project
%Defines the Project object. 
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%"""

classdef Project < biotracs.core.mvc.model.BaseObject
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Project()
            this@biotracs.core.mvc.model.BaseObject();
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)

    end
end

