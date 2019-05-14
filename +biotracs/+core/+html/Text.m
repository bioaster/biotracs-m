%"""
%biotracs.core.html.Text
%Text object allows manipulating and creating texts.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2019
%* See: biotracs.core.html.Italic, biotracs.core.html.Strong 
%"""

classdef Text < biotracs.core.html.DomContainer
    
    methods
        
        function this = Text( iText )
            this@biotracs.core.html.DomContainer();
            this.tagName = '';
            if nargin == 1
                if ~ischar(iText)
                    error('BIOTRACS:Html:Text:InvalidArgument', 'The text must be a string');
                end
                this.text = iText;
            end
        end
        
        %-- A --
        
    end
    
    methods(Access = protected)
        
        function [ html ] = doGenerateHtml( this )
            html = this.text;
        end
    end
    
end

