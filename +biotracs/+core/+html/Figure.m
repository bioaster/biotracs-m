%"""
%biotracs.core.html.Figure
%Figure object allows manipulating and creating figures (based on image files)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.core.html.Table 
%"""

classdef Figure < biotracs.core.html.DomChild
    
    properties(SetAccess = protected)
        caption = '';
        src = '';
        alt = '';
    end
    
    methods
        
        function this = Figure( iSrc, iCaption )
            this@biotracs.core.html.DomChild();
            this.tagName = 'figure';
            this.attributes = struct(...
                'class', 'figure' ...
                );
            if nargin >= 1
                this.src = iSrc;
            end
            if nargin >= 2
                this.caption = iCaption;
            end
        end
        
        %-- A --

        %-- G --

        %-- S --
        
        function this = setCaption( this, iCaption )
            this.caption = iCaption;
        end
        
        function this = setSrc( this, iSrc )
            this.src = iSrc;
        end
        
        function this = setAlt( this, iAlt )
            this.alt = iAlt;
        end
        
    end
    
    methods(Access = protected)
        
        function [ html ] = doGenerateHtml( this )
            captionHtml = ['<figcaption class="figure-caption">',this.caption,'</figcaption>'];
            imgHtml = ['<img src="',this.src,'" class="figure-img img-fluid rounded" alt="',this.alt,'">'];
            
            openingTag = ['<',this.tagName ];
            closingTag = ['</',this.tagName,'>'];
            %write attributes
            attr = this.getAttributes();
            if ~isempty(attr)
                attrNames = fields(attr);
                for i=1:length(attrNames)
                    openingTag = [ openingTag, ' ', attrNames{i}, '="', attr.(attrNames{i}), '"' ];
                end
            end
            openingTag = [openingTag, ' id="',this.uid,'" >'];
            html = [ openingTag, imgHtml, captionHtml, closingTag ];
        end
        
       
    end
    
end

