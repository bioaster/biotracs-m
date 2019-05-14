%"""
%biotracs.core.html.Div
%Div object allows manipulating and creating html div elements
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Span
%"""

classdef Div < biotracs.core.html.DomContainer
    
    methods
        
        function this = Div( iText )
            this@biotracs.core.html.DomContainer();
            this.tagName = 'div';
            if nargin == 1
                if ~ischar(iText)
                    error('BIOTRACS:Html:Div:InvalidArgument', 'The text must be a string');
                end
                this.text = iText;
            end
        end
        
        %-- A --
        
    end
    
end

