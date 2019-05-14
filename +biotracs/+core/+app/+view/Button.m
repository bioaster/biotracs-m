%"""
%biotracs.core.app.view.Button
%Button view object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See biotracs.core.app.model.Button
%"""

classdef Button < biotracs.core.app.view.Control
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function this = Button()
            this@biotracs.core.app.view.Control();
        end
        
        %-- V --
        
        function this = viewGui( this )
            this.viewGui@biotracs.core.app.view.Control();
            this.handle.Callback = this.model.click;
        end
    end
    
end
