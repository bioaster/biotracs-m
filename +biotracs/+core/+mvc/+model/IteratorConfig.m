%"""
%biotracs.core.mvc.model.IteratorConfig
%Defines the configuration of an iterator object.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2018
%* See: biotracs.core.mvc.model.Iterator
%"""

classdef IteratorConfig < biotracs.core.mvc.model.ProcessConfig
    
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
        function this = IteratorConfig()
            biotracs.core.mvc.model.ProcessConfig();
            
            this.createParam( 'TraceIteration', false, 'Constraint', biotracs.core.constraint.IsBoolean() );
        end

        %-- C --
        
        %-- B --

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        %-- C --

    end
    
end
