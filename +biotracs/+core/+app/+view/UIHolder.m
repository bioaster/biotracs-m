%"""
%biotracs.core.app.view.UIHolder
%UIHolder view object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See biotracs.core.app.model.UIHolder
%"""

classdef(Abstract) UIHolder < biotracs.core.app.view.Gui
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function this = UIHolder()
            this@biotracs.core.app.view.Gui();
        end
        
        %-- A --
        
        function this = viewGui( this )
            model = this.model;
            for i=1:getLength(model.children)
                child = model.children.getAt(i);
                child.view('Gui');
            end
        end
        
    end
    
end
