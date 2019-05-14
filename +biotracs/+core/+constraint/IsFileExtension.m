%"""
%biotracs.core.constraint.IsFileExtension
%Constraint that checks if a Parameter value is a text corresponding the pattern
%of file path with a given extension
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.constraint.IsText, biotracs.core.constraint.IsPath, biotracs.core.mvc.Parameter
%"""

classdef IsFileExtension < biotracs.core.constraint.IsText
    
    methods
        
        function value = filter(~, value)
            if strcmpi(value, '?inherit?'), return; end
            value = regexprep(value,'\.*(.*)$','$1'); %remove dots before
        end
        
    end
    
    methods(Access = protected)
        
        function tf = doIsValid( this, value )
            tf = this.doIsValid@biotracs.core.constraint.IsText(value);
            if ~tf, return; end
            if strcmpi(value, '?inherit?') || isempty(value)
                tf = true; return; 
            end
            expr = ['[',regexptranslate('escape','\/?:*"<>|'),']'];
            tf = isempty( regexp(value, expr, 'once') );
        end
        
    end
    
end

