%"""
%biotracs.core.xml.Doc
%Xml doc object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%"""

classdef Doc < biotracs.core.xml.DomElement
    
    properties(SetAccess = protected)
    end
    
    methods
        function this = Doc( iFilePath )
            tree = xmlread(iFilePath);
            this@biotracs.core.xml.DomElement(tree);            
        end
        
    end
    
    methods(Access = protected)
        
    end
    
    methods( Static )
        
    end
    
end

