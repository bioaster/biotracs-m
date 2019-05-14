%"""
%biotracs.core.html.NavDoc
%NavDoc object is a type of Doc object used to create navigation links
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.core.html.Doc
%"""


classdef NavDoc < biotracs.core.html.Doc
    
    properties(SetAccess = protected)
    end
    
    properties(SetAccess = protected)
        url;
    end
    
    
    methods
        
        function this = NavDoc()
            this@biotracs.core.html.Doc();
            this.tagName = 'html';
            this.addClass('navdoc-card');
        end
        
        %-- A --
  
        %-- G --
      
        %-- S --
        
    end
    
    methods(Access = protected)
        
%         function [ oHtml ]= doGenerateBodyHtml( this )
%             oHtml = '<div class="row">';
%             for i=1:getLength(this.children)
%                 child = this.children.getAt(i);
%                 if isa( child, 'biotracs.core.html.NavDoc' )
%                     child.doGenerateHtml();
%                     oHtml = child.doGenerateIdCardHtml();
%                 else
%                     oHtml = strcat( oHtml, child.doGenerateHtml() );
%                 end
%                 
%             end
%             oHtml = strcat(oHtml, '</div>');            
%         end
        
    end
    
end

