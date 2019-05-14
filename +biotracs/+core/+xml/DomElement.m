%"""
%biotracs.core.xml.DomElement
%Xml dom element object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%"""

classdef DomElement < handle
    
    properties(SetAccess = protected)
        dom;
        length = 0;
        cursor = -1;
    end
    
    methods
        
        function this = DomElement( dom )
            this@handle();
            if nargin == 1
                this.dom = dom;
                if dom.hasChildNodes()
                    childNodes = dom.getChildNodes();
                    this.length = childNodes.getLength();
                end
            end
        end
        
        %-- G --
        
        function name = getName( this )
            name = char(this.dom.getNodeName());
        end
        
        function attributes = getAttributes( this )
            if ~this.dom.hasAttributes
                attributes = struct('Name', cell(1, 0), 'Value', cell(1, 0)); 
                return;
            end
            theAttributes = this.dom.getAttributes();
            numAttributes = theAttributes.getLength();
            %allocCell = cell(1, numAttributes);
            %attributes = struct('Name', allocCell, 'Value', ...
            %    allocCell);
            attributes = containers.Map('KeyType','char','ValueType','char');
            for count = 1:numAttributes
                attrib = theAttributes.item(count-1);
                attributes(char(attrib.getName)) = char(attrib.getValue);
                %attributes(count).Name = char(attrib.getName);
                %attributes(count).Value = char(attrib.getValue);
            end
        end
        
        function data = getData( this )
            if this.isText()
                data = deblank(char(this.dom.getData()));
            else
                data = '';
            end
        end
        
        %-- I --
        
        function tf = isText( this )
           tf = strcmp(this.getName(), '#text'); 
        end
        
        function tf = isBlankText( this )
            tf = this.isText() && isempty(char(this.getData()));
        end
        
        %-- G --

        function oLength = getLength( this )
            oLength = this.length;
        end
        
        function child = getFirstChild( this, iNodeName )
            theChild = this.dom.getFirstChild();
            ok = false;
            while ~isempty(theChild) && ~ok
                ok = nargin == 1 || strcmp(theChild.getNodeName(), iNodeName);
                if ok, break; end
                theChild = theChild.getNextSibling();
            end
            if ok
                child = biotracs.core.xml.DomElement( theChild );
            else
                child = biotracs.core.xml.DomElement.empty();
            end
        end
        
        function prev = getPrev( this, iNodeName )
            ok = false;
            theChild = this.dom.getPreviousSibling();
            while ~isempty(theChild) && ~ok
                ok = nargin == 1 || strcmp(theChild.getNodeName(), iNodeName);
                if ok, break; end
                theChild = this.dom.getPreviousSibling();
            end
            
            if ok
                prev = biotracs.core.xml.DomElement( theChild );
            else
                prev = biotracs.core.xml.DomElement.empty();
            end
        end
        
        function next = getNext( this, iNodeName )
            ok = false;
            theChild = this.dom.getNextSibling();
            while ~isempty(theChild) && ~ok
                ok = nargin == 1 || strcmp(theChild.getNodeName(), iNodeName);
                if ok, break; end
                theChild = this.dom.getNextSibling();
            end
            
            if ok
                next = biotracs.core.xml.DomElement( theChild );
            else
                next = biotracs.core.xml.DomElement.empty();
            end
        end
        
        %-- P --

        function nodeStruct = parseAsStruct( this )
            if this.isBlankText()
                nodeStruct = struct( ...
                    'Name', this.getName(), ...
                    'Attributes', this.getAttributes(),  ...
                    'Data', this.getData(), ...
                    'Children', []);
            else
                n = this.getLength();
                allocCell = cell(1, n);
                children = struct(...
                    'Name', allocCell, ...
                    'Attributes', allocCell,    ...
                    'Data', allocCell, ...
                    'Children', allocCell);
                
                theChild = this.getFirstChild();
                cpt = 1;
                while ~isempty(theChild)
                    if ~theChild.isBlankText()
                        children(cpt) = theChild.parseAsStruct();
                        cpt = cpt+1;
                    end
                    theChild = theChild.getNext();
                end
                children(cpt:end) = [];
                nodeStruct = struct( ...
                    'Name', this.getName(), ...
                    'Attributes', this.getAttributes(),  ...
                    'Data', this.getData(), ...
                    'Children', children);
            end
        end
        
        %-- R --
        
        function resetCursor( this )
            this.cursor = -1;
        end
        
        %-- S --

        
    end
    
    methods(Access = protected)
        
    end
    
    methods( Static )
        
    end
    
end

