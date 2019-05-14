%"""
%biotracs.core.html.Notice
%Notice object creating notice texts.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Text
%"""

classdef Notice < biotracs.core.html.Div
    
    methods
        
        function this = Notice( iText )
            this@biotracs.core.html.Div( iText );
            this.addClass('notice');
            this.addClass('info');
            
            %prepend a title to the text
            if nargin == 1
                %this.text = ['<span class="notice-title">Notice&nbsp;:&nbsp;</span>', this.text];
            end
        end
        
        
        %-- S --
        
        function setStyle( this, iStyle )
            s = {this.STYLE_DANGER, this.STYLE_INFO, this.STYLE_SUCCESS};
            if ~ismember(iStyle, s)
                error('Only styles ''%s'' are allowed', strjoin(s, ''', '''));
            end
            
            for i=1:length(s)
                this.removeClass(['notice-', s{i}]);
            end
            this.addClass(['notice-',iStyle]);
        end
        
    end
    
end

