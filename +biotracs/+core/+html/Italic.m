%"""
%biotracs.core.html.Italic
%Italic object allows manipulating and creating italic texts
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Text, biotracs.core.html.Strong 
%"""

classdef Italic < biotracs.core.html.DomContainer
    
    methods
        
        function this = Italic( iText )
            this@biotracs.core.html.DomContainer();
            this.tagName = 'em';
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

