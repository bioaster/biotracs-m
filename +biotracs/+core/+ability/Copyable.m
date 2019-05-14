%"""
%biotracs.core.ability.Copyable
%Base class to handle the copy of objects. Almost all BioTracs classes
%inherits the Copyable class.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%"""

classdef (Abstract) Copyable < handle

    methods
        
        function this = Copyable()
            this@handle();
        end
        
        %@return a deep copy of this object
        %@warning Ensure that subclasses that inherit Copyable are
        %compatible with this genric copy method. Otherwise, you must
        %implement your own copy method
        function c = copy( this, varargin )
            c = feval( class(this) );
            c.doCopy(this, varargin{:} );
        end
        
        function tf = isNil( this )
            tf = (numel(this) == 0);
        end
        
        function summary( this )
           disp(this); 
        end

    end
    
    methods( Abstract, Access = protected )
        doCopy( this, iCopyable, varargin )
    end
    
    methods(Static)
        
    end
    
end
