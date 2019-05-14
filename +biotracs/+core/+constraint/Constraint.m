%"""
%biotracs.core.constraint.Constraint
%Base Constraint objet to manage Parameter values constraints. A
%Parameter is allways associated with a Constraint.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.mvc.Parameter
%"""

classdef (Abstract)Constraint < biotracs.core.ability.PropListable
    
    properties(SetAccess = protected)
        %ToDo : to check !
        type = 'any';
    end
    
    methods
        
        function tf = isValid( this, varargin )
            tf = this.doIsValid( varargin{:} );
        end

        %@ToDo : to lock of numeric, ... 
        function this = setType( this, iType )
            this.type = iType;
        end
        
        function out = summary( this )
            prop = this.getPropertiesAsJson();
            txt = [class(this), '(',prop,')'];
            if ~nargout
                fprintf('%s\n',txt);
            else
                out = txt;
            end
        end
        
        %A filter that is applied to the value of the paramter that holds
        %this constraint
        function value = filter(~, value)
            %nothing
        end
        
    end

    methods(Abstract, Access = protected)
        tf = doIsValid( this, varargin );
    end
    
end

