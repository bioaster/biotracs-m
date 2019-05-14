%"""
%biotracs.core.app.view.Window
%Window view object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See biotracs.core.app.model.Window
%"""

classdef Window < biotracs.core.app.view.UIHolder
    
    properties(SetAccess = protected)
        draggingObject;
        mouvePosition;
    end
    
    methods
        
        function this = Window()
            this@biotracs.core.app.view.UIHolder();
        end
        
        %-- A --
        
        function this = viewGui( this )
            model = this.model;
            this.handle = figure(...
                'Name', model.name, ...
                'Position', model.position, ...
                'Units', model.units, ...
                'WindowButtonUpFcn',@(h,e)(this.model.onMouseUp(h,e)), ...
                'WindowButtonDownFcn',@(h,e)(this.model.onMouseDown(h,e)), ...
                'WindowButtonMotionFcn',@(h,e)(this.model.onMouseMove(h,e)) ...
                );
            
            this.viewGui@biotracs.core.app.view.UIHolder();
        end

    end
    
end
