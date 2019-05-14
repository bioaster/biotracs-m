%"""
%biotracs.core.app.model.Window
%Gaphical user window. A Window object is a UIHolder and then contains several Control objects
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See biotracs.core.app.view.Window
%"""

classdef Window < biotracs.core.app.model.UIHolder
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function this = Window( varargin )
            this@biotracs.core.app.model.UIHolder( varargin{:} );
            this.bindView( biotracs.core.app.view.Window() );
            if isempty(this.position)
                scrsz = get(groot,'ScreenSize');
                this.position = [scrsz(3)/4 scrsz(4)/4 scrsz(3)/2 scrsz(4)/2];
            end
            
            if isempty(this.units)
                this.units = 'pixels';
            end
        end


        function onMouseDown(this, hObject,eventdata)
        end
        
        function onMouseUp(this, hObject,eventdata)
            if ~isempty(this.draggingObject)
                newPos = get(gcf,'CurrentPoint');
                posDiff = newPos - this.mousePosition;
                set(this.draggingObject,'Position',get(this.draggingObject,'Position') + [posDiff(1:2) 0 0]);
                this.draggingObject = [];
            end
        end
        
        function onMouseMove(this, hObject,eventdata)
            if ~isempty(this.draggingObject)
                newPos = get(gcf,'CurrentPoint');
                posDiff = newPos - this.mousePosition;
                this.mousePosition = newPos;
                set(this.draggingObject,'Position',get(this.draggingObject,'Position') + [posDiff(1:2) 0 0]);
            end
        end
        
    end
    
end