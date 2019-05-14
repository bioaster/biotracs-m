%"""
%biotracs.core.html.Heading
%Html headings (h1,h2, ..., h6) to create titles. Note that Bookmarks can be added to heading to
%create table of contents
%of contents for example.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Bookmark
%"""

classdef Heading < biotracs.core.html.DomChild
    
    properties
        level;
    end
    methods
        
        function this = Heading( iLevel, iText )
            this@biotracs.core.html.DomChild();
            if ~isscalar(iLevel) ||  ~isnumeric(iLevel) || iLevel < 1 || iLevel > 6
                error('The level of the title must be a numeric scalar between 1 and 6');
            end
            this.level = iLevel;
            this.tagName = ['h', num2str(iLevel)];
            
            if nargin == 2
                if ~ischar(iText)
                    error('BIOTRACS:Html:Div:InvalidArgument', 'The text must be a string');
                end
                this.text = iText;
            end
        end
        
        %-- G --
        
        function oLevel = getLevel( this )
            oLevel = this.level;
        end
        
    end
    
end

