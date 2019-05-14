%"""
%biotracs.core.io.IOSpecsHolder
%IOSpecsHolder objects define the specifications used to build input and output objects. The specs are defined as structures.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.io.Input, biotracs.core.io.Output, biotracs.core.io.PortSet, biotracs.core.io.InputPort, biotracs.core.io.OutputPort, biotracs.core.io.Port
%"""

classdef(Abstract) IOSpecsHolder < biotracs.core.container.Set
    
    properties(SetAccess = protected)
        % Input/Output specifications
        % Is a cell of struct
        % inputs = {
        %	struct(
        %	 'name','NameOfThePort',
        %	 'class','ClassNameOfThePort',
        %	 'multiplicity','MultiplicityOfThePort',
        %	),
        %	strcut(...), ...
        % }
        parent;
        specs;
        isResizable = false;
    end

    
    methods
        
        % Contructor
        %> @see biotracs.core.container.Set
        function this = IOSpecsHolder( varargin )
            this@biotracs.core.container.Set();
            this.classNameOfElements = {'biotracs.core.io.Port'};
        end
        
        %-- A --
        
        function [this, oName] = add( this, varargin )
            [ this, oName ] = this.add@biotracs.core.container.Set( varargin{:} );
            element = varargin{1};
            element.setParent(this);
        end
        
        function this = addSpecs( this, iSpecs )
            if ~iscell(iSpecs)
                error('BIOTRACS:IOSpecsHolder:InvalidSpecs', 'Specs must be cell of struct');
            end
            this.specs = horzcat(this.specs, iSpecs);
            this.doCreatePortsFromSpecs( iSpecs, true );
        end
        
        %-- F --

        %-- G --
        
        function p = getParent( this )
            p = this.parent;
        end
        
        function oSpecs = getSpecs( this )
            oSpecs = this.specs;
        end

        function oSpec = getSpec( this, iName )
            idx = this.getElementIndexByName(iName);
            if isempty(idx)
                names = this.getElementNames();
                error('BIOTRACS:IOSpecsHolder:UnknownSpecs', 'No specs exist with name ''%s''. Valid names are {''%s''}.', iName, strjoin(names, ''','''));
            end
            oSpec = this.specs{idx};
        end

        function oSpec = getSpecAt( this, iIndex )
            oSpec = this.specs{iIndex};
        end
        
        %-- R --
        
        function this = resize( this, iNbIOPorts, varargin )
            if ~this.isResizable
                error('BIOTRACS:IOSpecsHolder:NotResizable','This IOSpecsHolder is not resizable');
            end
            this.doResize( iNbIOPorts, varargin{:} );
        end

        %-- S --

        function this = setAt( this, varargin )
            this.setAt@biotracs.core.container.Set( varargin{:} );
            element = varargin{2};
            element.setParent(this);
        end
        
        function this = setElements( this, varargin )
            this.setElements@biotracs.core.container.Set( varargin{:} );
            elements = varargin{1};
            cellfun( @(x)setParent(x,this), elements );
        end
        
        function this = setIsResizable( this, tf )
            this.isResizable = tf;
        end
        
        function this = setParent( this, iParent )
            if isa(iParent, 'biotracs.core.ability.Runnable')
                this.parent = iParent;
            else
                error('The parent object must be a biotracs.core.ability.Runnable');
            end
            
            for i=1:this.getLength()
               this.getAt(i).setParent(this); 
            end
        end
        
        function this = setSpecs( this, iSpecs )
            if ~iscell(iSpecs)
                error('BIOTRACS:IOSpecsHolder:InvalidSpecs', 'Specs must be a cell of struct')
            end
            this.removeAll();
            this.specs = iSpecs;
            this.doCreatePortsFromSpecs(iSpecs, true);
        end
        
        %-- U --
        
        % Update an input spec
        function this = updateSpecs( this, iSpecs )
            n = length(iSpecs);
            for j=1:n
                currentSpec = iSpecs{j};
                specName = currentSpec.name;
                idx = this.getElementIndexByName(specName);
                if ~isempty(idx)
                    this.specs{idx} = currentSpec;
                else
                    names = this.getElementNames();
                    error('BIOTRACS:IOSpecsHolder:UnknownSpecs', 'No specs exist with name ''%s''. Valid names are {''%s''}.', specName, strjoin(names,''','''));
                end
            end
            this.doCreatePortsFromSpecs( iSpecs, false );
        end
    end
    
    
    methods
        
        function addElements( varargin )
            error('BIOTRACS:IOSpecsHolder:AccessRestricted', 'The access to this function is restricted');
        end
        
        function concat( varargin )
            error('BIOTRACS:IOSpecsHolder:AccessRestricted', 'The access to this function is restricted');
        end
        
    end
    
    
    methods (Access = protected)
        
        function doCopy( this, iIOSpecsHolder, varargin )
            this.doCopy@biotracs.core.container.Set( iIOSpecsHolder, varargin{:} );
            this.specs = iIOSpecsHolder.specs;
            
            % /!\ To avoid cyclic copy
            % Assign the parent object of elements instead of invoking doCopy
            % this.doCopy@biotracs.core.io.IOPort( iIOSpecsHolder, varargin{:} );
            n = length(iIOSpecsHolder.elements);
            for i=1:n
                this.elements{i}.setParent(this);
            end
        end

        % Create input or output ports according to the specs
        %> @param[in] iSpecs Specifications
        function doCreatePortsFromSpecs( this, iSpecs, hasToAddNew )
            n = length(iSpecs);
            portCalss = this.classNameOfElements{1};
            
            if isempty(portCalss) 
                error('BIOTRACS:IOSpecsHolder:InvalidPort', 'Invalid port. A ''biotracs.core.io.Port'' is expected' );
            end

            for i=1:n
                if ~isfield(iSpecs{i}, 'name')
                    error('BIOTRACS:IOSpecsHolder:InvalidSpecs', 'Invalid specs; The name of the port is not defined');
                end

                % class
                if isfield(iSpecs{i}, 'class')
                    dataClass = iSpecs{i}.class;
                    if ischar(dataClass)
                        dataClass = { dataClass };
                    end
                else
                    error('BIOTRACS:IOSpecsHolder:InvalidSpecs', 'Invalid specs; The class of the data is not defined');
                end
                
                % required
                if isfield(iSpecs{i}, 'required')
                    isRequired = iSpecs{i}.required;
                else
                    isRequired = true;
                end
                
                % multiplicity
                if isfield(iSpecs{i}, 'multiplicity') && iSpecs{i}.multiplicity >= 1
                    multiplicity = iSpecs{i}.multiplicity;
                else
                    multiplicity = 1;
                end
 
                % create ports
                for j=1:multiplicity
                    port = feval( portCalss, dataClass, isRequired );
                    port.setParent(this);
                        
                    if multiplicity > 1
                        name = strcat(iSpecs{i}.name,'#',num2str(j));
                    else
                        name = iSpecs{i}.name;
                    end
                    
                    if hasToAddNew
                        this.add( port, name );
                    else
                        this.set( name, port );
                    end
                end
            end
        end

        function this = doResize( this, iNbPorts, varargin )
            if iNbPorts <= 0
                error('BIOTRACS:IOSpecsHolder:InvalidNbPorts', 'The number of ports must be >= 1');
            end
            newSpecs = this.getSpecs();
            newSpecs{1}.multiplicity = iNbPorts;
            newSpecs{1}.name = regexprep(newSpecs{1}.name, '(#\d+)$', '');
            if nargin >= 3
                iClass = varargin{1};
                if ~ischar(iClass)
                    error('BIOTRACS:IOSpecsHolder:InvalidClassName', 'Invalid class name. A string is required');
                end
                newSpecs{1}.class = iClass;
            end
            if length(newSpecs) > 1
                newSpecs(2:end) = []; % remove other ports
            end

            % @ToDo : Only get next PortSet
            %         Or remove this functionnality
            nextPortSet = this.getNext();
            for i=1:length(nextPortSet)
                this.disconnectFrom(nextPortSet{i});
            end
            
            this.setSpecs( newSpecs );
            
            %reconnect
            for i=1:length(nextPortSet)
                this.connectTo(nextPortSet{i}, 'ResizeWhenUnmatch', true);
            end
        end
        
    end
    
end

