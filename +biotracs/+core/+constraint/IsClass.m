%"""
%biotracs.core.constraint.IsClass
%Constraint that checks if a value of a given class
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.constraint.IsFunction, biotracs.core.mvc.Parameter
%"""

classdef IsClass < biotracs.core.constraint.Constraint
    
    properties
        className;
        isStrict = false;
    end
    
    methods
        
        %> @param[in] iClassName The class name
        %> @param[in] iIsStrict True for strict comparison (class names
        %must be identitical), False to allow inherited classed to pass the
        %constraint
        function this = IsClass( iClassName, iIsStrict )
            this@biotracs.core.constraint.Constraint();
            if ~ischar(iClassName)
                error('Class name must be a string');
            end
            this.className = iClassName;
            
            if nargin == 2
                if ~islogical(iIsStrict)
                    error('Strict comparison flag mus be a logical')
                end
                this.isStrict = iIsStrict;
            end
        end

    end
    
    methods(Access = protected)
        
        function tf = doIsValid( this, iValue )
            if this.isStrict
                tf = strcmp( class(iValue), this.className );
            else
                tf = isa( iValue, this.className );
            end
        end
        
    end
    
end

