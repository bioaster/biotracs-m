%"""
%biotracs.core.ability.Comparable
%Base class to handle comparison of objects.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%"""

classdef (Abstract) Comparable < biotracs.core.ability.Serializable
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
        
    end
    
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Comparable()
            this@biotracs.core.ability.Serializable();
        end
        
    end
    
    methods(Access = protected)
        
        function doCopy( this, iComparable, varargin )
            this.doCopy@biotracs.core.ability.Serializable( iComparable, varargin{:} );
        end
        
    end
    
    
    methods(Abstract)
        
        [ tf ] = isEqualTo( this )
        
    end
    
end
