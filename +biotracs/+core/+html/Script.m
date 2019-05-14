%"""
%biotracs.core.html.Script
%Script object creating new script blocks (using script tag). A script block is an executable JavaScript code. 
%Use `biotracs.core.html.Code` object to display code.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2018
%* See: biotracs.core.html.Code
%"""

classdef Script < biotracs.core.html.DomContainer
    
    methods
        
        function this = Script( iText )
            this@biotracs.core.html.DomContainer();
            this.tagName = 'script';
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

