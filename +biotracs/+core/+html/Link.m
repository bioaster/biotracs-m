%"""
%biotracs.core.html.Link
%Link object allows creating links using html anchors
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%"""

classdef Link < biotracs.core.html.DomContainer
    
    properties
    end
    
    methods
        
        function this = Link( iHref, iText )
            this@biotracs.core.html.DomContainer();
            this.tagName = 'a';
            if nargin >= 1
               this.setHref(iHref); 
            end
            if nargin >= 2
               this.text = iText; 
            end
        end
        
        %-- A --

        function setHref( this, iSrc )
            this.addAttributes( struct('href', iSrc) );
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
            openingTag = [openingTag, '>'];
            
            html = '';
            for i=1:getLength( this.children )
                html = strcat( html, this.children.getAt(i).generateHtml() );
            end
            
            %create doc html
            html = [ openingTag, this.text,  html, closingTag ];
        end

    end
    
end

