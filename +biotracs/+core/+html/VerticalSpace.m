%"""
%biotracs.core.html.VerticalSpace
%VerticalSpace object manipulating and creating line break space.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Space
%"""


classdef VerticalSpace < biotracs.core.html.DomChild
    
    methods
        
        function this = VerticalSpace( iSize )
            this@biotracs.core.html.DomChild();
            this.tagName = 'div';
            if nargin==1
                iSize = '1rem';
            end
            this.setAttributes( struct('style',['height:', iSize]) );
            this.text = '&nbsp;';
        end
        
        %-- A --
        
    end
    
end

