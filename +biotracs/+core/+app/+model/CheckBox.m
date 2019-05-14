%"""
%biotracs.core.app.model.CheckBox
%Graphical user check box.
%that can be chosen by the user.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See biotracs.core.app.view.CheckBox
%"""


classdef CheckBox < biotracs.core.app.model.Control
    
    properties(SetAccess = protected)
        change;
    end
    
    events   
    end
    
    methods
        
      
        function this = CheckBox( varargin )
            this@biotracs.core.app.model.Control( varargin{:} );
            this.bindView( biotracs.core.app.view.CheckBox() );
            this.style = 'checkbox';
            
            p = inputParser();
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
             
            if isempty(this.position)
                this.position = [ 10, 10, 100, 50 ];
            end
            

        end
        
        
    end
    
end