%"""
%biotracs.core.mvc.model.Engine
%Defines the Engine object. An Engine is a type of Process that can be binded to another process to allow process delegation and code reusability. 
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2018
%* See: biotracs.core.mvc.model.Process
%"""

classdef Engine < biotracs.core.ability.Runnable
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Engine( )
            this@biotracs.core.ability.Runnable();
        end
        
        %-- A --
        
        %-- B --
        
        %-- C --

        %-- E --
        
        %-- G --
        
        %-- R --
        
        %-- S --
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
    end
    
end

