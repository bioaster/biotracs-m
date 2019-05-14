%"""
%biotracs.core.html.Body
%Body object allows manipulating and creating the html body of a doc element
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Doc, biotracs.core.html.DomContainer
%"""

classdef Body < biotracs.core.html.DomContainer
    
    methods
        
        function this = Body( iText )
            this@biotracs.core.html.DomContainer();
            this.tagName = 'body';
            if nargin == 1
               this.text = iText; 
            end
        end
        
        %-- A --

    end
    
end

