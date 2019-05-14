%"""
%biotracs.core.app.model.Button
%Graphical clickable user button
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See biotracs.core.app.view.Button
%"""

classdef Button < biotracs.core.app.model.Control
    
    properties(SetAccess = protected)
        click;
    end
    
    %events
    %    click;
    %end
    
    methods
        
        function this = Button( varargin )
            this@biotracs.core.app.model.Control( varargin{:} );
            this.bindView( biotracs.core.app.view.Button() );
            this.style = 'pushbutton';
            
            p = inputParser();
            p.addParameter('OnClick', @(x,s,e)([]), @(x)isa(x,'function_handle'));
            p.KeepUnmatched = true;
            p.parse( varargin{:} )
            
            if ~isempty(p.Results.OnClick)
                this.click = p.Results.OnClick;
                %this.addlistener('click', p.Results.OnClick);
            end
            
            if isempty(this.position)
                this.position = [ 10, 10, 100, 50 ];
            end
        end
        
        %-- N --
        
        %-- S --
    end
    
end