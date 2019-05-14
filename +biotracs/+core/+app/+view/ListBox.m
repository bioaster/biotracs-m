%"""
%biotracs.core.app.view.ListBox
%ListBox view object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See biotracs.core.app.model.ListBox
%"""

classdef ListBox < biotracs.core.app.view.Control
    
    properties(SetAccess = protected)
        
    end
    
    methods
        
        function this = ListBox()
            this@biotracs.core.app.view.Control();
        end
        
        %-- V --
        
        function this = viewGui( this )
            this.viewGui@biotracs.core.app.view.Control();
            this.handle.Max = this.model.max;
        end
    end
    
end