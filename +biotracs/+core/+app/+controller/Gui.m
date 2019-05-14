%"""
%biotracs.core.app.controller.Gui
%Base Controller of graphical user interfaces
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.app.model.Gui, biotracs.core.app.view.Gui
%"""

classdef Gui < biotracs.core.mvc.controller.Controller
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function this = Gui()
            this@biotracs.core.mvc.controller.Controller();
        end
        
        %-- A --

    end
    
end