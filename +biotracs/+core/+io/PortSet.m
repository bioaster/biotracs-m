%"""
%biotracs.core.io.PortSet
%Base object that is used to define Input and Output objects.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.ability.Pluggable, biotracs.core.io.Input, biotracs.core.io.Output, biotracs.core.io.IOSpecsHolder
%"""

classdef(Abstract) PortSet < biotracs.core.ability.Pluggable & biotracs.core.io.IOSpecsHolder
    
    properties(Constant)
    end
    
    events
    end
    
    methods

        function this = PortSet( varargin )
            this@biotracs.core.io.IOSpecsHolder( varargin{:} );   
            this@biotracs.core.ability.Pluggable();
        end
        
        %-- A --
        
        %-- C --
        
        function this = connectTo( this, iPortSet, varargin )
            if ~isa(iPortSet, 'biotracs.core.io.PortSet')
                error('PortSet:InvalidPortSet', 'The PortSet is not valid');
            end
            
            % ToDo : Remove connectTo
            % Do no inherit from Pluggable
            this.connectTo@biotracs.core.ability.Pluggable( iPortSet, varargin{:} );

            if ~this.doConnectPorts(iPortSet, varargin{:})
                p = inputParser();
                p.addParameter('ResizeWhenUnmatch', false, @islogical);
                p.KeepUnmatched = true;
                p.parse(varargin{:});
                if p.Results.ResizeWhenUnmatch
                    iPortSet.doResize( this.getLength() );
                end                
                if ~this.doConnectPorts(iPortSet, varargin{:})
                    error('PortSet:CannotConnectPortSet', 'Cannot connect the PortSet. Please ensure that the ports are comptabile.');
                end
            end
        end
        
        %-- D --
        
        function this = disconnectFrom( this, iPortSet )
            if ~isa(iPortSet, 'biotracs.core.io.PortSet')
                error('PortSet:InvalidPortSet', 'The PortSet is not valid');
            end
            
            ports = iPortSet.getElements();
            for i=1:length(ports)
                port = this.getAt(i);
                port.disconnectFrom(ports{i});
            end
            
            % ToDo : Remove connectTo
            % Do no inherit from Pluggable
            this.disconnectFrom@biotracs.core.ability.Pluggable( iPortSet );
        end
        
        %-- G --
        
        %> overload getPrevious
        function prev = getPrevious( this )
            n = this.getLength();
            prev = {};
            for i=1:n
                prevPorts = this.getPortAt(i).getPrevious();
                prev = [prev, cellfun(@getParent, prevPorts.getElements(), 'UniformOutput', false)];
            end
        end
        
        %> overload getNext
        function next = getNext( this )
            n = this.getLength();
            next = {};
            for i=1:n
                nextPorts = this.getPortAt(i).getNext();
                next = [next, cellfun(@getParent, nextPorts.getElements(), 'UniformOutput', false)];
            end
        end
        
        %> @alias of getElementNames()
        function oNames = getPortNames( this )
            oNames = this.getElementNames();
        end
           
        %> @overload method
        function oPort = get( this, iName )
            if this.hasElement(iName)
                oPort = this.get@biotracs.core.io.IOSpecsHolder( iName );
            else
                names = strcat('''', this.getPortNames(), '''');
                error('PortSet:UnknownPortName', 'No port found with name ''%s''. The valid port names are: {%s}\n', iName, strjoin(names, ','));
            end
        end
        
        %> @alias of get()
        function oPort = getPort( this, iName )
            oPort = this.get( iName );
        end
        
        %> @alias of getElementByIndex()
        function oPort = getPortAt( this, iIndex )
            oPort = this.getAt( iIndex );
        end

        %> @alias of getElements()
        function oPorts = getPorts( this )
            oPorts = this.getElements( );
        end
        
        %> @alias of getElementName()
        function oName = getPortNameByIndex( this, iIndex )
            oName = this.getElementName( iIndex );
        end
         
        %-- I --

        function tf = isDefined( this )
            n = this.getLength();
            if n == 0
                tf = false;
                return;
            end
            for i=1:n
                tf = this.getPortAt(i).isDefined();
                if ~tf, break; end
            end
        end
        
        function tf = isReady( this )
            tf = this.isDefined();
            if ~tf, return;  end
            n = this.getLength();
            for i=1:n
                if ~this.getPortAt(i).isRequired, continue; end
                tf = this.getPortAt(i).isReady();
                if ~tf, break; end
            end
        end
  
        %-- R --

        %-- S --
        
        function this = setPortNameByIndex( this, iIndex, iName )
           this.setElementName( iIndex, iName );
        end

        function this = propagate( this, varargin )
            n = this.getLength();
            for i=1:n
                this.getPortAt(i).propagate( varargin{:} );
            end
        end
        
    end
    
    methods (Access = protected)

        function [ tf ] = doConnectPortsUsingNames( this, iPortSet, varargin )
            tf = false;
            listOfports = iPortSet.getElements();
            listOfPortNames = iPortSet.getElementNames();
            for i=1:length(listOfports)
                if ~this.hasElement( listOfPortNames{i} )
                    return;
                end
                port = this.get(listOfPortNames{i});    %retreive the port having the same name
                port.connectTo(listOfports{i}, varargin{:});
            end
            tf = true;
        end
        
        function [ tf ] = doConnectPortsUsingIndexes( this, iPortSet, varargin )
            tf = false;
            try
                for i=1:getLength(this)
                    this.getAt(i).connectTo(iPortSet.getAt(i), varargin{:});
                end
                tf = true;
            catch exception
               fprintf('%s\n', exception.message);
            end
        end
        
        function [ tf ] = doConnectPorts( this, iPortSet, varargin )
            if this.getLength() ~= iPortSet.getLength()
                tf = false; return;
            end
            
            p = inputParser();
            p.addParameter('ConnectionStrategy', 'Auto', @(x)(ischar(x) && any(strcmpi(x,{'Indices', 'Names', 'Auto'}))));
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            if strcmpi(p.Results.ConnectionStrategy, 'Indices')
                tf = this.doConnectPortsUsingIndexes( iPortSet, varargin{:} );
            elseif strcmpi(p.Results.ConnectionStrategy, 'Names')
                tf = this.doConnectPortsUsingNames( iPortSet, varargin{:} );
            elseif strcmpi(p.Results.ConnectionStrategy, 'Auto')
                tf = this.doConnectPortsUsingIndexes( iPortSet, varargin{:} ) || ...
                    this.doConnectPortsUsingNames( iPortSet, varargin{:} );
            else
                error('PortSet:InvalidConnectionStrategy', 'Invalid parameter ''ConnectionStrategy''. Valids values are ''Indices'', ''Names'' or ''Auto'' (default)');
            end
        end
        
    end
   
    
end

