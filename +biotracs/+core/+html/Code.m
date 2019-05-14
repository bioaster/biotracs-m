%"""
%biotracs.core.html.Code
%Code object allows manipulating and creating html code elements. A code text is not executed. 
%It is only displayed with code formatting.
%of contents for example.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Span, biotracs.core.html.Script
%"""

classdef Code < biotracs.core.html.DomContainer
    
    methods
        
        function this = Code( iText )
            this@biotracs.core.html.DomContainer();
            this.tagName = 'code';
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

