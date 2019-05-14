%"""
%biotracs.core.ability.Helpable
%Base class to handle Helpable objects. A Helpable is an object that is
%associated with an Helper. For instance, in BioTracs a Model is an
%Helpable associated with a View that is implemented as an helper. The
%wiews therefore help visualizing the models.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.helper.Helper
%"""

classdef (Abstract) Helpable < biotracs.core.ability.Parametrable
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
        helper;
        helperCallingWord = '';
    end
    
    properties(GetAccess = private, SetAccess = protected)
        helperClassName = 'biotracs.core.helper.Helper'; 
    end
    
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Helpable()
            this@biotracs.core.ability.Parametrable();
        end
        
        %-- B --
        
        function this = bindHelper( this, iHelper )
            if isa(iHelper, this.helperClassName)
                %set the model the iHelper
                if isempty(iHelper.getHelpable())
                    iHelper.setHelpable(this);
                elseif ~isequal(iHelper.getHelpable(), this)
                    disp('Warning: This helper instance is already binded to another model. Changing helper')
                    iHelper.setHelpable(this);
                end
                %set the Helper the helpable object
                this.helper = iHelper;
            else
                error('BIOTRACS:Helpable:NoConfigurationDefined','Invalid argument, A %s is required', this.helperClassName);
            end
        end
        
        %-- G --
        
        function oView = getHelper( this )
            oView = this.helper;
        end
        
        %-- S --
        
    end
    
    methods(Access = protected)
        
        function doCopy( this, iHelpable, varargin )
           this.doCopy@biotracs.core.ability.Parametrable( iHelpable, varargin{:} );
        end
        
    end
    
    methods(Static)
    end
    
end
