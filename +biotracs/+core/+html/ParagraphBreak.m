%"""
%biotracs.core.html.ParagraphBreak
%ParagraphBreak object creating new paragraphs
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.LineBreak
%"""

classdef ParagraphBreak < biotracs.core.html.DomChild
    
    methods
        
        function this = ParagraphBreak()
            this@biotracs.core.html.DomChild();
            this.tagName = 'br';
        end
        
        %-- A --

    end
    
    methods(Access = protected)
        
        function [ html ] = doGenerateHtml( ~ )
            html = '<br><br>';
        end

    end
    
end

