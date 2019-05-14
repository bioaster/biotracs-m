%"""
%biotracs.core.app.model.DropDownMenu
%Graphical and clickable drop down menu
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See biotracs.core.app.view.DropDownMenu
%"""

classdef DropDownMenu < biotracs.core.app.model.Control
    
    properties(SetAccess = protected)
        change;
    end
    
    events   
    end
    
    methods
        
      
        function this = DropDownMenu( varargin )
            this@biotracs.core.app.model.Control( varargin{:} );
            this.bindView( biotracs.core.app.view.DropDownMenu() );
            this.style = 'popumenu';
            
            p = inputParser();
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
             
            if isempty(this.position)
                this.position = [ 10, 10, 100, 50 ];
            end
            

        end
        
        
    end
    
end