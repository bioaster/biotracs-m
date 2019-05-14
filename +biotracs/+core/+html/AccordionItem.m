%"""
%biotracs.core.html.AccordionItem
%Accordion item
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Accordion
%"""

classdef AccordionItem < biotracs.core.html.Div
    
    properties(Constant)
        TYPE_NONE = 'none';
        TYPE_ARROW = 'arrow';
        TYPE_PLUS = 'plus';
        TYPES = {biotracs.core.html.AccordionItem.TYPE_NONE, biotracs.core.html.AccordionItem.TYPE_ARROW, biotracs.core.html.AccordionItem.TYPE_PLUS};
    end

    properties(SetAccess = protected)
        title;
        showTitleAsLink = false;
    end
    
    methods
        
        function this = AccordionItem( iTitle )
            this@biotracs.core.html.Div();
            this.title = iTitle;
            this.addClass('item');
            this.addClass('accordion-item-plus');
        end
        
        function this = setType( this, iType)
            if ~ismember(iType, this.TYPES)
                error('BIOTRACS:AccordionItem:InvalidType', 'Invalid type. Valid types are ''%s''', strjoin(this.TYPES, ''','''));
            end
            for i=1:length(this.TYPES)
                this.removeClass(['accordion-item-', this.TYPES{i}]);
            end
            this.addClass(['accordion-item-', iType]);
        end
        
        function this = setParent( this, iParent )
            if ~isa(iParent, 'biotracs.core.html.Accordion')
                error('BIOTRACS:Html:AccordionItem:InvalidArgument', 'The parent must be a biotracs.core.html.Accordion');
            end
            this.setParent@biotracs.core.html.Div( iParent );
        end
        
    end
    
    methods(Access = protected)
        
        function [ html ] = doGenerateHtml( this )
            if isempty(this.parent)
                error('BIOTRACS:Html:AccordionItem:NoParentDefined', 'No parent accordion defined');
            end
            
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
            
            html = [...
                '<a class="accordion-item-title" data-toggle="collapse" data-parent="#',this.parent.uid,'" href="#',this.uid,'-item" aria-expanded="true" aria-controls="',this.uid,'">',...
                    this.title,...
                '</a>',...
                '<div id="',this.uid,'-item" class="collapse accordion-item-container" role="tabpanel" style="">', ...
                    this.text, ...
                    html, ...
                '</div>', ...
                ];
           
            %create doc html
            html = [ openingTag, html, closingTag ];
        end

    end
    
end

