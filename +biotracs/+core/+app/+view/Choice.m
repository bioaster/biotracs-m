%"""
%biotracs.core.app.view.Choice
%Choice view object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See biotracs.core.app.model.Choice
%"""

classdef Choice < biotracs.core.app.view.Panel
    
    properties(SetAccess = protected)
        
    end
    
    methods
        
        function this = Choice()
            this@biotracs.core.app.view.Panel();
        end
        
        %-- V --
        
        function this = viewGui( this )
             this.viewGui@biotracs.core.app.view.UIHolder();
        end
    end
    
end