%"""
%biotracs.core.ability.Configurable
%Base class to handle configurable objects. A Configurable is an object
%associated with a configuration. For instance, a Process is a configurable
%associated with a configuration, i.e a ProcessConfig.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.mvc.model.Process, biotracs.core.mvc.model.ProcessConfig 
%"""

classdef (Abstract) Configurable < biotracs.core.ability.Serializable
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
        config;
        configType = 'biotracs.core.ability.Parametrable';
    end
    
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        %-- A --
    end
    
    methods
        
        
        function this = Configurable( )
            this@biotracs.core.ability.Serializable( );
            this.doAttachDefaultConfig();
        end
        
        %-- C --
        
        function this = configure( this, iConfigurable )
            this.config.hydrateWith( iConfigurable.config );
        end
        
        %-- E --
        
        function this = exportConfig( this, varargin )
            if isempty(this.config)
                error('BIOTRACS:Configurable:NoConfigurationDefined', 'No config defined');
            end
            this.config.exportParams( varargin{:} );
        end
        
        %-- G --
        
        function oConfig = getConfig( this )
            oConfig = this.config;
        end

        %-- S --
        
        function this = setConfig( this, iParametrableConfig )
            if ~isa(iParametrableConfig, this.configType)
                error('BIOTRACS:Configurable:InvalidArguments','%s%s%s', 'Invalid argument. A ', this.configType,'  is required');
            end
            this.config = iParametrableConfig;
        end

    end
    
    methods(Access = protected)
        
        function this = doAttachDefaultConfig( this )
            configClassName = [class(this),'Config'];
            if exist( configClassName, 'class' )
                eval(['metaclass = ?',configClassName,';']);
                if ~metaclass.Abstract
                    this.config = feval(configClassName);
                    this.configType = configClassName;
                end
            end
        end
        
        function this = doCopy( this, iConfigurable )
            this.config = iConfigurable.config.copy();
            this.configType = iConfigurable.configType;
        end
        
    end
    
    methods(Static)
    end
    
end
