%"""
%biotracs.core.app.view.Panel
%Panel view object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See biotracs.core.app.model.Panel
%"""

classdef Panel < biotracs.core.app.view.UIHolder
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function this = Panel()
            this@biotracs.core.app.view.UIHolder();
        end
        
        %-- V --
        
        %@param[in] optional
        function this = viewGui( this, varargin )
            model = this.model;
            if model.hasParent()
                hp = model.getParent().getView().getHandle();
            else
                error('No parent Gui exists for this form');
            end
            this.handle = uipanel(...
                'Title', model.name, ...
                'FontSize', 10, ...
                'BackgroundColor','white',...
                'Units', model.units, ...
                'FontSize', model.fontSize, ...
                'Parent', hp );
            this.handle.Position = model.position;
            
            this.viewGui@biotracs.core.app.view.UIHolder();
        end

    end
    
end
