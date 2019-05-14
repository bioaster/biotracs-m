%"""
%biotracs.data.model.DataFile
%DataFile object defines a pointer to the path of a folder/file on the disk 
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.data.model.DataFileSet, biotracs.data.model.DataObject
%"""

classdef DataFile < biotracs.data.model.DataObject
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        %> @param[in] iRepository [string, default = ''] Repository of the file
        function this = DataFile( iFilePath )
            if nargin == 0, iFilePath = ''; end
            this@biotracs.data.model.DataObject( );
            [folder, filename, ext] = fileparts(iFilePath);
            this.dataType = 'char';
            this.setData( fullfile(iFilePath) );
            
            this.setLabel( filename );
            this.setDescription( [...
                'DataFile object', ...
                'Name: ', filename, '; '...
                'Extension: ', ext, '; '...
                'Directory: ', folder, '; '...
                'Path: ', iFilePath, '. '...
                ]);
        end
        
        %-- E --
        
        %Copy to another path
        function export( this, iOutputDirPath )
            if ~isfolder(iOutputDirPath) && ~mkdir(iOutputDirPath)
                error('Cannot create output directory');
            end
            filePath = [iOutputDirPath, '/', this.getName(), '.', this.getExtension()];
            if exists( this.getPath(), 'file' )
                [status, message] = copyfile( this.getPath(), filePath );
                if ~status
                    biotracs.core.env.Env.writeLog('Cannot export %s.\n%s', this.getPath(), message);
                end
            else
                biotracs.core.env.Env.writeLog('Cannot export %s. File not found.', this.getPath());
            end
        end
        
        %-- G --
        
        % Alias of getRespository()
        function path = getPath( this )
            path = this.data;
        end
        
        function [folder, filename, ext] = getParts( this )
            [folder, filename, ext] = fileparts( this.data );
            if ~isempty(ext)
                ext(1) = [];
            end
        end
        
        function dirpath = getDirPath( this )
            [dirpath, ~, ~] = fileparts( this.data );
        end
        
        function filename = getName( this )
            [~, filename, ~] = fileparts( this.data );
        end
        
        % Get file extension
        %> @return the last extension of the file
        %> @return list of all extensions
        function [lastExt, extList] = getExtension( this )
            [~, filename, lastExt] = fileparts( this.data );
            if ~isempty(lastExt)
                lastExt(1) = [];
            end
            if nargout == 2
                extList = {lastExt};
                while true
                    [~, filename, ext] = fileparts(filename);
                    if ~isempty(ext)
                        ext(1) = [];
                    else
                        break;
                    end
                    extList{end+1} = ext; %#ok<AGROW>
                end
            end
        end
        
        %-- E --
        
        function tf = exist( this )
            tf = this.isfile() || this.isfolder();
        end
        
        %-- I --
        
        function tf = isfile( this )
            tf = isfile( this.data );
        end
        
        function tf = isfolder( this )
            tf = isfolder( this.data );
        end
        
    end
    
end

