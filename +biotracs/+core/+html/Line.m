%"""
%biotracs.core.html.Line
%Line object allows manipulating and creating html line (using hr tag)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.LineBreak
%"""

classdef Line < biotracs.core.html.DomChild
    
    methods
        
        function this = Line()
            this@biotracs.core.html.DomChild();
            this.tagName = 'hr';
        end
        
        %-- A --

    end
    
    methods(Access = protected)
        
        function [ html ] = doGenerateHtml( ~ )
            html = '<hr>';
        end
        
%         function [ html ] = doGenerateHtml( this )
%             openingTag = ['<',this.tagName ];
%             %write attributes
%             attr = this.getAttributes();
%             if ~isempty(attr)
%                 attrNames = fields(attr);
%                 for i=1:length(attrNames)
%                     openingTag = [ openingTag, ' ', attrNames{i}, '="', attr.(attrNames{i}), '"' ];
%                 end
%             end
%             html = [openingTag, '>'];
%         end

    end
    
end

