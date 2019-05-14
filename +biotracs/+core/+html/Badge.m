%"""
%biotracs.core.html.Badge
%Badge object allows manipulating and creating colored (inline) html elements in order to highlight important texts
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Div, biotracs.core.html.Span
%"""

classdef Badge < biotracs.core.html.Span
    
    methods
        
        function this = Badge( iText )
            this@biotracs.core.html.Span();
            this.tagName = 'span';
            if nargin == 1
                if ~ischar(iText)
                    error('BIOTRACS:Html:Div:InvalidArgument', 'The text must be a string');
                end
                this.text = iText;
            end
            this.addClass('badge');
            this.addClass('badge-info');
        end
        
        %-- S --
        
        function setStyle( this, iStyle )
            for i=1:length(this.STYLES)
                this.removeClass(['badge-', this.STYLES{i}]);
            end
            this.addClass(['badge-', iStyle]);
        end
        
    end
    
end

