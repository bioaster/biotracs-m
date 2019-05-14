%"""
%biotracs.core.html.Card
%Card object allows manipulating and creating panels. A card is composed of a header, footer,
%title and body text.
%of contents for example.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Div
%"""

classdef Card < biotracs.core.html.Div
    
    properties(SetAccess = protected)
        header = '';
        title = '';
        subtitle = '';
        footer = '';
    end
    
    methods
        
        function this = Card( varargin )
            this@biotracs.core.html.Div( varargin{:} );
            this.attributes = struct(...
                'class', 'card border-light bg-light' ...
            );
        end
        
        function this = setHeader( this, text )
            this.header = text;
        end
        
        function this = setFooter( this, text )
            this.footer = text;
        end
        
        function this = setTitle( this, text )
            this.title = text;
        end
        
        function this = setSubtitle( this, text )
            this.subtitle = text;
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
                    openingTag = [ openingTag, ' ', attrNames{i}, '="', attr.(attrNames{i}), '"' ];
                end
            end
            openingTag = [openingTag, ' id="',this.uid,'">'];
            
            html = '';
            for i=1:getLength( this.children )
                html = strcat( html, this.children.getAt(i).generateHtml() );
            end
            
            headerHtml = '';
            if ~isempty(this.header)
                headerHtml = ['<div class="card-header">',this.header,'</div>'];
            end
            
            footerHtml = '';
            if ~isempty(this.footer)
                footerHtml = ['<div class="card-footer">',this.footer,'</div>'];
            end
            
            titleHtml = '';
            if ~isempty(this.title)
                titleHtml = ['<h4 class="card-title">',this.title,'</h4>'];
            end
            
            subtitleHtml = '';
            if ~isempty(this.subtitle)
                subtitleHtml = ['<h6 class="card-subtitle text-muted">',this.subtitle,'</h6>'];
            end

            bodyHtml = [...
                '<div class="card-body">', ...
                    titleHtml, subtitleHtml, ...
                    '<div class="card-text">', ...
                        this.text, ...
                        html, ...
                     '</div>', ...
                '</div>' ...
                ];
            
            %create doc html
            html = [ openingTag, headerHtml, bodyHtml, footerHtml, closingTag ];
        end

    end
    
end

