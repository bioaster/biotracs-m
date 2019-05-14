%"""
%biotracs.core.adapter.model.Passer
%A Passer is an Adapter that simply send a Resource on its input port to
%its output port (not really usefull, generally used for testing purposes)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%"""

classdef Passer < biotracs.core.adapter.model.Adapter
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function this = Passer()
            this@biotracs.core.adapter.model.Adapter();
            % enhance inputs specs
            this.setInputSpecs({...
                struct(...
                'name', 'Resource',...
                'class', 'biotracs.core.mvc.model.Resource' ...
                )...
                });
            % enhance outputs specs
            this.setOutputSpecs({...
                struct(...
                'name', 'Resource',...
                'class', 'biotracs.core.mvc.model.Resource' ...
                )...
                });
            this.setIsPhantom(true);
        end

        function this = setIsPhantom( this, varargin )
            this.setIsPhantom@biotracs.core.adapter.model.Adapter(true);
        end
        
    end
    
    
    methods(Access = protected)
        
    end
end
