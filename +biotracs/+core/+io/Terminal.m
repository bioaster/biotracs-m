%"""
%biotracs.core.io.Terminal
%A Terminal object is a i/o PortSet that cannot be plugged. It is generally used for dead-ends in a process flow.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.io.Input, biotracs.core.io.Output, biotracs.core.io.PostSet
%"""

classdef(Sealed) Terminal < biotracs.core.io.PortSet
    
    properties
    end
    
    methods 
        
        function this = Terminal( varargin )
            this@biotracs.core.io.PortSet( varargin{:} );
            this.classNameOfElements = {''};    %will forbiden any data
        end
        
        %-- G --
 
        %-- I --
        
        function tf = isReady( ~ )
            tf = true;
        end
        
        function tf = isDefined( ~ )
            tf = true;
        end
        
        %-- S --

        % overload biotracs.core.container.Set methods
        function setClassNameOfElements( varargin ), error('BIOTRACS:Terminal:AccessRestricted', 'Cannot change attribute classNameOfElements'); end
        
    end
   
    methods(Access = protected)
        
        function doCreateFlowsFromSpecs( this, varargin )
            try
                this.doCreateFlowsFromSpecs@biotracs.core.io.PortSet( varargin{:} );
            catch exception
               isOK = strcmp(exception.identifier, 'BIOTRACS:IOFlowSet:InvalidFlow');
               if ~isOK
                  rethrow(excpetion); 
               end
            end
        end
        
    end
end

