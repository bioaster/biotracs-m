%"""
%biotracs.core.ability.Pluggable
%Base class to handle Pluggable objects. It defines i/o ports
%connection rules. A Pugglable is an object that can
%be plugged to another Pluggable. It is used to build chains of Pluggable
%(e.g. processes are a pluggables that are plugged together to build
%workflows)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.mvc.model.Workflow, biotracs.core.mvc.model.Process
%"""

classdef (Abstract) Pluggable < handle
    
    
    properties(SetAccess = protected)
        uid;
    end
    
    properties(Access = protected)
        %> list of Pluggables connected to this Pluggable
        nextConnectedPluggables;
        previousConnectedPluggables;
    end
    
    methods
        
        function this = Pluggable()
            this@handle();
            this.uid = biotracs.core.utils.uuid();
            this.nextConnectedPluggables = biotracs.core.container.Set(0,'biotracs.core.ability.Pluggable');
            this.previousConnectedPluggables = biotracs.core.container.Set(0,'biotracs.core.ability.Pluggable');
        end
        
        %-- C --
        
        function [ this ] = connectTo( this, varargin )
            if isempty(varargin)
                error('BIOTRACS:Pluggable:InvalidArguments', 'No element to connect');
            end
            
            n = length(varargin);
            for i=1:n
                if ~isa(varargin{i}, 'biotracs.core.ability.Pluggable')
                    break;
                end
            end
            
            if i == n
                listOfPluggablesToConnect = varargin;
                varargin = {};
            else
                listOfPluggablesToConnect = varargin(1:i-1);
                varargin(1:i-1) = [];
            end
            
            p = inputParser();
            p.addParameter('ReplaceConnection', false, @islogical);
            p.KeepUnmatched = true;
            p.parse(varargin{:});

            %connect all the elements in listOfPluggablesToConnect
            for i=1:length(listOfPluggablesToConnect)
                receiver = listOfPluggablesToConnect{i};
                if this.isConnectedTo( receiver ) , continue; end
                if receiver.isReceiver()
                    if p.Results.ReplaceConnection
                        prevPluggables = receiver.previousConnectedPluggables;
                        for j=1:getLength(prevPluggables)
                            donnor = prevPluggables.getAt(j);
                            donnor.disconnectFrom( receiver );
                        end
                    else
                        error( 'BIOTRACS:Pluggable:AlreadyConnected', 'The port is already connected as receiver. Set parameter ''ReplaceConnection'' to True to force connection' );
                    end
                end
                this.nextConnectedPluggables.add(receiver, receiver.uid);
                receiver.previousConnectedPluggables.add(this, this.uid);
            end            
        end
        
        %-- D --
        
        function this = disconnectFrom( this, iPluggable )
            if this.isConnectedTo( iPluggable )
                this.nextConnectedPluggables.remove(iPluggable.uid);
                iPluggable.previousConnectedPluggables.remove(this.uid);
            end
        end
        
        %-- G --
        
        function p = getNext( this )
            p = this.nextConnectedPluggables;
        end
        
        function p = getPrevious( this )
            p = this.previousConnectedPluggables;
        end
        
        %-- I --
        
        function tf = isClassCompatibleWith( varargin )
            tf = true;
        end
        
        function tf = isConnected( this )
            tf = this.isReceiver() || this.isDonnor();
        end
        
        function tf = isReceiver( this )
            tf = ~isEmpty(this.previousConnectedPluggables);
        end
        
        function tf = isDonnor( this )
            tf = ~isEmpty(this.previousConnectedPluggables);
        end
        
        function tf = isConnectedTo( this, iPluggable )
            tf =  this.nextConnectedPluggables.hasElement( iPluggable.uid ) || ...
                this.previousConnectedPluggables.hasElement( iPluggable.uid );
        end
        
    end
    
    methods( Abstract )
        [ this ]    = propagate( this, varargin );
    end
    
end
