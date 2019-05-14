%"""
%biotracs.core.app.view.Gui
%Gui view object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See biotracs.core.app.model.Gui
%"""

classdef (Abstract) Gui < biotracs.core.mvc.view.BaseObject
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function this = Gui()
            this@biotracs.core.mvc.view.BaseObject();
        end
        
        %-- A --
        
        %-- G --
        
        %-- O --

        %-- V --
        
        function this = viewHtml( this )
            error('Not yet available');
        end

    end
    
    
    methods(Abstract)
        this = viewGui( this );
    end
    
end
