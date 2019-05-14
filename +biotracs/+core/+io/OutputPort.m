%"""
%biotracs.core.io.OutputPort
%OutputPort objects are ports on Output objects. Each port contains a Resource
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.io.Input, biotracs.core.io.Output, biotracs.core.io.InputPort, biotracs.core.io.Port, biotracs.core.mvc.model.Resource
%"""

classdef OutputPort < biotracs.core.io.Port
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function this = OutputPort( varargin )
            this@biotracs.core.io.Port( varargin{:} );
        end
       

        function this = connectTo( this, varargin )
            for i=1:length(varargin)
                isParameter = ischar(varargin{i});
                if isParameter
                    break;
                elseif ~isa( varargin{i}, 'biotracs.core.io.InputPort')
                    %error('Only inputs can be connected to outputs');
                end
            end
            this.connectTo@biotracs.core.io.Port( varargin{:} );
        end
        
    end
    
end

