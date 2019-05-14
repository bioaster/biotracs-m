%"""
%biotracs.core.adapter.model.FileExporter
%A FileExporter is an Adapter that export Resource objects to files on the the disk
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.adapter.model.FileImporter
%"""

classdef FileExporter < biotracs.core.adapter.model.Adapter
    
    properties(SetAccess = protected)
        %listOfOutputFilePaths;
    end
    
    methods
        
        function this = FileExporter()
            this@biotracs.core.adapter.model.Adapter();
            this.config.createParam('FileExtension', '.mat', 'Constraint', biotracs.core.constraint.IsText());
            this.config.createParam('OutputFilePaths', {}, 'Constraint', biotracs.core.constraint.IsText('IsScalar', false)); 
            this.config.createParam('NameFilter', '.*', 'Constraint', biotracs.core.constraint.IsText('IsScalar', true), 'Description', 'Only valid for ResourceSet export. Only Resources, in the ResourceSet, with labels that validate the filter (regexp) will be exported. Set .* to export all.'); 
            
            % enhance outputs specs
            this.setInputSpecs({...
                struct(...
                'name', 'Resource',...
                'class', 'biotracs.core.mvc.model.Resource' ...
                )...
                });
            % use terminal output
            %             this.output = biotracs.core.io.Terminal();
            this.setOutputSpecs({...
                struct(...
                'name', 'DataFileSet',...
                'class', 'biotracs.data.model.DataFileSet' ...
                )...
                });
        end

        function paths = getListOfOutputFilePaths( this )
            paths = this.config.getParamValue('OutputFilePaths');
        end

        function setOutputFileExtension( this, iExt )
            this.config.updateParamValue('FileExtension', iExt);
        end
        
    end
    
    
    methods(Access = protected)
        
        function doBeforeRun( this )
            try
                this.doBeforeRun@biotracs.core.adapter.model.Adapter();
            catch exception
                isOk = strcmp(exception.identifier,'BIOTRACS:Process:doBeforeRun:OutputIsEmpty');
                if ~isOk
                    rethrow(exception);
                end
            end
        end
        
        function doRun( this )
            resource = this.getInputPortData('Resource');
            ext = ['.', regexprep(this.config.getParamValue('FileExtension'), '^(\.)+', '')];
            logStr = {};
            oPath = fullfile([this.config.getParamValue('WorkingDirectory'), '/', resource.getLabel(), ext]);
            
            if isa(resource, 'biotracs.core.mvc.model.ResourceSet')
                resource.export( oPath, 'NameFilter', this.config.getParamValue('NameFilter') );
            else
                resource.export( oPath );
            end
            logStr = [logStr, {['Export ', oPath]}];
            listOfOutputFilePaths = {oPath};
            this.config.updateParamValue('OutputFilePaths', listOfOutputFilePaths);
            this.logger.writeLog( '%s', sprintf('%s\n',logStr{:}) );
            
            dataFile = biotracs.data.model.DataFile(listOfOutputFilePaths{:});
            dataFileSet = biotracs.data.model.DataFileSet();
            dataFileSet.add(dataFile);
            
            this.setOutputPortData('DataFileSet', dataFileSet);
        end
        
    end
end
