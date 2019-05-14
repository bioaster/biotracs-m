%"""
%biotracs.core.adapter.model.AdapterConfig
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%"""

classdef (Abstract) AdapterConfig < biotracs.core.mvc.model.ProcessConfig
    
    properties
    end
    
    methods
        
        function this = AdapterConfig()
            this@biotracs.core.mvc.model.ProcessConfig();
            this.createParam('ConfigFilePath', '', 'Access', biotracs.core.mvc.model.Parameter.PRIVATE_ACCESS, 'Constraint', biotracs.core.constraint.IsInputPath());
        end
        
    end
    
    
    methods(Access = protected)
    end
    
end
