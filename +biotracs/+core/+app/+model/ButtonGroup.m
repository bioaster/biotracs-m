%"""
%biotracs.core.app.model.ButtonGroup
%Graphical user button group
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See biotracs.core.app.view.ButtonGroup
%"""

classdef ButtonGroup < biotracs.core.app.model.UIHolder
    
    properties(SetAccess = protected)
    end
    
    events
        submit;
    end
    
    methods
        
        function this = ButtonGroup( varargin )
            this@biotracs.core.app.model.UIHolder( varargin{:} );
            this.bindView( biotracs.core.app.view.ButtonGroup() );
            
            if isempty(this.position)
                this.position = [ 10, 10, this.parent.width()-20, this.parent.height()-20 ];
            end
            this.name = 'MyButtonGroup';
        end
        
        %-- N --
        
        %-- V --
        
    end
    
end