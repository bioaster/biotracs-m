%"""
%biotracs.core.html.SiteMap
%SiteMap object allows manipulating and creating a website map. The map is an accordion of which each items refers the the pages of the website.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2018
%* See: biotracs.core.html.Doc, biotracs.core.html.Website, biotracs.core.html.Accordion, biotracs.core.html.AccordionItem
%"""

classdef SiteMap < biotracs.core.html.DomContainer
    
    methods
        
        function this = SiteMap( )
            this@biotracs.core.html.DomContainer();
            this.children = biotracs.core.container.Set(0, 'biotracs.core.html.SiteMap');
        end
        
        %-- A --
        
    end
    
    methods(Access = protected)
        
        function [ oHtml ]= doGenerateHtml( this )
            if this.children.isEmpty() && isempty(this.text)
                oHtml = '<p>No site map defined</p>';
                return;
            end
            
            accordion = biotracs.core.html.Accordion();
            accordion.removeClass('accordion-bar');
            
            myFillAccordion( this, accordion );
            oHtml = accordion.doGenerateHtml();
            
            function myFillAccordion( iNode, iAccordion )
                item = biotracs.core.html.AccordionItem(iNode.text);
                if getLength(iNode) > 0
                    item.setType(item.TYPE_PLUS);
                else
                    item.setType(item.TYPE_NONE);
                end
                iAccordion.append(item);
                
                for i=1:getLength(iNode)
                    subAccordion = biotracs.core.html.Accordion();
                    subAccordion.removeClass('accordion-bar')...
                        .addClass('accordion-left-border');
                    myFillAccordion( iNode.getAt(i), subAccordion );
                    
                    div = biotracs.core.html.Div();
                    div.append(subAccordion);
                    item.append(div);
                end
            end
        end
        
    end
end

