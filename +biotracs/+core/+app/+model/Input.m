%"""
%biotracs.core.app.model.Input
%Graphical user input. The Input is used to store user data (text, number,
%...) in the user forms.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See biotracs.core.app.view.Input
%"""

classdef Input < biotracs.core.app.model.Control
    
    properties(SetAccess = protected)
        max;
        change;
    end
    
    events   
    end
    
    methods
        
      
        function this = Input( varargin )
            this@biotracs.core.app.model.Control( varargin{:} );
            this.bindView( biotracs.core.app.view.Input() );
            this.style = 'edit';
            
            p = inputParser();
            p.addParameter('Max', 1);
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
             
            if isempty(this.position)
                this.position = [ 10, 10, 100, 50 ];
            end
            
            if isempty(this.max)
                this.max = p.Results.Max;
            end
        end
        
        
    end
    
end