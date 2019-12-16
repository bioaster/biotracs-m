%"""
%biotracs.core.parser.model.BaseParser
%Base parser class
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.parser.model.BaseParserConfig
%"""

classdef (Abstract) BaseParser < biotracs.core.mvc.model.Process
    
    properties(SetAccess = protected)
        %filePath;
        %format;
        data;       %biotracs.core.mvc.model.Resource
    end
       
    properties(Access = protected)
        fileCursor = 0;
    end
    
  	% -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = BaseParser()
            %#function biotracs.core.parser.model.BaseParserConfig
            
            this@biotracs.core.mvc.model.Process();
            % enhance inputs specs
            this.addInputSpecs({...
                struct(...
                'name', 'DataFile',...
                'class',  {{'biotracs.data.model.DataFile', 'biotracs.data.model.DataFileSet'}} ...
                )...
                });
            
            % enhance outputs specs
            this.addOutputSpecs({...
                struct(...
                'name', 'ResourceSet',...
                'class', 'biotracs.core.mvc.model.ResourceSet' ...
                )...
                });
        end
        
        %-- F -

        %-- G --
        
        function oData = getData( this )
            oData = this.data;
        end
        
    end
    
    % -------------------------------------------------------
    % Abstract protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function [ resultSet ] = doCreateOutputPortData( this, iElementClass )
            resourceSetOutputClass = this.config.getParamValue('OutputPortDataClass');
            if ~isempty(resourceSetOutputClass)
                resultSet = feval( resourceSetOutputClass );
            elseif exist( [iElementClass,'Set'], 'class' )
                resultSet = feval( [iElementClass,'Set'] );
                if ~isa( resultSet, 'biotracs.core.mvc.model.ResourceSet' )
                    resultSet = biotracs.core.mvc.model.ResourceSet();
                end
            else
                resultSet = biotracs.core.mvc.model.ResourceSet();
            end
        end
        
        function doRun( this )
            dataObject = this.getInputPortData('DataFile');
            if isa(dataObject, 'biotracs.data.model.DataFile')
                this.fileCursor = 1;
                [ results, resultNames ] =  this.doRunSingleDataFile( dataObject );
            elseif isa(dataObject, 'biotracs.data.model.DataFileSet')
                n = getLength(dataObject);
                results = cell(1,n);
                resultNames = cell(1,n);
                for i=1:n
                    this.fileCursor = i;
                    dataFile = dataObject.getAt(i);
                    [ results{i}, resultNames{i} ] = this.doRunSingleDataFile( dataFile );
                end  
                results = horzcat(results{:});
                resultNames = horzcat(resultNames{:});
            else
                error('A biotracs.data.model.DataFile or biotracs.data.model.DataFileSet is required. A %s is passed instead.', class(dataObject));
            end

            areNamesEmpty = isempty(resultNames) || all(cellfun(@isempty, resultNames));
            if areNamesEmpty
                error('No file parsed. Please check input data files');
            end

            resultSet = this.getOutputPortData( 'ResourceSet' );
            n = length(results);
            resultSet.allocate(n)...
                    .setElements( results, resultNames )...
                    .setLabel( resultNames{1} );
            this.setOutputPortData( 'ResourceSet',  resultSet );
        end

        
        function [ results, resultNames ] = doRunSingleDataFile( this, iDataFile )
            baseFilePath = iDataFile.getPath();
            if isempty(baseFilePath)
               error('Invalid file path. The file path is an empty string'); 
            end
                            
            uncompressedFilePath = this.doUncompressFile( iDataFile );
            isUncompressed = ~isempty(uncompressedFilePath) && exist(uncompressedFilePath, 'file');
            if isUncompressed
                filePath = uncompressedFilePath;
            else
                filePath = baseFilePath;
            end
                        
            if isempty(filePath)
                error('The path of the input DataFile is empty.');
            end

            if isfolder(filePath)
                dataFileSet = biotracs.core.file.helper.PathReader.read( ...
                    filePath, ...
                    'FileDirectoryFilter', this.config.getParamValue('FileDirectoryFilter'), ...
                    'FileExtensionFilter', this.config.getParamValue('FileExtensionFilter'), ...
                    'FileNameFilter', this.config.getParamValue('FileNameFilter'), ...
                    'Recursive', this.config.getParamValue('Recursive') ...
                );
                dataFileList = dataFileSet.getElements();
                n = length(dataFileList);
                results = cell(1,n);
                resultNames = cell(1,n);
                if n == 0
                    disp('No files found in the repository');
                else
                    for i=1:n
                        [ results{i} ] = this.doParse( dataFileList{i}.getPath() );
                        [ ~, filename, ext ] = fileparts( dataFileList{i}.getPath() );
                        results{i}.setLabel( filename );
                        results{i}.setRepository( [baseFilePath,'/',filename] );
                        resultNames{i} = [filename, ext];   
                    end
                end
            else
                results = cell(1,1);
                resultNames = cell(1,1);
                [ ~, filename, ext ] = fileparts( filePath );
                [ results{1} ] = this.doParse( filePath );
                
                results{1}.setLabel( filename );
                
                results{1}.setRepository( iDataFile.getPath() );
                resultNames{1} = [filename, ext];
            end

            %clean uncompressed data
            if isUncompressed
                delete(uncompressedFilePath);
            end
        end

        function oUncompressedFile = doUncompressFile( this, iDataFile )
            filePath = iDataFile.getPath();
            [~, ~, fileext] = fileparts(filePath);  

            switch lower(fileext)
                case {'.tar.gz', '.tgz', '.gz', '.tar', '.zip'}
                    workDir = this.config.getParamValue('WorkingDirectory');
                    if isempty(workDir)
                        error('The working directory is empty. Please check.');
                    end
                    sprintf('Uncompressing file ...\n');
                    fileNames = biotracs.core.utils.uncompress( filePath, workDir );
                    oUncompressedFile = fileNames{1};
                otherwise
                    oUncompressedFile = '';
            end
        end    
    end
    
    methods(Abstract, Access = protected)
        [ result ] = doParse( this, iFilePath );                  % Run parsing here...
    end
    
end