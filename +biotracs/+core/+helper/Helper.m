%"""
%biotracs.core.helper.Helper
%Base helper class
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%"""

classdef (Abstract) Helper < biotracs.core.ability.Parametrable

	 properties(SetAccess = protected)
	 end
	 
     properties(SetAccess = protected)
         handle;
         helpable;
     end
     
	 methods
		  
		  % Constructor
          %> @param[in] iHelpable [optional] helpable to help
          function this = Helper( iHelpable )
              this@biotracs.core.ability.Parametrable();
              if nargin == 1
                  this.setHelpable( iHelpable );
              end
              %this.createParam('WorkingDirectory', '', 'Constraint', biotracs.core.constraint.IsPath());
          end
		  
          %-- G --
          
          function h = getHandle( this )
              h = this.handle;
          end
          
          function oModel = getHelpable( this )
              oModel = this.helpable;
          end
          
          %-- S --
          
          function this = setHelpable( this, iHelpable )
              if ~isa(iHelpable, 'biotracs.core.ability.Helpable')
                  error('Invalid object, A ''biotracs.core.ability.Helpable'' is required');
              end
              this.helpable = iHelpable;
          end
          
     end
	 
     methods(Access = protected)
        
        function doCopy( this, iHelper, varargin )
            this.doCopy@biotracs.core.ability.Parametrable( iHelper, varargin{:} );
            if ~isempty(iHelper.helpable)
                %copy Helpable and bind a new Helper to the Helpable
                helpableCopy = iHelper.helpable.copy(); 
                %override binded Helper
                helpableCopy.bindHelper(this);
            end
            this.handle = iHelper.handle;
        end
        
     end
    
end

