%"""
%biotracs.core.ability.Serializable
%Base mixin class to serialize objects.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%"""

classdef (Abstract) Serializable < biotracs.core.ability.Copyable
    
    properties
    end
    
    properties(SetAccess = private, Dependent = true)
        className;
    end
    
    methods
        
        % Constructor
        function this = Serializable()
            this@biotracs.core.ability.Copyable();
        end
        
        %-- C --
        
        %-- E --

        %-- G --

        function fullName = get.className( this )
            fullName = class(this);
        end

        function [fullName, objName] = getClassName( this )
            fullName = class(this);
            if nargout == 2
                objName = regexprep( class(this) , '.*\.([^\.]*)$', '$1');
            end
        end
        
        function parts = getClassNameParts( this, whichPart )
            if nargin == 1, whichPart = ''; end
            parts = strsplit( class(this), '.' );
            switch whichPart
                case 'head'
                    parts = parts{end};
                case 'foot'
                    parts = parts{1};
                otherwise
            end
                
        end
        
        %-- S --
        
        function oStringData = serialize( this )
            oStringData = getByteStreamFromArray(this);
        end

    end
    
    methods(Access = protected)
        
        function doCopy( varargin )
            %do not copy
        end
        
    end
    
    methods(Static)
        
        function this = deserialize( iStringData )
            this = getArrayFromByteStream(iStringData);
        end

    end
    
end

