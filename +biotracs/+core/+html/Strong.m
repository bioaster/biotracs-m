%"""
%biotracs.core.html.Strong
%Strong object allows manipulating and creating bold texts
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Text, biotracs.core.html.Italic 
%"""

classdef Strong < biotracs.core.html.DomContainer
    
    methods
        
        function this = Strong( iText )
            this@biotracs.core.html.DomContainer();
            this.tagName = 'strong';
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

