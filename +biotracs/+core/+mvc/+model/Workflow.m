%"""
%biotracs.core.mvc.model.Workflow
%Defines the Workflow object. A Workflow is a set of connected Process nodes.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.mvc.model.WorkflowConfig, biotracs.core.mvc.view.Workflow, biotracs.core.mvc.model.Process
%"""

classdef Workflow < biotracs.core.mvc.model.Process
    
    properties(Access = protected)
        listOfNodes;        %> nodes (Runnable) of the workflow
        nodeCounter = 0;
    end

    methods
        
        function this = Workflow()
            this@biotracs.core.mvc.model.Process();
            this.listOfNodes = biotracs.core.container.Set(0,'biotracs.core.ability.Runnable');
            this.bindView( biotracs.core.mvc.view.Workflow() );	 %bind default view
            
            this.input = biotracs.core.io.Terminal();
            this.output = biotracs.core.io.Terminal();
        end
        
        %-- A --
        
        function this = addNode( this, iNode, iName )
            iNode.setLabel( iName );
            this.listOfNodes.add( iNode, iName );
            this.config.createParam([iName,'ConfigFilePath'], '', 'Constraint', biotracs.core.constraint.IsPath());
            iNode.setParent(this);
            
            %add listeners
            iNode.addlistener('onInit', @increment );
            function increment(src, ~)
                hasNotNodeIndex = isempty(src.nodeIndex);
                if hasNotNodeIndex
                    this.incrementNodeCounter();
                    src.setNodeIndex(this.nodeCounter);
                end
            end
        end
        
        %-- C --
        
        function createInputPortInterface( this, iNodeNme, iPortName )
            if isa( this.input, 'biotracs.core.io.Terminal' )
                this.setInput( biotracs.core.io.Input() );
            end
            node = this.getNode(iNodeNme);
            spec = node.getInput().getSpec( iPortName );
            spec.name = [ iNodeNme,':',iPortName ];
            this.addInputSpecs( { spec } );
            this.getInputPort( spec.name ).connectTo( node.getInputPort(iPortName), 'ReplaceConnection', true );
        end
        
        function createOutputPortInterface( this, iNodeNme, iPortName )
            if isa( this.output, 'biotracs.core.io.Terminal' )
                this.setOutput( biotracs.core.io.Output() );
            end
            node = this.getNode(iNodeNme);
            spec = node.getOutput().getSpec( iPortName );
            spec.name = [ iNodeNme,':',iPortName ];
            this.addOutputSpecs( { spec } );
            node.getOutputPort(iPortName).connectTo( this.getOutputPort( spec.name ), 'ReplaceConnection', true );
        end
        
        %-- E --

        function this = exportParams( this, iFilePath, varargin )
            if ~isempty(this.label)
                name = this.label;
            else
                name = class(this);
            end
            
            p = inputParser();
            p.addParameter('DisplayContent', false, @islogical);
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            
            % export parameters
            if nargin <= 1
                iFilePath = fullfile( [this.getParamValue('WorkingDirectory'), '\', name, '.params.xml'] );
            end
            this.exportParams@biotracs.core.mvc.model.Process( iFilePath, 'DisplayContent', p.Results.DisplayContent );
        end
        
        %-- G --
        
        function c = getNodeCounter( this )
            c = this.nodeCounter;
        end
        
        function [ ready ] = getReadyNodes( this, varargin )
            n = getLength( this.listOfNodes );
            ready = {};
            for i=1:n
                node = this.listOfNodes.getAt(i);
                if node.isReady()
                    ready{end+1} = node; %#ok<AGROW>
                end
            end
        end
        
        function [ sources ] = getSourceNodes( this )
            n = getLength( this.listOfNodes );
            sources = {};
            for i=1:n
                node = this.listOfNodes.getAt(i);
                if node.isSource()
                    sources{end+1} = node; %#ok<AGROW>
                end
            end
        end
        
        function [ sinks ] = getSinkNodes( this )
            n = getLength( this.listOfNodes );
            sinks = {};
            for i=1:n
                node = this.listOfNodes{i};
                if node.isSink()
                    sinks{end+1} = node; %#ok<AGROW>
                end
            end
        end
        
        function n = getNode( this, iName )
            if ~this.listOfNodes.hasElement(iName)
                names = strjoin(this.listOfNodes.getElementNames(),''',''');
                error('No node found with name ''%s''. Valid names are {''%s''}.', iName, names);
            end
            n = this.listOfNodes.get(iName);
        end
        
        function n = getNodeAt( this, iIndex )
            n = this.listOfNodes.getAt(iIndex);
        end
        
        %-- H --
        
        function tf = isEnded( this )
            tf = false;
            for i = 1:this.getLength()
                if ~this.getNodeAt(i).isEnded()
                    break;
                end
                tf = true;
            end
        end
        
        %-- I --
        
        function tf = isInterfacedWithTheInputOfNode(this, iNode)
            if ischar(iNode)
                iNode = this.getNode(iNode);
            end
            tf = false;
            n = this.input.getLength();
            for i=1:n
                port = this.input.getPortAt(i);
                for j=1:iNode.getInput().getLength()
                    nodePort = iNode.getInput().getPortAt(j);
                    if port.isConnectedTo( nodePort )
                        tf = true;
                        break;
                    end
                end
            end
        end
        
        function tf = isInterfacedWithTheOutputOfNode(this, iNode)
            if ischar(iNode)
                iNode = this.getNode(iNode);
            end
            tf = false;
            n = this.output.getLength();
            for i=1:n
                port = this.output.getPortAt(i);
                for j=1:iNode.getOutput().getLength()
                    nodePort = iNode.getOutput().getPortAt(j);
                    if nodePort.isConnectedTo(port)
                        tf = true;
                        break;
                    end
                end
            end
        end
        
        %-- L --
        
        function n = getLength( this )
            n = this.listOfNodes.getLength();
        end
        
        %-- R --
        
        function reset( this, iHasToPropagate )
            if nargin == 1 || iHasToPropagate
                iHasToPropagate = true;
            end

            for i=1:getLength(this.listOfNodes)
                node = this.getNodeAt(i);
                node.reset( false );
            end
            
            this.reset@biotracs.core.mvc.model.Process( iHasToPropagate );
        end

        function value = readParamValue( this, iName )
            parts = strsplit( iName, ':' );
            cNode = this;
            for i=1:length( parts )
                if i == length(parts)
                    value = cNode.getConfig().getParamValue( parts{i} );
                else
                    if ~isa( cNode, 'biotracs.core.mvc.model.Workflow' )
                        error('BIOTRACS:Workflow:InvalidNode', 'Node %s is not a biotracs.core.mvc.model.Workflow', strjoin(parts(1:i-1)));
                    end
                    cNode = cNode.getNode( parts{i} );
                end
            end
        end
        
        %-- S --
        
        function this = summary( this, varargin )
            this.summary@biotracs.core.mvc.model.Process( varargin{:} );
            fprintf('<strong>Nodes:</strong>\n');
            fprintf('_____________________________________________________________\n');
            this.listOfNodes.summary( varargin{:} );
        end
        
        %-- W --
        
        function this = writeParamValue( this, iName, iValue )
            parts = strsplit( iName, ':' );
            cNode = this;
            for i=1:length( parts )
                if i == length(parts)
                    cNode.getConfig().updateParamValue( parts{i}, iValue );
                else
                    if ~isa( cNode, 'biotracs.core.mvc.model.Workflow' )
                        error('BIOTRACS:Workflow:InvalidNode', 'Node %s is not a biotracs.core.mvc.model.Workflow', strjoin(parts(1:i-1)));
                    end
                    cNode = cNode.getNode( parts{i} );
                end
            end
        end
        
        function this = writeParamValues( this, varargin )
            for i=1:2:length(varargin)
                iName = varargin{i};
                iValue = varargin{i+1};
                this.writeParamValue( iName, iValue );
            end
        end
        
    end
    
    methods(Access = protected)
        
        %-- A --
        
        function doAttachProcessToOutputResources( ~ )
            %do nothing;
        end
        
        %-- B --
        
        %function doBeforeRun( this )
        %    this.doBeforeRun@biotracs.core.mvc.model.Process();
        %    if ~isempty(this.label)
        %        name = this.label;
        %        if strcmp(name, this.getClassName())
        %            name = this.getClassNameParts('head');
        %        end
        %    else
        %        name = this.getClassNameParts('head');
        %    end
        %    this.logger.writeLog('Starting workflow %s', name);
        %end
        
        
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
        
        function doCopy( this, iCopyable )
            this.listOfNodes = iCopyable.listOfNodes.copy();
            this.nodeCounter = iCopyable.nodeCounter;
        end
        
        %-- E --
        
        function doEmulate( this, varargin )
            this.resetNodeCounter();
            if nargin == 1
                sources = this.getReadyNodes();
                n = length(sources);
                for i=1:n
                    node = sources{i};
                    emulateNode( node );
                end
            else    
                node = this.getNode( varargin{1} );
                emulateNode( node );
            end
            
            function emulateNode( iNode )   
                iNode.emulate();
                if iNode.isEnded()
                    this.paths{end+1} = iNode;
                end
            end
        end
        
        %-- G --
        
        %-- O --

        %-- P --
        
        %-- R --
        
        function doRun( this, varargin )
            this.resetNodeCounter();
            if nargin == 1
                sources = this.getReadyNodes();
                n = length(sources);
                for i=1:n
                    node = sources{i};
                    runNode( node );
                end
            else
                node = this.getNode( varargin{1} );
                runNode( node );
            end
            
            function runNode( iNode )
                iNode.run();
                if iNode.isEnded()
                    this.paths{end+1} = iNode;
                end
            end
        end
        
        %-- S --
        
        function doSetLabelsOfOutputResources( ~ )
            %do nothing;
        end
    end
    
    methods(Access = {?biotracs.core.mvc.model.Workflow, ?biotracs.core.ability.Runnable})
        function incrementNodeCounter( this )
            this.nodeCounter = this.nodeCounter + 1;
        end
        
        function resetNodeCounter( this )
            this.nodeCounter = 0;
        end
        
        function setNodeCounter( this, iCursor )
            this.nodeCounter = iCursor;
        end
        
        function onTriggerChildNode( this, childNode )
            this.logger.writeLog('Running child process %s', childNode.getLabel());
        end
    end
    
    methods( Static )
        
    end
end

