%"""
%biotracs.core.app.model.ListBox
%Graphical user list box. A ListBox is used to display a list of elements
%that can be chosen by the user.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See biotracs.core.app.view.ListBox
%"""

classdef ListBox < biotracs.core.app.model.Control
    
    properties(SetAccess = protected)
        max;
        change;
    end
    
    events
    end
    
    methods
        
        
        function this = ListBox( varargin )
            this@biotracs.core.app.model.Control( varargin{:} );
            this.bindView( biotracs.core.app.view.ListBox() );
            this.style = 'listbox';
            
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