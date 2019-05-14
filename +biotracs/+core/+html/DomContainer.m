%"""
%biotracs.core.html.DomContainer
%Base object that defines html containers. A DomContainer is composed of several DomChild objects. 
%Because any DomContainer can be a child of another DomContainer, this class inherits the DomChild class.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.DomElement, biotracs.core.html.DomChild
%"""

classdef (Abstract) DomContainer < biotracs.core.html.DomChild
    
    properties(SetAccess = protected)
        children;
    end
    
    methods
        
        function this = DomContainer()
            this@biotracs.core.html.DomChild();
            this.children = biotracs.core.container.Set(0, 'biotracs.core.html.DomChild');
        end
        
        %-- A --
        
        function [ this ] = append( this, iChild, varargin)
            this.children.add(iChild, varargin{:});
            iChild.setParent(this);
        end
        
        function child = appendBadge( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Badge' )
                child = varargin{1};
            else
                child = biotracs.core.html.Badge( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendBookmark( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Bookmark' )
                child = varargin{1};
            else
                child = biotracs.core.html.Bookmark( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendCard( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Card' )
                child = varargin{1};
            else
                child = biotracs.core.html.Card( varargin{:} );
            end            
            this.append(child);
        end
        
        function child = appendCode( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Code' )
                child = varargin{1};
            else
                child = biotracs.core.html.Code( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendDiv( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Div' )
                child = varargin{1};
            else
                child = biotracs.core.html.Div( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendItalic( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Italic' )
                child = varargin{1};
            else
                child = biotracs.core.html.Italic( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendFigure( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Figure' )
                child = varargin{1};
            else
                child = biotracs.core.html.Figure( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendGrid( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Grid' )
                child = varargin{1};
            else
                child = biotracs.core.html.Grid( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendHeading( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Heading' )
                child = varargin{1};
            else
                child = biotracs.core.html.Heading( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendLine( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Line' )
                child = varargin{1};
            else
                child = biotracs.core.html.Line( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendList( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.List' )
                child = varargin{1};
            else
                child = biotracs.core.html.List( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendLineBreak( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.LineBreak' )
                child = varargin{1};
            else
                child = biotracs.core.html.LineBreak( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendLink( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Link' )
                child = varargin{1};
            else
                child = biotracs.core.html.Link( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendNotice( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Notice' )
                child = varargin{1};
            else
                child = biotracs.core.html.Notice( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendParagraphBreak( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.ParagraphBreak' )
                child = varargin{1};
            else
                child = biotracs.core.html.ParagraphBreak( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendSpace( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Space' )
                child = varargin{1};
            else
                child = biotracs.core.html.Space( varargin{:} );
            end
            this.append(child);
        end
        
        
        function child = appendSpan( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Span' )
                child = varargin{1};
            else
                child = biotracs.core.html.Span( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendSub( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Sub' )
                child = varargin{1};
            else
                child = biotracs.core.html.Sub( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendSup( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Sup' )
                child = varargin{1};
            else
                child = biotracs.core.html.Sup( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendTable( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Table' )
                child = varargin{1};
            else
                child = biotracs.core.html.Table( varargin{:} );
            end
            this.append(child);
        end
        
        function child = appendVerticalSpace( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.VerticalSpace' )
                child = varargin{1};
            else
                child = biotracs.core.html.VerticalSpace( varargin{:} );
            end
            this.append(child);
        end

        function child = appendText( this, varargin )
            if nargin >= 2 && isa( varargin{1}, 'biotracs.core.html.Text' )
                child = varargin{1};
            else
                child = biotracs.core.html.Text( varargin{:} );
            end
            this.append(child);
        end
        
        %-- G --
      
        function n = getLength( this )
            n = this.children.getLength();
        end
        
        function child = get( this, iName )
            child = this.children.get(iName);
        end
        
        function child = getAt( this, iIndexes )
            child = this.children.getAt(iIndexes);
        end
        
        function html = generateHtml( this, varargin )
            html = this.doGenerateHtml( varargin{:} );
        end
        
        %-- H --
        
        function tf = hasElement( this, iIndexesOrName )
            tf = this.children.hasElement(iIndexesOrName);
        end
        
        %-- I --
        
        function tf = isEmpty( this )
            tf = this.children.isEmpty();
        end
        
        %-- R --
        
        function remove( this, varargin )
            this.children.remove( varargin );
        end
        
        function reset( this, varargin )
            this.children = biotracs.core.container.Set(0, 'biotracs.core.html.DomChild');
        end
        
        %-- S --
     
        function summary(this, varargin)
            disp(this);
            this.children.summary( varargin{:} );
        end
        
        function this = sortChildrenByText(this)
           n = this.children.getLength();
           textList = cell(1,n);
           for i=1:n
               textList{i} = this.children.getAt(i).getText();
           end
           [~, idx] = sort( textList );
           this.children.setElements( this.children.elements(idx), this.children.elementNames(idx) );
        end
    end
    
    methods(Access = protected)
        
        function [ html ] = doGenerateIdCardHtml( this )
            html = '';
        end
        
        function [ html ] = doGenerateHtml( this )
            html = '';
            tocExists = false;
            for i=1:getLength( this.children )
                child = this.children.getAt(i);
                if isa( child, 'biotracs.core.html.Doc' )
                    html = strcat( html, child.doGenerateIdCardHtml() );
                else
                    html = strcat( html, child.doGenerateHtml() );
                end
                tocExists = tocExists || isa( child, 'biotracs.core.html.Toc' );
            end
            
            openingTag = ['<',this.tagName ];
            closingTag = ['</',this.tagName,'>'];
            %write attributes
            attr = this.getAttributes();
            if ~isempty(attr)
                attrNames = fields(attr);
                for i=1:length(attrNames)
                    openingTag = [ openingTag, ' id="',this.uid,'" ', attrNames{i}, '="', attr.(attrNames{i}), '"' ];
                end
            end
            if tocExists
                openingTag = [openingTag, 'data-spy="scroll" data-target="#',this.uid,'" data-offset="0"'];
            end
            
            openingTag = [openingTag, '>'];
            
            %create doc html
            html = [ openingTag, this.text,  html, closingTag ];
        end
    end
    
end

