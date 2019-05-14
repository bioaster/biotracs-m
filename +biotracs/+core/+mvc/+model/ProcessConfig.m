%"""
%biotracs.core.mvc.model.ProcessConfig
%Defines the configuration of a process object. 
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.mvc.model.Process, biotracs.core.mvc.model.Parameter
%"""

classdef ProcessConfig < biotracs.core.mvc.model.BaseObject
    
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
        function this = ProcessConfig()
            this@biotracs.core.mvc.model.BaseObject( );
            this.createParam( 'Verbose', true, 'Constraint', biotracs.core.constraint.IsBoolean() );
            this.createParam( 'WorkingDirectory', '', 'Constraint', biotracs.core.constraint.IsPath() );
            this.createParam( 'ConfigFilePath', '', 'Constraint', biotracs.core.constraint.IsPath() );
            this.createParam( 'IsPhantom', false, 'Constraint', biotracs.core.constraint.IsBoolean() );
            this.createParam( 'IsDeactivated', false, 'Constraint', biotracs.core.constraint.IsBoolean() );
        end

        %-- C --
        
        %-- B --

        %-- E --

        function this = exportParams( this, iFilePath, varargin )
            if ~isempty(this.label)
                name = this.label;
            else
                name = class(this);
            end
            if nargin <= 1
                iFilePath = fullfile([ this.getParamValue('WorkingDirectory'), '\', name, '.params.xml' ]);
            end
            this.exportParams@biotracs.core.mvc.model.BaseObject( iFilePath, varargin{:} );
        end
        
        %-- G --

        %-- R --

        %-- S --

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        %-- C --
        
        function doCopy( this, iProcessConfig, varargin )
            this.doCopy@biotracs.core.mvc.model.BaseObject( iProcessConfig, varargin{:} );
        end

    end
    
end
