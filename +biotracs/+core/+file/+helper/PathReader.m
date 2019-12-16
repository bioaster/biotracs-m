%"""
%biotracs.core.file.helper.PathReader
%Helper class that provides some functionalities to read folders
%(recursively) as DataFile and/or DataFileSet objects. It is namely used by the
%FileImporter object.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.adapter.model.FileImporter
%"""

classdef PathReader < biotracs.core.helper.Helper
    
    properties
    end
    
    methods (Static)
        
        % Parse a folder an return the list of subfiles and subfolders
        %> @param[in] iFolder Folder in which data files are located
        %> @param[in] options
        %   'FileExtensionFilter' Extension of the files to load,
        %	default = '.*'
        %	'FileIndexesFilter' Indexes of the files to load.
        %	By default, all valid files are loaded
        %	(e.g. [1,2] to on load the 1st and 2nd valid file)
        %   'Recursive' true or false
        %@return	 A ResourceSet of DataFile that contains the list of DataFile
        function [oDataFiles, logStr] = read( iPath, varargin )
            p = inputParser();
            p.addParameter('FileDirectoryFilter', '.*', @ischar);
            p.addParameter('FileExtensionFilter', '.*', @ischar);
            p.addParameter('FileNameFilter', '.*', @ischar);
            p.addParameter('Recursive', false, @islogical);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            %iPath
  
            iPath = fullfile(iPath);
            oDataFiles = biotracs.data.model.DataFileSet(0);
            logStr = {};
            if isfolder(iPath)
                files = dir(iPath);
                %currentFileIndex = 1;
                for i=1:length(files)
                    if any(strcmpi(files(i).name, {'.', '..'}))
                        continue;
                    end
                                        
                    filePath = fullfile(iPath, files(i).name);
                    if isfolder( filePath ) && p.Results.Recursive
                        [tmpDataFiles, tmpLogStr] = biotracs.core.file.helper.PathReader.read( filePath, varargin{:} );
                        [oDataFiles] = concat( oDataFiles, tmpDataFiles );
                        logStr = [logStr, tmpLogStr];
                    else
                        [dirname,name,ext] = fileparts( filePath );
                        extPattern = strrep(p.Results.FileExtensionFilter,',','|');
                        
                        isValidExtension = isempty(extPattern) || ...
                            strcmpi(extPattern, ext) || ...
                            ~isempty(regexpi(ext, extPattern, 'once'));
                        
                        isValidFileName = isempty(p.Results.FileNameFilter) || ...
                            strcmp(p.Results.FileNameFilter, name) || ...
                            ~isempty(regexp(name, p.Results.FileNameFilter, 'once'));
                        
                        isValidDirName = isempty(p.Results.FileDirectoryFilter) || ...
                            strcmp(p.Results.FileDirectoryFilter, dirname) || ...
                            ~isempty(regexp(dirname, p.Results.FileDirectoryFilter, 'once'));
                        
                        if isValidExtension && isValidFileName && isValidDirName
                            logStr{end+1} = ['Load file "',filePath,'"'];
                            df = biotracs.data.model.DataFile(filePath);
                            oDataFiles.add( df, filePath );
                        end
                        
                        %currentFileIndex = currentFileIndex + 1;
                    end
                end
            elseif isfile(iPath)
                [~,~,ext] = fileparts( iPath );
                extPattern = strrep(p.Results.FileExtensionFilter,',','|');
                isValidExtension = isempty(extPattern) || ...
                    strcmpi(extPattern, ext) || ...
                    ~isempty(regexpi(ext, extPattern, 'once'));
                
                if isValidExtension
                    logStr{end+1} = ['Load file "',iPath,'"'];
                    filePath = fullfile(iPath);
                    df = biotracs.data.model.DataFile(filePath);
                    oDataFiles.add( df, filePath );
                end
            else
                error('BIOTRACS:PathReader:PathAccessRestricted', 'Path "%s" is not found. Please check that the path exists or the access rights.',iPath);
            end
        end
        
    end
    
end

