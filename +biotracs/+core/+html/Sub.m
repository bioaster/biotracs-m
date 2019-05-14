%"""
%biotracs.core.html.Sub
%Sub object creating sub-text (like indexes in mathematics)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Sup
%"""

classdef Sub < biotracs.core.html.DomChild
    
    methods
        
        function this = Sub( iText )
            this@biotracs.core.html.DomChild();
            this.tagName = 'sub';
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

