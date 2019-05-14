%"""
%biotracs.core.mvc.model.Resource
%Defines the resource object. Resource objects are transformed and created by Process objects.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.core.mvc.model.Process, biotracs.core.mvc.model.ResourceSet, biotracs.core.mvc.view.Resource
%"""

classdef Resource < biotracs.core.mvc.model.BaseObject
    
    properties(SetAccess = protected)
    end
    
    properties(SetAccess = protected, Transient = true)
        process;
    end
    
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Resource( iResource )
            %this@biotracs.core.io.IOFlow();
            this@biotracs.core.mvc.model.BaseObject();
            if nargin == 0
                this.process = biotracs.core.mvc.model.Process.empty();
            elseif isa( iResource, 'biotracs.core.mvc.model.Resource' )
                this.doCopy( iResource ); % copy constructor
            else
                error('BIOTRACS:Resource:Resource:InvalidArguments', 'Invalid argument. A ''biotracs.core.mvc.model.Resource'' is expected');
            end
        end
        
        %-- A --

        %-- C --
        
        %-- D --
        
        function this = discardProcess( this )
            this.process = biotracs.core.mvc.model.Process.empty();
        end

        %-- G --
        
        function e = getProcess( this )
            e = this.process;
        end
        
        function oSibling = getSibling( this, iSiblingName )
            if this.hasSiblings()
                oSibling = this.process.getOutputPortData(iSiblingName);
            else
                oSibling = biotracs.core.mvc.model.Resource.empty();
            end
        end
        
        %-- H --
        
        function tf = hasSiblings( this )
            tf = ~this.process.isNil() && ...
                this.process.isEnded() && ...
                getLength(this.process.output) > 0;
        end
        
        function tf = hasSibling( this, iSiblingName )
            o = this.process.getOutput();
            tf = o.hasElement(iSiblingName);
        end
        
        %-- I --
        
        function tf = areSiblings( this, iSiblingResource )
            o = this.process.getOutput();
            for i=1:getLength(o)
                tf = ( iSiblingResource == o.getAt(i).getData() );
                if tf
                    return;
                end
            end
        end

        %-- L --

        %-- P --
        
        %-- R --

        %-- S --
        
        % setProcess
        %> @param[in] iProcess [biotracs.core.mvc.model.Process class] Process that produced this Resource
        function this = setProcess( this, iProcess )
            if isa(iProcess, 'biotracs.core.mvc.model.Process')
                if iProcess.isNil()
                    error('BIOTRACS:Resource:SetProcess:NilProcessNotAllowed', 'The given process is a nil object. Please use method discardProcess() to remove the process');
                elseif this.process.isNil() || this.process.isEngine()
                    this.process = iProcess;
                elseif this.process ~= iProcess
                    error('BIOTRACS:Resource:SetProcess:ProcessAlreadyDefined', 'Cannot overwrite existing process %s of resource %s', class(this.process), class(this));
                end
            else
                error('BIOTRACS:Resource:SetProcess:InvalidProcess', 'Invalid argument; A biotracs.core.mvc.model.Process is required');
            end
        end
        
        %-- S --
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function doCopy( this, iResource, varargin )
            %p = inputParser();
            %p.addParameter('IgnoreProcess', false, @islogical);
            %p.KeepUnmatched = true;
            %p.parse(varargin{:});
            
            this.doCopy@biotracs.core.mvc.model.BaseObject( iResource );
            
            %/!\ Neither copy the parent process nor the siblings
            
%             isSameRecourceType = strcmp( class(iResource), class(this) );
%             if ~p.Results.IgnoreProcess && isSameRecourceType
%                 %shallow copy
%                 this.process = iResource.process;
%                 
%                 %only copy siblings if the the process is copied
%                 this.siblings = iResource.siblings.copy( varargin{:} );
%             end
        end
        
    end
    
end
