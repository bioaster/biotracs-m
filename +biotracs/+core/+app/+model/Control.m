%"""
%biotracs.core.app.model.Control
%Base control graphical object. All grahical user objects inherit the Control object. 
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See biotracs.core.app.view.Control
%"""

classdef (Abstract) Control < biotracs.core.app.model.Gui
    
    properties(SetAccess = protected)
        style;
    end
    
    events
    end
    
    methods
        
        function this = Control( varargin )
            this@biotracs.core.app.model.Gui( varargin{:} );
        end
        
        %-- N --
        
        %-- O --
        
        function onMouseDown( this, hObject, eventdata )
            if ~isempty(this.parent)
                this.parent.draggingObject = [];
                this.parent.mousePosition = get(gcf,'CurrentPoint');
            end
            %change position
        end
        
        %-- S --
    end
    
end