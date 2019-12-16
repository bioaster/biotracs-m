%"""
%biotracs.core.docu.model.DocuSet
%Set of Docu objects
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.docu.view.DocuSet, biotracs.core.docu.model.Docu, biotracs.core.docu.model.DocuGenerator
%"""

classdef DocuSet < biotracs.core.mvc.model.ResourceSet
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DocuSet( varargin )
			%#function biotracs.core.docu.model.Docu
			
            this@biotracs.core.mvc.model.ResourceSet( varargin{:} );
            this.classNameOfElements = {'biotracs.core.docu.model.Docu'};
            this.bindView( biotracs.core.docu.view.DocuSet() );
            
            this.meta.title = ['Documentation for ', biotracs.core.env.Env.appName()];
            this.meta.description = 'What you think is what you get!';
            this.meta.keywords = 'BIOTRACS, BIOCODE, BIOAPPS, Framework, MATLAB, Workflow manager, Traceability, Metabolomics';
            this.meta.licenseText = '';
            this.meta.licenceUrl = '';
        end
        
        %-- S -

        function setLicenseText( this, iText)
            this.meta.licenseText = iText;
        end
        
        function setLicenseUrl( this, iUrl)
            this.meta.licenceUrl = iUrl;
        end
    end
    
    
    methods(Static)
        
        function docuSet = fromDataFileSet( dataFileSet )
            if ~isa(dataFileSet, 'biotracs.data.model.DataFileSet')
                error('BIOTRACS:DocuSet:InvalidArgument', 'A bicode.data.model.DataFileSet is required');
            end
            n = getLength(dataFileSet);
            docuList = cell(1,n);
            docuNames = cell(1,n);
            listOfTestFilePaths = {};
            w = biotracs.core.waitbar.Waitbar('Name', 'Analyzing code files');
            w.show();
            for i=1:n
                dataFile = dataFileSet.getAt(i);                
                if ~strcmpi(dataFile.getExtension(), 'm')
                    continue;
                end
                namespace = biotracs.core.docu.model.Docu.parseNamespaceFromPath( dataFile.getPath() );
                classMeta = meta.class.fromName( namespace ); 

                if(isempty(classMeta))
                    pattern = ['.+\',filesep,'tests\',filesep,'(.+\',filesep,')?(.+Tests\.m)$'];
                    isTestingClass = regexp( dataFile.getPath(), pattern );
                    if isTestingClass
                        listOfTestFilePaths{end+1} = dataFile.getPath();
                    end
                    continue;
                end
                
                docu = biotracs.core.docu.model.Docu( dataFile.getPath(), classMeta );
                docuList{i} = docu;
                docuNames{i} = namespace;
                w.show(i/n);
            end
                        
            docuSet = biotracs.core.docu.model.DocuSet();
            if ~isempty(docuNames)
                idx = cellfun( @isempty, docuNames );
                docuList = docuList(~idx);
                docuNames = docuNames(~idx);
                if ~isempty(docuNames)
                    docuSet.setElements(docuList,docuNames);
                end
            end

            if docuSet.isEmpty()
                error('BIOTRACS:DocuSet:NoFileFound', 'No file found. Please check file paths');
            end
            
            % assign test files to docus
			biotracs.core.env.Env.writeLog('');
            w = biotracs.core.waitbar.Waitbar('Name', 'Assigning unit tests files');
            w.show();
			n = length(listOfTestFilePaths);
            for i=1:n
                % search *./tests/ folders
                % remove .*/tests/ in file path and 
                filePath = listOfTestFilePaths{i};
                parts = strsplit(filePath, filesep);
                parts{end} = regexprep( parts{end}, '(Tests\.m)$', '' );
                for j=length(parts):-1:1
                    if strcmp(parts{j}, 'tests') || strcmp(parts{j}, '..') || strcmp(parts{j}, '.')
                        parts(1:j) = [];
                        break;
                    end
                end
                correspondinClass = strjoin(parts, '.');
                                
                docu = docuSet.get(correspondinClass);
                docu.setUnitTestFilePath( listOfTestFilePaths{i} );
                w.show(i/n);
            end
        end

        
    end
    
end

