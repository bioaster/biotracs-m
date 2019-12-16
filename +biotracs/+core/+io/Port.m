%"""
%biotracs.core.io.Port
%Base port object. A port contains a data Resource
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.io.Input, biotracs.core.io.Output, biotracs.core.io.InputPort, biotracs.core.io.OutputPort, biotracs.core.mvc.model.Resource
%"""

classdef(Abstract) Port < biotracs.core.ability.Pluggable & biotracs.core.ability.Copyable
    
    properties(SetAccess = protected)
        parent;
        data;
        classOfData = {'biotracs.core.mvc.model.Resource'};
        isRequired = true;
    end
    
    properties(Access = protected)
        hasRecievedData = false;
    end
    
    events
        %onReady;
    end
    
    methods

        function this = Port( iClassOfData, iRequired )
            %#function biotracs.core.mvc.model.Resource
            
            this@biotracs.core.ability.Pluggable();
            this@biotracs.core.ability.Copyable();
            
            if nargin == 0
                this.classOfData = {'biotracs.core.mvc.model.Resource'};
            else
                if ischar(iClassOfData)
                    this.classOfData = { iClassOfData };
                elseif iscellstr(iClassOfData)
                    this.classOfData = iClassOfData;
                else
                    error('Invalid data classes. A cell of string is required');
                end
                
                if nargin >= 2
                   this.isRequired = iRequired; 
                end
            end
            
            %By default use an instance of the first class
            try
                if biotracs.core.utils.isAbstract( this.classOfData{1} )
                    return
                end
                
                %@ToDo: Remove default resource on Port
                this.data = feval( this.classOfData{1} );
            catch exception
                error('BIOTRACS:Port:InvalidResource', 'Cannot create Port.\n%s', this.classOfData{1}, exception.message );
            end                    
        end

        %-- C --
        
        function [ this ] = connectTo( this, varargin )
            this.connectTo@biotracs.core.ability.Pluggable( varargin{:} );
            if this.hasData()
               this.propagate(); 
            end
        end
        
        %-- C --
        
        %-- G --
        
        function oData = getData( this )
            oData = this.data;   
        end
        
        function p = getParent( this )
            p = this.parent;
        end
        
        %-- H --
        
        function [ tf ] = hasData( this )
            tf = this.hasRecievedData;
        end
        
        %-- I --
        
        function tf = isequal( this, iPort )
            tf = this == iPort || isequal(this.data, iPort.data);
        end
        
        function tf = isReady( this )
            tf = this.isDefined() && this.hasRecievedData; %(numel(this.data) ~= 0);
        end
        
        function tf = isDefined( this )
            tf = (numel(this.data) ~= 0);
        end
         
        %-- L--

        %-- R --
        
        function this = reset( this )
            this.data = feval( this.classOfData{1} );
            this.hasRecievedData = false;
        end
        
        %-- S --

        function this = setData( this, iData )
            tf = false;
            for i=1:length(this.classOfData)
                %iData
                %this.classOfData{i}
                if isa(iData, this.classOfData{i})
                    tf = true;
                    break; 
                end
            end
            if ~tf
               process = this.getParent().getParent();
               error('Port:InvalidDataClass', 'Process ''%s''.\nThe resource must be a {''%s''}.\nA %s is given instead.', class(process), strjoin(this.classOfData,''', '''), class(iData));
            end
            this.data = iData;
            this.hasRecievedData = true;
            %this.notify('onReady');
            this.propagate();
        end

        function this = setParent( this, iParent )
            if isa(iParent, 'biotracs.core.io.PortSet')
                this.parent = iParent;
            else
                error('The parent object must be a biotracs.core.io.PortSet');
            end
        end
        
        function setIsRequired( this, tf )
            this.isRequired = tf;
        end
        
        %-- P --
        
        function this = propagate( this, iForce )
            if nargin == 1, iForce = false; end
            if ~this.hasData() && ~iForce, return; end
            n = getLength(this.nextConnectedPluggables);
            for i=1:n
                nextPort = this.nextConnectedPluggables.getAt(i);
                nextPort.setData( this.data );
            end
        end

    end
    
    methods(Access = protected)
        
       function doCopy( this, iIOFlow, varargin )
            this.parent = iIOFlow.parent;   %shallow copy
       end 
        
    end
    
end

