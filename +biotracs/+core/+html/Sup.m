%"""
%biotracs.core.html.Sup
%Sup object creating sup-text (like exponents in mathematics)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Sub
%"""

classdef Sup < biotracs.core.html.DomChild
    
    methods
        
        function this = Sup( iText )
            this@biotracs.core.html.DomChild();
            this.tagName = 'sup';
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

