%"""
%biotracs.core.html.Base
%Base html object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%"""

classdef Base < biotracs.core.html.Card
    
    properties(SetAccess = protected)
        header = '';
        title = '';
        subtitle = '';
        footer = '';
    end
    
    methods
        
        function this = Abstract( varargin )
            this@biotracs.core.html.Card( varargin{:} );
        end
        
    end
    
    methods(Access = protected)
       
        function [ html ] = doGenerateHtml( this )
            html = this.doGenerateHtml@biotracs.core.html.Card();
            html = [ html, '<br/><br/>' ];
        end
        
    end
    
end

