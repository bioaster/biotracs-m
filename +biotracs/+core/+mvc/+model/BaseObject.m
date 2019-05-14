%"""
%biotracs.core.mvc.model.BaseObject
%Defines the BaseObject object. All Model objects inherit the BaseOject.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.core.mvc.view.Workflow, biotracs.core.mvc.model.Process
%"""

classdef BaseObject < biotracs.core.mvc.model.Model
    
    properties (Constant)
    end
    
    properties(SetAccess = protected)
        id = 0;
        label = '';
        repository = '';
        description = '';
        creator = biotracs.core.mvc.model.Operator.empty();
        creationDateTime = biotracs.core.date.Date.empty();
        meta = struct();
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        %> @fn this = BaseObject( iBaseObject )
        function this = BaseObject( varargin )
            this@biotracs.core.mvc.model.Model( varargin{:} );
            this.label = this.className;
            this.bindView( biotracs.core.mvc.view.BaseObject() );	 %bind default view
        end
        
        %-- C --
        
        %-- D --
        
        %-- E --
        
        % Export to .mat file
        function export( this, iFilePath, varargin )
            [folder, filename, ~] = fileparts(iFilePath);
            %if strcmpi(ext, '.mat')
                this.save( fullfile(folder, [filename, '.mat']) );
            %else
            %    error('BIOTRACS:BaseObject:InvalidExportExtension', 'Can only export %s to .mat using save method',class(this));
            %end
        end
        
        %-- G --
        
        function oId = getId( this )
            oId = this.id;
        end
        
        function oRep = getRepository( this )
            oRep = this.repository;
        end
        
        function oLabel = getLabel( this )
            oLabel = this.label;
        end
        
        function oDescription = getDescription( this )
            oDescription = this.description;
        end
        
        function oCreator = getCreator( this )
            oCreator = this.creator;
        end
        
        function oCreationDateTime = getCreationDateTime( this )
            oCreationDateTime = this.creationDateTime;
        end
        
        function oMeta = getMeta( this, iName )
            if nargin == 1
                oMeta = this.meta;
            else
                oMeta = this.meta.(iName);
            end
        end
        
        %-- I --
        
        function tf = isEqualTo( this, iDataObject )
            tf = false;
            if ~isa(iDataObject, 'biotracs.core.mvc.model.BaseObject')
                return
            end
            
            tf = isequal(this.meta, iDataObject.meta);
        end
        
        %-- P --

        %-- S --
        
        function save( this, iFilePath ) %#ok<INUSL>
            [filePath, ~, ~] = fileparts(iFilePath);
            if ~isfolder(filePath) && ~mkdir(filePath)
                error('BIOTRACS:BaseObject:CouldNotCreateFileDir','Check write permissions in the directory %s', filePath);
            end
            save( iFilePath, 'this', '-mat' );
        end

        % Set the description of the object
        %> @param[in] iDescription [string] Description of the object
        %> @throw An error is triggered if an invalid @a iDescription is given
        function this = setDescription( this, iDescription )
            if isa(iDescription, 'char')
                this.description = iDescription;
            else
                error('Wrong argument, a string is required');
            end
        end
        
        function this = setLabel( this, iLabel )
            if isa(iLabel, 'char')
                this.label = iLabel;
            else
                error('Wrong argument, a string is required');
            end
        end
        
        % Set the respository of files
        function this = setRepository( this, iRepository )
            if isa(iRepository, 'char')
                this.repository = iRepository;
            else
                error('Wrong argument, a string is required');
            end
        end
        
        function this = setCreator( this, iCreator )
            if isa(iCreator, 'biotracs.core.mvc.model.Operator')
                this.creator = iCreator;
            else
                error('Invalid argument, a biotracs.core.mvc.model.Operator is required')
            end
        end
        
        function this = setCreationDateTime( this, iCreationDatetime )
            this.creationDateTime = iCreationDatetime;
        end
        
        function this = setMeta( this, iMeta )
            this.meta = iMeta;
        end
    end
    
    methods(Access = protected)
        
        function doCopy( this, iBaseObject, varargin )
            this.doCopy@biotracs.core.mvc.model.Model( iBaseObject, varargin{:} );
            this.id                 = iBaseObject.id;
            this.label              = iBaseObject.label;
            this.repository         = iBaseObject.repository;
            this.description        = iBaseObject.description;
            this.creator            = iBaseObject.creator;
            this.creationDateTime   = iBaseObject.creationDateTime;
            
            %copy meta
            this.doCopyMeta( iBaseObject );
        end
           
        function doCopyMeta( this, iBaseObject )
            names = fieldnames(this.meta);
            for i=1:length(names)
                if isfield( iBaseObject.meta, names{i} )
                    this.meta.(names{i}) = iBaseObject.meta.(names{i});
                end
            end
        end
    end
    
    % -------------------------------------------------------
    % Static methods
    % -------------------------------------------------------
    
    methods(Static)
        
        % Static method to import objects from a .mat file
        %> @param[in] iFilePath Path of the file to import
        %> @return A biotracs.core.mvc.BaseObject
        function this = import( iFilePath, varargin )
            try
                o = load( iFilePath, '-mat', 'this' );
                this = o.this;
            catch err
                error('%s\n%s', 'Cannot import the object', err.message());
            end
        end
        
    end
    
end

