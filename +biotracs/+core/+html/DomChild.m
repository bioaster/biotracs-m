%"""
%biotracs.core.html.DomChild
%Base object that defines child html dom elements. A DomContainer is composed of several DomChild objects.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.DomElement, biotracs.core.html.DomContainer
%"""

classdef (Abstract) DomChild < biotracs.core.html.DomElement
    
    properties
        parent;
    end
    
    methods
        
        function this = DomChild()
            this@biotracs.core.html.DomElement();
        end
        
        %-- S --

        function this = setParent( this, iParent )
            if ~isempty(this.parent)
                error('BIOTRACS:Html:DomChild:ParentAlreadyDefined', 'A parent container is already defined');
            end
            if ~isa(iParent, 'biotracs.core.html.DomContainer')
                error('BIOTRACS:Html:DomChild:InvalidArgument', 'The parent must be a biotracs.core.html.DomContainer');
            end
            this.parent = iParent;
        end
    end
    
end

