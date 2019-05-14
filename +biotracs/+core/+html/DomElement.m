%"""
%biotracs.core.html.DomElement
%Base object that defines a html dom element
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.DomChild, biotracs.core.html.DomContainer 
%"""

classdef (Abstract) DomElement < handle
    
    properties( Constant )
        STYLE_PRIMARY  = 'primary';
        STYLE_SECONDARY = 'secondary';
        STYLE_SUCCESS   = 'success';
        STYLE_DANGER    = 'danger';
        STYLE_WARNING   = 'warning';
        STYLE_INFO      = 'info';
        STYLE_LIGHT     = 'light';
        STYLE_DARK      = 'dark';
        STYLES = {'primary', 'secondary', 'success', 'danger', 'warning', 'info', 'light', 'dark'};
    end
    
    properties(SetAccess = protected)
        uid;
        
        % Tag name of the dom element
        % If it is 'html', then a full html document will be written
        % e.g. 'div', 'span', 'html' ...
        tagName = '';
        
        % Attribute of the tag
        attributes = struct('class', '', 'style', '');			% structure that define the attribute of the tag
        
        % The inner html code of the tag
        text = '';
        style = '';        
    end
    
    methods
        
        function this = DomElement()
            this@handle();
            this.uid = biotracs.core.utils.uuid();
        end

        %-- A --
        
        
        function this = addAttributes( this, iAttributes )
            if isstruct(iAttributes)
                f = lower(fields(iAttributes));
                for i=1:length(f)
                    this.attributes.(f{i}) = strrep(iAttributes.(f{i}),'"','''');
                end
            else
                error('BIOTRACS:Html:DomElement:InvalidArgument', 'Invalid attribute. A struct is required');
            end
        end
        
        function this = addClass( this, iClasses )
            if ischar(iClasses)
                prevClass = this.attributes.('class');
                newClass = lower(iClasses);
                this.attributes.('class') = [prevClass, ' ', newClass];
            else
                error('BIOTRACS:Html:DomElement:InvalidArgument', 'Invalid class values. A string is required');
            end
        end
        
%         function this = addStyle( this, iStyle )
%             if ischar(iStyle)
%                 prevStyle = this.attributes.('style');
%                 newStyle = strrep(iStyle, '"','''');
%                 this.attributes.('style') = [prevStyle, '; ', newStyle];
%             else
%                 error('BIOTRACS:Html:DomElement:InvalidArgument', 'Invalid style values. A string is required');
%             end
%         end
        
        
        %-- G --
        
        function attr = getAttributes( this )
            attr = this.attributes;
        end
        
        function attr = getAttributeByName( this, iAttrName )
            iAttrName = lower(iAttrName);
            if isfield(this.attributes, iAttrName)
                attr = this.attributes.(iAttrName);
            else
                attr = '';
            end
        end
        
        function h = getText( this )
            h = this.text;
        end
        
        %-- R --

        function this = removeClass( this, iClasses )
            if ischar(iClasses)
                iClasses = lower(iClasses);
                prevClass = this.attributes.('class');
                this.attributes.('class') = regexprep(  prevClass, ['(\s',iClasses,')|(',iClasses,'\s)|','^',iClasses,'$'], '');
            else
                error('BIOTRACS:Html:DomElement:InvalidArgument', 'Invalid class values. A string is required');
            end
        end
        
        %-- S --
       
        function this = setTagName( this, iTagName )
            if ~ischar(iTagName)
                error('BIOTRACS:Html:DomElement:InvalidArgument', 'The tag name must be a string')
            end
            this.tagName = iTagName;
        end
        
        function this = setAttributes( this, iAttributes )
            if isstruct(iAttributes)
                f = lower(fields(iAttributes));
                for i=1:length(f)
                    iAttributes.(f{i}) = strrep(iAttributes.(f{i}),'"','''');
                end
                this.attributes = iAttributes;
            else
                error('BIOTRACS:Html:DomElement:InvalidArgument', 'Invalid attribute');
            end
        end

        function this = setText( this, iText )
            if ~ischar(iText)
                error('BIOTRACS:Html:DomElement:InvalidArgument', 'The text must be a string');
            end
            this.text = iText;
        end
        
        function setStyle( this, iStyle )
            if ~ismember(iStyle, this.STYLES)
                error('BIOTRACS:Html:DomElement:InvalidArgument', 'The style is invalid. Valid styles are {''%s''}', strjoin(this.STYLES,''','''));
            end
            this.style = iStyle;
        end
        
        %-- W --
        
        function html = generateHtml( this, varargin )
            html = this.doGenerateHtml( varargin{:} ); 
        end
        
    end
    
    methods(Access = protected)
        
        function [ html ] = doGenerateHtml( this )
            openingTag = ['<',this.tagName ];
            closingTag = ['</',this.tagName,'>'];
            %write attributes
            attr = this.getAttributes();
            if ~isempty(attr)
                attrNames = fields(attr);
                for i=1:length(attrNames)
                    openingTag = [ openingTag, ' ', attrNames{i}, '="', strrep(attr.(attrNames{i}),'"', ''''), '"' ];
                end
            end
            openingTag = [openingTag, '>'];

            %create doc html
            html = [ openingTag, this.text, closingTag ];
        end
    end
    
end

