%"""
%biotracs.core.app.model.Popup
%Graphical popup menu used to display a message (e.g. confirmation or validation message).
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See biotracs.core.app.view.Popup
%"""

classdef Popup < biotracs.core.app.model.Control
    
    properties(SetAccess = protected)
    end
    
    events
        click;
    end
    
    methods
        
        function this = Popup( varargin )
            this@biotracs.core.app.model.Control( varargin{:} );
            this.bindView( biotracs.core.app.view.Popup() );
            this.style = 'popup';
            
            p = inputParser();
            p.addParameter('OnClick', [], @ishandle);
            p.KeepUnmatched = true;
            p.parse( varargin{:} )
            
            if ~isempty(p.Results.OnClick)
                this.addlistener('click', p.Results.OnClick);
            end
            
            if isempty(this.position)
                this.position = [ 10, 10, 200, 100 ];
            end
        end
        
        %-- N --
        
        %-- S --
    end
    
end