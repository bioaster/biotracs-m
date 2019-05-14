%"""
%biotracs.core.ability.Runnable
%Base class to manage Runnable objects. A Runnable is object as that runs a
%Process. A Workflow is composed of a set of nodes that are Runnable
%processes. Also, a Workflow is itself a Runnable object.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.data.model.Chainable, biotracs.data.model.Trackable,
%biotracs.core.io.Input, biotracs.core.io.Output, biotracs.core.mvc.model.Process,
%"""

classdef (Abstract) Runnable < biotracs.core.ability.Chainable & biotracs.core.ability.Configurable & biotracs.core.ability.Trackable %& biotracs.core.ability.Copyable
    
    properties(Access = protected)
        paths = {};
        nodeIndex;
    end
    
    properties(SetAccess = protected)
        startDateTime;
        endDateTime;
        output;
        input;
        parent;
        
    end
    
    properties(Dependent, SetAccess = protected)
        isPhantom;
        isDeactivated;
    end
    
    properties(GetAccess = protected, SetAccess = private)
        isEmulation = false;
    end
    
    events
        onInit;     %event triggered just before initialization (also before start)
        onStart;    %event triggered jsut before start (but after intialization)
        onEnd;      %event triggered on end
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Runnable( )
            this@biotracs.core.ability.Chainable();
            this@biotracs.core.ability.Configurable();
            this@biotracs.core.ability.Trackable();
            this.setInput(biotracs.core.io.Input());
            this.setOutput(biotracs.core.io.Output());
        end
        
        %-- A --
        
        % Add new specs to the inputs specs
        function this = addInputSpecs( this, iSpecs )
            this.input.addSpecs(iSpecs);
            this.input.setParent(this);
        end
        
        % Add new specs to the outputs specs
        function this = addOutputSpecs( this, iSpecs )
            this.output.addSpecs(iSpecs);
            this.output.setParent(this);
        end
        
        function this = allocateOutputPorts( this, iNbPorts )
            this.output.allocate(iNbPorts);
        end
        
        function this = allocateInputPorts( this, iNbPorts )
            this.input.allocate(iNbPorts);
        end
        
        %-- B --
        
        %-- C --
        
        function this = connectInputPort( this, iPortName, iPort )
            if ~isa(iPort, 'biotracs.core.io.Port')
                error('BIOTRACS:Runnable:InvalidArguments', 'Invalid input port, a biotracs.core.io.Port is required')
            end
            
            port = this.getInputPort(iPortName);    %retreive the port having the same name
            port.connectTo(iPort);
        end
        
        function this = connectOutputPort( this, iPortName, iPort )
            if ~isa(iPort, 'biotracs.core.io.Port')
                error('BIOTRACS:Runnable:InvalidArguments', 'Invalid ouput port, a biotracs.core.io.Port is required')
            end
            
            port = this.getOutputPort(iPortName);   %retrieve the port having the same name
            port.connectTo(iPort);
        end
        
        function this = connectInput( this, iInput, varargin )
            this.input.connectTo(iInput, varargin{:});
        end
        
        function this = connectOutput( this, iOutput, varargin )
            this.output.connectTo(iOutput, varargin{:});
        end
        
        %-- E --
        
        function emulate( this )
            this.isEmulation = true;
            this.run();
            this.isEmulation = false;
        end

        %-- G --

        function tf = get.isPhantom( this)
            tf = this.config.getParamValue('IsPhantom');
        end
        
        function tf = get.isDeactivated( this)
            tf = this.config.getParamValue('IsDeactivated');
        end
        
        function p = getParent( this )
            p = this.parent;
        end
        
        function oSpecs = getInputSpecs( this )
            oSpecs = this.input.specs;
        end
        
        function oSpecs = getOutputSpecs( this )
            oSpecs = this.output.specs;
        end
        
        % Get the number of inputs
        function nb = getNbInputPorts( this )
            nb = getLength(this.input);
        end
        
        % Get the number of outputs
        function nb = getNbOutputPorts( this )
            nb = getLength(this.output);
        end
        
        function port = getInputPort( this, iPortName )
            port = this.input.getPort(iPortName);
        end
        
        % Get the input at a given input port
        % param[in] iPortName The name [string] or index [integer] of the
        % input
        % return The input at the given port
        function in = getInputPortData( this, iPortName )
            port = this.input.getPort(iPortName);
            in = port.getData();
        end
        
        function in = getInput( this )
            in = this.input;
        end
        
        function port = getOutputPort( this, iPortName )
            if numel(this.input) == 0
                error('BIOTRACS:Runnable:NoOutputsDefined', 'No output defined');
            end
            port = this.output.getPort(iPortName);
        end
        
        % Get the data of a given output port
        % param[in] iPortName The name [string] or index [integer] of the
        % output
        % return The output at the given port
        function out = getOutputPortData( this, iPortName )
            port = this.output.getPort(iPortName);
            out = port.getData();
        end
        
        function out = getOutput( this )
            out = this.output;
        end
        
        function date = getStartDateTime( this )
            date = this.startDateTime;
        end
        
        function date = getEndDateTime( this )
            date = this.endDateTime;
        end
        
        function [ nodesOfNextInputPorts ] = getNext( this )
            nextInputPorts = this.output.getNext();
            nodesOfNextInputPorts = cellfun(@getParent, nextInputPorts, 'UniformOutput', false);
            idxToDiscard = [];
            for i=1:length(nodesOfNextInputPorts)
                isMyParent = ( nodesOfNextInputPorts{i} == this.parent );
                if isMyParent
                    idxToDiscard(end+1) = i; %#ok<AGROW>
                end
            end
            nodesOfNextInputPorts(idxToDiscard) = [];
        end
        
        function [ p ] = getPaths( this )
            p = {this};
            for i=1:length(this.paths)
                next = this.paths{i};
                p = [ p, next.getPaths() ];
            end
        end
        
        function [ nodesOfPrevOutputPorts ] = getPrevious( this )
            prevOutputPorts = this.input.getPrevious();
            nodesOfPrevOutputPorts = cellfun(@getParent, prevOutputPorts, 'UniformOutput', false);
            idxToDiscard = [];
            for i=1:length(nodesOfPrevOutputPorts)
                isMyParent = ( nodesOfPrevOutputPorts{i} == this.parent );
                if isMyParent
                    idxToDiscard(end+1) = i; %#ok<AGROW>
                end
            end
            nodesOfPrevOutputPorts(idxToDiscard) = [];
        end
        
        %-- H --

        function tf = hasParent( this )
            tf = ~isempty(this.parent);
        end
        
        %-- I --

        function tf = isStarted( this )
            tf = ~isempty(this.startDateTime);
        end
        
        function tf = isEnded( this )
            tf = ~isempty(this.endDateTime);
        end
        
        function [tf] = isReady( this )
%             tf = (this.input.isReady() || this.isSource()) && ...
%                 (this.output.isDefined() || this.isSink());
            tf = this.input.isReady() && this.output.isDefined();
        end
        
        function tf = isSource( this )
            prev = this.getPrevious();
            tf = isempty(prev);
        end
        
        function tf = isSink( this )
            next = this.getNext();
            tf = isempty(next);
        end

        %-- O --
        
        %-- R --
        
        function this = reset( this, iHasToPropagate )
            this.startDateTime = [];
            this.endDateTime = [];
            for i=1:this.input.getLength()
                this.input.getPortAt(i).reset();
            end
            for i=1:this.output.getLength()
                this.output.getPortAt(i).reset();
            end
            
            if nargin == 1 || iHasToPropagate
                next = this.getNext();
                for i=1:length(next)
                    next{i}.reset();
                end
            end
        end

        function resizeInput( this, iNbPorts, varargin )
            this.input.resize( iNbPorts, varargin{:}  );
        end
        
        function resizeOutput( this, iNbPorts, varargin )
            this.output.resize( iNbPorts, varargin{:}  );
        end
        
        % Run the process
        function run(this, varargin)
            if ~this.isReady() || this.isEnded || this.isDeactivated
                return;
            end

%             if this.isEnded()
%                 fprintf('Already run. Go next!')
%                 this.doExecuteNext();
%                 return
%             end
            
            % init
            this.notify('onInit');
            this.doSetStartDateTime( datetime() );
            this.doImportConfigFile();
            this.doPrepareWorkingDirectory();
            this.config.checkParameterConstraints();
            this.doBeforeRun();
            
            if this.isDeactivated
                return;
            end
            
            % open current log & store previous logger
            this.logger.setLogDirectory(this.config.getParamValue('WorkingDirectory'));
            this.logger.setLogFileName(this.getLabel());
            this.logger.openLog();
            previousLogger = biotracs.core.env.Env.currentLogger();
            biotracs.core.env.Env.currentLogger( this.logger );
            
            % run
            this.notify('onStart');
            if this.isEmulation
                this.doEmulate( varargin{:} );
            else
                if this.config.getParamValue('IsPhantom')
                    this.doPass( varargin{:} );
                else
                    this.doRun( varargin{:} );
                end
            end
            this.doExportConfigFile();
            this.doSetEndDateTime( datetime() );
            this.doAfterRun();
            this.notify('onEnd');
            this.logger.closeLog();
            
            % restore previous logger
            biotracs.core.env.Env.currentLogger( previousLogger );
            
            % propagate to the next node
            this.output.propagate();    %ensure that all data has been propagated (Force = true)

            % execute next elements if any
            this.doExecuteNext();
        end
        
        %-- S --
        
        function this = setParent( this, iParent )
            % @ToDo: implement Runnable container
            if ~isa(iParent, 'biotracs.core.mvc.model.Workflow')
                error('BIOTRACS:Runnable:InvalidArguments', 'The parent must be a biotracs.core.mvc.model.Workflow');
            end
            this.parent = iParent;
        end

        function this = setInput( this, iInput )
            if ~isa(iInput, 'biotracs.core.io.Input') && ~isa(iInput, 'biotracs.core.io.Terminal')
                error('BIOTRACS:Runnable:InvalidArguments', 'A biotracs.core.io.Input is required');
            end
            this.input = iInput;
            this.input.setParent(this);
        end
        
        function this = setOutput( this, iOuput )
            if ~isa(iOuput, 'biotracs.core.io.Output') && ~isa(iOuput, 'biotracs.core.io.Terminal')
                error('BIOTRACS:Runnable:InvalidArguments', 'A biotracs.core.io.Output is required');
            end
            this.output = iOuput;
            this.output.setParent(this);
        end
        
        
        function this = setIsDeactivated( this, isDeactivated )
            if ~islogical(isDeactivated)
               error('BIOTRACS:Runnable:InvalidArgument', 'A logical value is required'); 
            end
            %this.isDeactivated = isDeactivated;
            this.config.updateParamValue('IsDeactivated', isDeactivated);
        end
        
        function this = setIsPhantom( this, isPhantom )
            if ~islogical(isPhantom)
               error('BIOTRACS:Runnable:InvalidArgument', 'A logical value is required'); 
            end
            this.config.updateParamValue('IsPhantom', isPhantom);
            %this.isPhantom = isPhantom;
        end

        function this = setInputPortData( this, iPortName, iData )
            port = this.input.getPort(iPortName);
            port.setData(iData);
        end

        function this = setOutputPortData( this, iPortName, iData )
            port = this.output.getPort(iPortName);
            port.setData(iData);
        end
        
        function this = setInputSpecs( this, iSpecs )
            if ~iscell(iSpecs)
                error('BIOTRACS:Runnable:InvalidArguments', 'A cell of struct is expected for specs')
            end
            this.input.setSpecs( iSpecs );
            this.input.setParent(this);
        end
        
        
        function this = setOutputSpecs( this, iSpecs )
            if ~iscell(iSpecs)
                error('BIOTRACS:Runnable:InvalidArguments', 'A cell of struct is expected for specs')
            end
            this.output.setSpecs( iSpecs );
            this.output.setParent(this);
        end
        
        %-- U --
        
        % Update an input spec
        function this = updateInputSpecs( this, iSpecs )
            this.input.updateSpecs( iSpecs );
            this.input.setParent(this);
        end
        
        % Update an output spec
        function this = updateOutputSpecs( this, iSpecs )
            this.output.updateSpecs( iSpecs );
            this.output.setParent(this);
        end
        
    end
    
    
    % -------------------------------------------------------
    % Abstract protected methods
    % -------------------------------------------------------
    
    methods(Abstract, Access = protected)
        [ out ] = doBeforeRun( this, varargin );    % Actions to do before run ...
        [ out ] = doRun( this, varargin );          % Run here ...
        [ out ] = doAfterRun( this, varargin );     % Actions to do after run ...
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods (Access = protected)
        
        %-- C --
        
        function [ str ] = doConvertFolderIndexToString( ~, index )
            if index > 999
                error('BIOTRACS:Runnable:MaxNumberReached', 'The maximum of %d nodes is reached', 999);
            end
            if index < 10
                str = ['00',num2str(index)];
            elseif index < 100
                str = ['0',num2str(index)];
            else
                str = num2str(index);
            end
        end
        
        function doCopy( this, iRunnable, varargin )
            this.doCopy@biotracs.core.ability.Trackable( iRunnable, varargin{:} );
            this.doCopy@biotracs.core.ability.Configurable( iRunnable, varargin{:} );
            
            this.startDateTime = iRunnable.startDateTime;
            this.endDateTime = iRunnable.endDateTime;
        
            % create new inputs/ouputs
            this.setInputSpecs( iRunnable.getInputSpecs() );
            this.setOutputSpecs( iRunnable.getOutputSpecs );
        end
        
        %-- E --
        
        function doExportConfigFile( this )
            configFile = this.config.getParamValue('ConfigFilePath');
            isConfigFileImported = ~isempty(configFile);
            if ~isConfigFileImported
                %export configuration for traceability
                wd = this.config.getParamValue('WorkingDirectory');
                filePath = fullfile([ wd, '/config.params.xml' ]);
                this.config.exportParams( filePath );
            end
        end
        
        function doEmulate( this )
            for i=1:this.output.getLength()
                data = this.output.getPortAt(i).getData();
                this.output.getPortAt(i).setData( data );
            end
        end
         
        
        %-- G --
        
        function wd = doGetActiveDirectory( this )
            wd = this.config.getParamValue('WorkingDirectory');
            if this.hasParent()
                if isempty(this.nodeIndex)
                    this.nodeIndex = this.parent.getNodeCounter();
                end
                nodeIndexStr = this.parent.doConvertFolderIndexToString( this.nodeIndex );
                parentWd = this.parent.doGetActiveDirectory();
                subfolder = [nodeIndexStr, '-', this.getLabel()];
                wd = fullfile(parentWd, subfolder);
            elseif isempty(wd)
                wd = fullfile(biotracs.core.env.Env.tempDir(), biotracs.core.env.Env.name());
                this.logger.writeLog('The working directory is %s', wd);
            end 
        end
        
        %-- I --
        
        function doImportConfigFile( this )
            configFile = this.config.getParamValue('ConfigFilePath');
            hasToImportConfigFile = ~isempty(configFile);
            if hasToImportConfigFile
                this.logger.writeLog('Load existing configuation file ''%s''', configFile);
                this.config.importParams(configFile);
            end
        end
        
        %-- P --
        
        function wd = doPrepareWorkingDirectory( this )
            wd = this.doGetActiveDirectory();
            this.config.updateParamValue('WorkingDirectory', wd);
            if ~isfolder(wd) && ~mkdir(wd)
                error('BIOTRACS:Runnable:PathAccessRestricted', 'Cannot create working directory ''%s''', wd);
            end
        end
 
        % Try to pass the input port data to the output ports
        % If M input ports and N output ports are defined with M > N, then
        % the M first input data are passed to the N output ports
        function doPass( this, varargin )
            if ~this.output.isDefined() && this.isSink()
                return;
            end
            this.logger.writeLog('Pass all the input data to the output');
            try
                for i=1:this.input.getLength()
                    port = this.input.getPortAt(i);
                    %try to pass to the output port is possible
                    hasCorrespondingOutputPort = this.output.getLength() >= i;
                    if hasCorrespondingOutputPort
                        this.output.getPortAt(i).setData( port.getData() );
                    end
                end
            catch exception
                error('BIOTRACS:Runnable:CannotPassResources', 'Cannot pass the input data to the output data. Please ensure that the output has at least the number of ports as the input and that they are compatible\n%s', exception.message)
            end
        end
        
        %-- R --
        
        function doExecuteNext( this )
            next = this.getNext();
            n = length(next);
            for i=1:n
                if this.isEmulation
                    next{i}.emulate();
                else
                    next{i}.run();
                end
                if next{i}.isEnded()
                    this.paths{end+1} = next{i};
                end
            end
        end
        
        %-- S --
        
        % Set end date-time
        function this = doSetEndDateTime( this, iEndDateTime )
            this.endDateTime = iEndDateTime;
        end
        
        % Set start date-time
        function this = doSetStartDateTime( this, iStartDateTime )
            this.startDateTime = iStartDateTime;
        end
        
    end
    
    methods(Access = {?biotracs.core.mvc.model.Workflow, ?biotracs.core.ability.Runnable})
        function setNodeIndex( this, iIndex )
            this.nodeIndex = iIndex;
        end
    end
    
end
