%"""
%biotracs.core.adapter.model.FileImporter
%A FileImporter is an Adapter that import Resource objects from files as DataFile or DataFileSet objects. 
%The FileImporter does not parse (load) the resource. It only create a DataFile (or DataFileSet) to pointer of the file.
%To parse the file, please user Parser that can process DataFile or DataFileSets. The only role of a FileImporter is to import raw files into the BioTracs environment for processing.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.adapter.model.FileExporter
%"""

classdef FileImporter < biotracs.core.adapter.model.Adapter
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function this = FileImporter()
            this@biotracs.core.adapter.model.Adapter();
            this.config.createParam('FileDirectoryFilter', '.*', 'Constraint', biotracs.core.constraint.IsText());
            this.config.createParam('FileExtensionFilter', '.*', 'Constraint', biotracs.core.constraint.IsText());
            this.config.createParam('FileNameFilter', '.*', 'Constraint', biotracs.core.constraint.IsText());
            this.config.createParam('Recursive', false, 'Constraint', biotracs.core.constraint.IsBoolean());
            this.config.createParam('InputFilePaths', {}, 'Constraint', biotracs.core.constraint.IsPath('IsScalar', false));
            % use terminal output
            this.input = biotracs.core.io.Terminal();
            this.setOutputSpecs({...
                struct(...
                'name', 'DataFileSet',...
                'class', {{'biotracs.data.model.DataFileSet', 'biotracs.data.model.DataFile'}} ...
                )...
                });
        end
        
        function [ tf ] = hasInputFilePath ( this )
            listOfInputFilePaths = this.config.getParamValue( 'InputFilePaths' );
            tf = ~isempty(listOfInputFilePaths);
        end
        
        
        function [ this ] = addInputFilePath( this, iPath )
            listOfInputFilePaths = this.config.getParamValue( 'InputFilePaths' );
            listOfInputFilePaths = [listOfInputFilePaths, {iPath}];
            this.config.updateParamValue('InputFilePaths', listOfInputFilePaths);
        end
        
    end
    
    
    methods(Access = protected)
        
        function doBeforeRun( this )
            try
                this.doBeforeRun@biotracs.core.adapter.model.Adapter();
            catch exception
                isOk = strcmp(exception.identifier,'BIOTRACS:Process:doBeforeRun:InputIsEmpty');
                if ~isOk
                    rethrow(exception);
                end
            end
        end
        
        function doRun( this )
            listOfInputFilePaths = this.config.getParamValue('InputFilePaths');
            n = length(listOfInputFilePaths);            
            listOfDataFileSets = cell(1,n);

            logStr = {};
            %w = biotracs.core.waitbar.Waitbar('Name', 'Getting file paths');
            %w.show();
            for i=1:n
                path = listOfInputFilePaths{i};
                [listOfDataFileSets{i}, tmpLogStr] = biotracs.core.file.helper.PathReader.read(...
                    path, ...
                    'FileDirectoryFilter', this.config.getParamValue('FileDirectoryFilter'), ...
                    'FileExtensionFilter', this.config.getParamValue('FileExtensionFilter'), ...
                    'FileNameFilter', this.config.getParamValue('FileNameFilter'), ...
                    'Recursive', this.config.getParamValue('Recursive') ...
                    );
                logStr = [logStr, tmpLogStr]; %#ok<AGROW>
                %w.show(i/n);
            end

            if ~isempty(listOfDataFileSets)
                mergedDataFileSets = concat(listOfDataFileSets{:});
                this.setOutputPortData('DataFileSet', mergedDataFileSets);
            end
            this.logger.writeLog( '%s', sprintf('%s\n',logStr{:}));
        end
        
    end
end
