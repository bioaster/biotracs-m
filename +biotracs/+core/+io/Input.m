%"""
%biotracs.core.io.Input
%Input objects define the inputs of Runnable objects (e.g. Process and Workflow objects). An input is a PortSet, i.e. is composed of several InputPort objects.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.io.PortSet, biotracs.core.io.Output, biotracs.core.io.Terminal, biotracs.core.io.InputPort, biotracs.core.io.OutputPort, biotracs.core.io.Port, biotracs.core.io.PortSet, biotracs.core.ability.Runnable
%"""

classdef Input < biotracs.core.io.PortSet
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function this = Input( iSpecs )
			%#function biotracs.core.io.InputPort
			
            this@biotracs.core.io.PortSet();
            this.classNameOfElements = {'biotracs.core.io.InputPort'};
            if nargin == 1, this.setSpecs(iSpecs); end
        end

        %-- G --
        
        %-- S --
        
        %overload biotracs.core.container.Set methods
        function setClassNameOfElements( varargin ), error('BIOTRACS:Input:setClassNameOfElements:SealedAttribute', 'Cannot change attribute classNameOfElements'); end
    end
    
end

