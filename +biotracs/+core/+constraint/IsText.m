%"""
%biotracs.core.constraint.IsText
%Constraint that checks if a Parameter value is a numeric text
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.mvc.Parameter
%"""

classdef IsText < biotracs.core.constraint.Constraint
    
    properties
        isScalar = true;
    end
    
    methods
        function this = IsText( varargin )
            this@biotracs.core.constraint.Constraint();
            p = inputParser();
            p.addParameter('IsScalar', true, @islogical);
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            
            this.isScalar = p.Results.IsScalar;
        end
        
        function oValue = filter(this, iValue)
            if ~this.isScalar && ischar(iValue)
               oValue = { iValue }; 
            else
                oValue = iValue;
            end
        end
        
    end
    
    methods(Access = protected)
        
        function tf = doIsValid( this, iValue )
            if isempty(iValue)
                tf = true; return;
            end
            
            if this.isScalar
                tf = this.doIsValidElement(iValue);
            elseif iscellstr(iValue)
                fun = @this.doIsValidElement;
                tf = all(cellfun( fun, iValue ));
            elseif ischar(iValue)
                tf = false;
            else
                tf = false;
            end
        end

        function tf = doIsValidElement(~, iValue)
            if isempty(iValue)
                tf = true; return;
            end
            nbRows = size(iValue,1);
            tf = ischar(iValue) && nbRows == 1;
        end
        
    end
    
end

