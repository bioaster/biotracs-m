%"""
%biotracs.core.app.model.Radio
%Graphical radio (exclusive choices buttons)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See biotracs.core.app.view.Radio
%"""

classdef Radio < biotracs.core.app.model.Control
    
    properties(SetAccess = protected)
        change;
    end
    
    events   
    end
    
    methods
        
      
        function this = Radio( varargin )
            this@biotracs.core.app.model.Control( varargin{:} );
            this.bindView( biotracs.core.app.view.Radio() );
            this.style = 'radio';
            
            %p = inputParser();
            %p.KeepUnmatched = true;
            %p.parse( varargin{:} );
             
            if isempty(this.position)
                this.position = [ 10, 10, 100, 50 ];
            end
            

        end
        
        
    end
    
end