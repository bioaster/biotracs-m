%"""
%biotracs.core.html.Bookmark
%Bookmark object allows creating tags corresponding to headings (h1,h2, ..., h6). Tags are used to create table of contents.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Heading
%"""

classdef Bookmark < biotracs.core.html.DomContainer
    
    properties(SetAccess = protected)
        level;
    end
    
    methods
        
        function this = Bookmark( iLevel, iText )
            this@biotracs.core.html.DomContainer();
            this.tagName = 'Bookmark';
            if nargin == 1
                this.setLevel( iLevel );
            end
            if nargin == 2
                if ~ischar(iText)
                    error('BIOTRACS:Html:Bookmark:InvalidArgument', 'The text must be a string');
                end
                this.setText( iText );
            end
        end
        
        %-- S --
        
        function setLevel( this, iLevel )
            if ~isscalar(iLevel) || ~isnumeric(iLevel) || iLevel > 3
                error('BIOTRACS:Html:Bookmark:InvalidArgument', 'The level of a bookmark must be a scalar numeric <= 3');
            end
            this.level = iLevel;
        end

    end
    
    methods(Static)
        
        function this = fromHeading( iHeading )
            if ~isa(iHeading, 'biotracs.core.html.Heading')
                error('BIOTRACS:Html:Bookmark:InvalidArgument', 'A biotracs.core.html.Heading is required');
            end
            this = biotracs.core.html.Bookmark();
            this.setText( iHeading.getText() );
            this.setLevel( iHeading.getLevel() );
        end
        
    end
    
    methods(Access = protected)
        
        function [ html ] = doGenerateHtml( this )
            html = ['<span id="',this.uid,'"></span>'];
        end
        
    end
end

