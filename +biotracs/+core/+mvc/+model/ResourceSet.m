%"""
%biotracs.core.mvc.model.ResourceSet
%Defines the resource set object. A ResourceSet is a collection of Resource objects.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.core.mvc.model.Resource, biotracs.core.mvc.view.ResourceSet
%"""

classdef ResourceSet < biotracs.core.container.Set & biotracs.core.mvc.model.Resource
    
    properties(Constant)
    end
    
    properties(Dependent = true)
    end
    
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        %> @param[in] iArg [integer | object] Spectrum set specfications
        % A number of elements (for memory pre-allocation) or A object that
        % will be used to fill the SpectrumSet if possible
        function this = ResourceSet( varargin )
            this@biotracs.core.container.Set( );
            this@biotracs.core.mvc.model.Resource();
            
            if nargin == 0
                this.classNameOfElements = {'biotracs.core.mvc.model.Resource'};
            elseif isnumeric( varargin{1} )
                this.allocate( varargin{1} );
                if nargin == 2, this.setClassNameOfElements( varargin{2} ); end
            elseif isa(varargin{1}, 'biotracs.core.mvc.model.ResourceSet')
                % copy constructor
                this.doCopy( varargin{1} );
            else
                error('Invalid argument');
            end
        end
        
        %-- A --

        %-- C --
        
        function removeAll(this)
            this.prepareForAlteration();
            this.removeAll();
        end
        
        %-- D --
        
        function this = discardProcess( this, varargin )
            this.discardProcess@biotracs.core.mvc.model.Resource();
            p = inputParser();
            p.addParameter('Recursive', true, @islogical);
            p.parse(varargin{:});
            if p.Results.Recursive
                for i=1:this.getLength()
                    element = this.getAt(i);
                    if ~element.isNil()    %element can be nil
                        element.discardProcess();
                    end
                end
            end
        end
        
        %-- E --
        
        function export( this, iFilePath, varargin )
            p = inputParser();
            p.addParameter('NameFilter', '.*', @ischar);
            p.parse(varargin{:});
 
            [dirname, filename, ext] = fileparts(iFilePath);
            if ~isempty(ext)
                iFilePath = fullfile(dirname, filename);
            else
                ext = '.mat';
            end
            
            for i=1:this.getLength()
                r = this.getAt(i);
                if isNil(r)
                    continue;
                end
                
                lbl = r.getLabel();
                name = this.getElementName(i);
                if ~strcmp(p.Results.NameFilter,'.*')
                    if isempty(regexp(name, p.Results.NameFilter, 'once'))
                        continue;
                    end
                end

                if biotracs.core.utils.isuuid(name)
                    slugname = biotracs.core.utils.slugify(lbl);
                else
                    slugname = biotracs.core.utils.slugify(name);
                end

                r.export( fullfile(iFilePath, [slugname,ext]) )
            end
        end
        
        %-- I --

        %-- G --
        
        function resource = getElementById( this, iId )
			resource = [];
            for i=1:this.getLength()
                if strcmp(this.elements{i}.id, iId)
                    resource = this.elements{i};
                    return;
                end
            end
            %error('This ResourceSet does not exist');
        end
        
        function resource = getElementByLabel( this, iLabel )
            for i=1:this.getLength()
                if strcmp(this.elements{i}.label, iLabel)
                    resource = this.elements{i};
                    return;
                end
            end
            error('This ResourceSet does not exist');
        end
        
        function listOfIds = getElementIds( this )
            n = this.getLength();
            listOfIds = cell(1,n);
            for i=1:n
                listOfIds{i} = this.elements{i}.id;
            end
        end

        function listOfLabels = getElementLabels( this )
            n = this.getLength();
            listOfLabels = cell(1,n);
            for i=1:n
                listOfLabels{i} = this.elements{i}.label;
            end
        end
        
        %-- H --
        
        function tf = hasElementsOfSameClass( this )
            n = this.getLength();
            if n <= 1, tf = true; return; end
            tf = false;
            for i = 2:n
                tf = strcmp( class(this.getAt(i)), class(this.getAt(i-1)) );
                if ~tf, return; end
            end
        end
        
        %-- I --
        
        function tf = isEqualTo( this, iResourceSet, varargin )
            tf = this.isEqualTo@biotracs.core.container.Set( iResourceSet, varargin{:} )...
                && this.isEqualTo@biotracs.core.mvc.model.Resource( iResourceSet, varargin{:} );
        end
        
        %-- P --
        
        %-- R --

        %-- S --

        % Set process
        %> @param[in] iProcess The process that produced this ResourceSet
        %> @param[in, optional] 'Recursive' Set True to propagate, false
        %  otherwise
        function this = setProcess( this, iProcess, varargin )
            p = inputParser();
            p.addParameter('Recursive', true, @islogical);
            p.parse(varargin{:});
            this.setProcess@biotracs.core.mvc.model.Resource( iProcess );
            if p.Results.Recursive
                for i=1:this.getLength()
                    element = this.getAt(i);
                    if ~element.isNil()    %element can be nil
                        element.setProcess( iProcess );
                    end
                end
            end
        end
        
        function setLabelsOfElements( this, iLabels )
            n = getLength(this);
            if n == 0, return; end
            
            if ischar(iLabels)
                iLabels = repmat( {iLabels}, 1,n );
            end

            for i=1:n
                elt = this.getAt(i);
                if numel(elt) ~= 0
                    elt.setLabel( iLabels{i} );
                end
            end
            
        end

    end
    
    % -------------------------------------------------------
    % Static
    % -------------------------------------------------------
    
    methods(Static)
        %-- I --
    
        % @ToDo
%         function this = import( iFilePath, iClassName )
%             if nargin == 1
%                 iClassName = 'biotracs.core.model.mvc.ResourceSet';
%             end
%             
%             [dirname, folder, ext] = fileparts(iFilePath);
%             if isfolder(iFilePath)
%                 this = feval(iClassName);
%                 files = dir(iFilePath);
%                 for i=1:length(files)
%                     %@ToDo ...
%                 end
%             elseif isfile(iFilePath) && strcmpi(ext, '.mat')
%                 biotracs.core.mvc.model.Resource.import(iFilePath)
%             else
%                 error('BIOTRACS:ResourceSet:Import', 'Invalid file type. A .mat file or a folder is required to import a resource set')
%             end
%         end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        %-- C --
        
        function doCopy( this, iResourceSet, varargin )
            this.doCopy@biotracs.core.container.Set( iResourceSet, varargin{:} );
            this.doCopy@biotracs.core.mvc.model.Resource( iResourceSet, varargin{:} );
        end
        
    end
    
end
