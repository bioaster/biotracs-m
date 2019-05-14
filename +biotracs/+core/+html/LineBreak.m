%"""
%biotracs.core.html.LineBreak
%LineBreak object allows creating html line break (using br tag)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Line, biotracs.core.html.ParagraphBreak
%"""

classdef LineBreak < biotracs.core.html.DomChild
    
    methods
        
        function this = LineBreak()
            this@biotracs.core.html.DomChild();
            this.tagName = 'br';
        end
        
        %-- A --

    end
    
    methods(Access = protected)
        
        function [ html ] = doGenerateHtml( ~ )
            html = '<br>';
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

