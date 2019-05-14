%"""
%biotracs.core.app.view.Input
%Input view object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See biotracs.core.app.model.Input
%"""

classdef Input < biotracs.core.app.view.Control
    
    properties(SetAccess = protected)
        
    end
    
    methods
        
        function this = Input()
            this@biotracs.core.app.view.Control();
        end
        
        %-- V --
        
        function this = viewGui( this )
            this.viewGui@biotracs.core.app.view.Control();
            this.handle.Max = this.model.max;
        end
    end
    
end