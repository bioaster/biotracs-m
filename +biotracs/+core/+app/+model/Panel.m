%"""
%biotracs.core.app.model.Panel
%Graphical user panel. A Panel is a flat square used to gather a set of Control elements.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See biotracs.core.app.view.Panel
%"""

classdef Panel < biotracs.core.app.model.UIHolder
    
    properties(SetAccess = protected)
    end
    
    events
        submit;
    end
    
    methods
        
        function this = Panel( varargin )
            this@biotracs.core.app.model.UIHolder( varargin{:} );
            this.bindView( biotracs.core.app.view.Panel() );
            
            if isempty(this.position)
                this.position = [ 10, 10, this.parent.width()-20, this.parent.height()-20 ];
            end
            this.name = 'MyPanel';
        end
        
        %-- N --
        
        %-- V --
        
    end
    
end