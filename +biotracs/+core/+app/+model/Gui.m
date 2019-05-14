%"""
%biotracs.core.app.model.Gui
%Graphical user interface model. A Gui object can contains any Control
%objects manipulated by the user. It is controlled by the Gui Controller
%(biotracs.core.app.controller.Gui).
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See biotracs.core.app.view.Gui, biotracs.core.app.controller.Gui
%"""

classdef (Abstract) Gui < biotracs.core.mvc.model.BaseObject
    
    properties(SetAccess = protected)
        parent;
        children;
        name = 'MyBioapp';
        position;
        units = 'pixels';
        fontSize = 8;
        string = '';
    end
    
    methods
        
        function this = Gui( varargin )
            this@biotracs.core.mvc.model.BaseObject( );
            %this.bindView( biotracs.core.app.view.Gui );
            
            p = inputParser();
            p.addParameter('Parent', [], @(x)isa(x,'biotracs.core.app.model.Gui'));
            p.addParameter('Name', 'MyGui', @ischar);
            p.addParameter('Position', [], @isnumeric);
            p.addParameter('Units', 'pixels', @ischar);
            p.addParameter('String', 'MyUserText', @ischar);
            p.KeepUnmatched = true;
            p.parse( varargin{:} )
            this.name = p.Results.Name;
            this.position = p.Results.Position;
            this.units = p.Results.Units;
            this.string = p.Results.String;
            this.children = biotracs.core.container.Set(0,'biotracs.core.app.model.Gui');
            
            if ~isempty(p.Results.Parent)
                p.Results.Parent.addChild(this);
            end
        end

        %-- A --
        
        function addChild( this, iChild, iName )
            if nargin <= 2
                this.children.add( iChild );
            else
                this.children.add( iChild, iName );
            end
            iChild.parent = this;
        end
        
        %-- G --
        
        function p = getParent( this )
            p = this.parent;
        end
        
        function c = getChild( this, iName )
            c = this.children.get( iName  );
        end
        
        %-- H --
        
        function tf = hasParent( this )
            tf = isa(this.parent, 'biotracs.core.app.model.Gui');
        end
        
        function tf = hasChildren( this )
            tf = ~isempty(this.children);
        end
        
        %-- S --
        
        function this = setPosition( this, iPosition )
           this.position = iPosition; 
        end

    end
    
end