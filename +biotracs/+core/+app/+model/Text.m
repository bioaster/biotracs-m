%"""
%biotracs.core.app.model.Text
%Graphical radio (exclusive choices buttons)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See biotracs.core.app.view.Text
%"""

classdef Text < biotracs.core.app.model.Control
    
    properties(SetAccess = protected)
        
    end
    
    events
        change;
    end
    
    methods
        
      
        function this = Text( varargin )
            this@biotracs.core.app.model.Control( varargin{:} );
            this.bindView( biotracs.core.app.view.Text() );
            this.style = 'text';
            
            if isempty(this.position)
                this.position = [ 10, 10, 100, 50 ];
            end
        end
        
        
    end
    
end