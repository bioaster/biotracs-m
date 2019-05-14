%"""
%biotracs.core.mvc.model.Process
%Defines the process object. A Process is a runnable object that is used to transform input resources and produce output resources.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.core.mvc.model.Resource, biotracs.core.mvc.view.Process
%"""

classdef Process < biotracs.core.mvc.model.Engine & biotracs.core.mvc.model.BaseObject
    
    properties(Access = protected)
        engines;
    end
    
    properties(Access = protected)
        isEngineProcess = false;
    end
    
    properties(Access = private)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Process( )
            this@biotracs.core.mvc.model.BaseObject();
            this@biotracs.core.mvc.model.Engine();
            this.engines = biotracs.core.container.Set(0, 'biotracs.core.mvc.model.Engine');
        end
        
        %-- A --
        
        %-- B --

        function [ this ] = bindEngine( this, iEngine, iEngineName )
            if ~isa(iEngine, 'biotracs.core.mvc.model.Engine')
                error('BIOTRACS:Process:InvalidArgument', 'An instance of ''biotracs.core.mvc.model.Engine'' is required');
            end
            iEngine.isEngineProcess = true;
            this.engines.set( iEngineName, iEngine );
        end
        
        %-- C --

        %-- E --
        
        %-- G --
        
        function e = getEngine( this, iName )
            e = this.engines.get( iName );
        end
        
        %-- H --
        
        function tf = hasEngines( this )
            tf = ~isEmpty(this.engines);
        end
        
        %-- I --
        
        function tf = isEngine( this )
            tf = this.isEngineProcess || (this.hasParent() && this.parent.isEngine());
        end
        
        function tf = hasEngine( this, iName )
            tf = this.engines.hasElement(iName);
        end
        
        %-- R --
        
        function [ this ] = removeEngine( this, iEngineName )
            this.engines.remove( iEngineName );
        end
        
        %-- S --
        
        function this = setConfig( this, iConfig )
            this.setConfig@biotracs.core.mvc.model.Engine(iConfig);
            this.config.setLabel(this.label);
            this.config.setDescription(this.decription);
        end
        
        function this = setLabel( this, iLabel )
            this.setLabel@biotracs.core.mvc.model.BaseObject(iLabel);
            this.config.setLabel(iLabel);
        end
        
        function this = setDescription( this, iDescription )
            this.setDescription@biotracs.core.mvc.model.BaseObject(iDescription);
            this.config.setDescription(iDescription);
        end
        
        function this = summary( this, varargin )
            fprintf('<strong>Inputs:</strong>\n');
            fprintf('_____________________________________________________________\n');
            this.input.summary( varargin{:} );
            
            fprintf('<strong>Outputs:</strong>\n');
            fprintf('_____________________________________________________________\n');
            this.output.summary( varargin{:} );
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        %-- A --
        
        function doAfterRun( this )
            if ~this.isPhantom
                this.doAttachProcessToOutputResources();
                this.doSetLabelsOfOutputResources();
            end
            if this.config.getParamValue('Verbose')
                elapsedDuration = this.endDateTime-this.startDateTime;
                elapsedDuration.Format = 'dd:hh:mm:ss.SSS';
                this.logger.writeLog('Done (elapsed run time: %s)', elapsedDuration);
                fprintf('\n');
            end
        end
        

        function doAttachProcessToOutputResources( this )
            %if(this.isEngine()) 
            %    return; 
            %end

            for i=1:this.output.getLength()
                port = this.output.getPortAt(i);
                portName = this.output.getPortNameByIndex(i);
                data = port.getData();
                if numel(data) == 0
                    error('Process:DoAttachProcessToOutputResources:NoOutputsDefined','Output port ''%s'' is not defined', portName);
                end
                if isa(data, 'biotracs.core.mvc.model.Resource')
                    data.setProcess(this);
                else
                    error('Process:DoAttachProcessToOutputResources:OutputDataIsNotAResource','Data of output port ''%s'' is a %s. A biotracs.core.mvc.model.Resource was expected', portName, class(data));
                end
            end
        end
        
        function this = doAttachDefaultConfig( this )
            this.doAttachDefaultConfig@biotracs.core.mvc.model.Engine();
            if numel(this.config) == 0 || isempty(this.config)
                this.config = biotracs.core.mvc.model.ProcessConfig();
                this.configType = 'biotracs.core.mvc.model.ProcessConfig';
            end
            this.config.setLabel(this.getLabel());
            this.config.setDescription(this.getDescription());
        end
        
        %-- B --
        
        function doBeforeRun( this )
            if this.config.getParamValue('Verbose')
                this.logger.writeLog('Running %s', this.label);
            end
            if this.hasParent()
                this.parent.onTriggerChildNode( this );
            end
                
            if ~this.isPhantom
                this.doAttachProcessToOutputResources();
            end
            wdir = this.config.getParamValue('WorkingDirectory');
            if this.hasEngines()
               for i = 1:getLength(this.engines)
                   c = this.engines.getAt(i).getConfig();
                   c.hydrateWith( this.config );
                   subdir = this.engines.getElementName(i);
                   c.updateParamValue('WorkingDirectory', fullfile(wdir,subdir));
                   c.updateParamValue('Verbose', false);
               end
            end
        end
        
        %-- C --
        
        function doCopy( this, iProcess, varargin )
            if ~isempty(iProcess.engines) && ~iProcess.engines.isNil()
                this.engines = this.engines.copy();
            end
            this.doCopy@biotracs.core.mvc.model.Engine( iProcess, varargin{:} );
            this.doCopy@biotracs.core.mvc.model.BaseObject( iProcess, varargin{:} );
        end
        
        %-- D --
        
        %-- P --
        
        %-- R --
        
        function doRun( ~ )
            % The engineering process
            % Overload this function to implement here your custom algorithm
        end
        
        %-- S --
        
        function doSetLabelsOfOutputResources( this )
            if isa( this.input, 'biotracs.core.io.Terminal' ) || isa( this.output, 'biotracs.core.io.Terminal' )
                return;
            end
            
            isNbInputPortsEqualToNbOutputPorts =  this.output.getLength() == this.input.getLength();
            for i=1:this.output.getLength()
                if isNbInputPortsEqualToNbOutputPorts
                    inData = this.input.getPortAt(i).getData();
                else
                    inData = this.input.getPortAt(1).getData();
                end
                outData = this.output.getPortAt(i).getData();
                isOutDataUnnamed = isempty(outData.getLabel()) || strcmp(outData.getLabel(), class(outData));
                isInDataUnnamed = isempty(inData.getLabel()) || strcmp(inData.getLabel(), class(inData));
                
                if isOutDataUnnamed && ~isInDataUnnamed
                    outData.setLabel( inData.getLabel() );
                end
            end
        end
        
        %-- T --
        
    end
    
end

