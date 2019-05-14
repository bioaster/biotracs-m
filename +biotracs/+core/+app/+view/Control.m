%"""
%biotracs.core.app.view.Control
%Control view object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See biotracs.core.app.model.Control
%"""

classdef (Abstract) Control < biotracs.core.app.view.Gui
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function this = Control()
            this@biotracs.core.app.view.Gui();
        end
        
        %-- V --
        
        function this = viewGui( this )
            model = this.model;
            if model.hasParent()
                hp = model.getParent().getView().getHandle();
            else
                error('No parent Gui exists for this control');
            end
            this.handle = uicontrol(...
                'Style', model.style, ...
                'Position', model.position, ...
                'String', model.string, ...
                'FontSize', model.fontSize, ...
                'Units', model.units, ...
                'Parent', hp, ...
                'ButtonDownFcn', @(h,e)(this.model.onMouseDown(h,e)) ...
            );
            %this.handle
        end
        
    end
    
end
