%"""
%biotracs.core.constraint.IsNumeric
%Constraint that checks if a Parameter value is a numeric
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.constraint.Boolean, biotracs.core.constraint.Text, biotracs.core.mvc.Parameter
%"""

classdef IsNumeric < biotracs.core.constraint.Constraint

    properties(SetAccess = protected)
        isScalar = true;
    end
    
    methods
        
        function this = IsNumeric( varargin )
            this@biotracs.core.constraint.Constraint();
            p = inputParser();
            p.addParameter('Type', 'double', @(x)(ischar(x) && (strcmp(x,'double') || strcmp(x,'integer'))));
            p.addParameter('IsScalar', true, @islogical);
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            
            this.type = p.Results.Type;
            this.isScalar = p.Results.IsScalar;
        end

    end
    
    methods(Access = protected)

        function tf = doIsValid( this, iValue )
            if isempty(iValue)
                tf = true; return;
            end
            
            if this.isScalar && ~isscalar(iValue)
                tf = false; return;
            end
            
            if ~isnumeric(iValue)
                tf = false; return;
            end
            
            if strcmpi(this.type, 'integer')
                iValue = iValue(:); %transform to vector
                tf = all( isinf(iValue) | int64(iValue) == iValue );
            else
                tf = true;
            end
        end

    end
    
end

