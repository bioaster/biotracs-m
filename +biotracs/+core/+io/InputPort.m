%"""
%biotracs.core.io.InputPort
%InputPort objects are ports on Input objects. Each port contains a Resource
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.io.Input, biotracs.core.io.Output, biotracs.core.io.OutputPort, biotracs.core.io.Port, biotracs.core.mvc.model.Resource
%"""

classdef InputPort < biotracs.core.io.Port
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function this = InputPort( varargin )
            this@biotracs.core.io.Port( varargin{:} );
        end
        
        function this = connectTo( this, varargin )
            for i=1:length(varargin)
                isParameter = ischar(varargin{i});
                if isParameter
                    break;
                elseif isa( varargin{i}, 'biotracs.core.io.InputPort' )
                    %error('Only outputs can be connected to inputs');
                end
            end
            this.connectTo@biotracs.core.io.Port( varargin{:} );
        end
        
    end
    
    methods(Access = ?biotracs.mvc.model.Workflow)
        
    end
    
end

