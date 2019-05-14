%"""
%biotracs.core.html.Accordion
%Accordion object allows manipulating and creating html accordions to display several sliding items
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.AccordionItem
%"""

classdef Accordion < biotracs.core.html.DomContainer
     
    methods
        
        function this = Accordion( varargin )
            this@biotracs.core.html.DomContainer( varargin{:} );
            this.children = biotracs.core.container.Set(0, 'biotracs.core.html.AccordionItem');
            this.tagName = 'div';
            this.addClass('accordion-bar');
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
            openingTag = [openingTag, ' id="',this.uid,'" >'];
            
            html = '';
            for i=1:getLength( this.children )
                html = strcat( html, this.children.getAt(i).generateHtml() );
            end
            html = ['<div data-children=".item">',html,'</div>'];
            
            html = [ openingTag, html, closingTag ];
        end

    end
    
end

