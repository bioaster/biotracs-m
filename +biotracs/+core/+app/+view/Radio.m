%"""
%biotracs.core.app.view.Radio
%Radio view object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See biotracs.core.app.model.Radio
%"""

classdef Radio < biotracs.core.app.view.Control
    
      
    properties(SetAccess = protected)
        
    end
    
    methods
        
        function this = Radio()
            this@biotracs.core.app.view.Control();
        end
        
        %-- V --
        
        function this = viewGui( this )
            this.viewGui@biotracs.core.app.view.Control();
        end
    end
    
end