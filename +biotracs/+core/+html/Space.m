%"""
%biotracs.core.html.Space
%Space object creating between-text spaces.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.VerticalSpace
%"""

classdef Space < biotracs.core.html.DomContainer
    
    methods
        
        function this = Space( iNbSpaces )
            this@biotracs.core.html.DomContainer();
            this.tagName = 'span';
            if nargin == 0
                iNbSpaces = 1;
            end
            this.text = repmat('&nbsp;',1,iNbSpaces);
        end
        
        %-- A --
        
    end
    
end

