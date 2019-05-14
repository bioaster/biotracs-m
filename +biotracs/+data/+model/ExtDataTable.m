%"""
%biotracs.data.model.DataMatrix
%Extended DataTable object. An extended DataTable is a collection of DataTable that can be exported to a single `.csv` file (or imported from an appropriate single `.csv` file)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.data.model.DataTable
%"""

classdef ExtDataTable < biotracs.core.mvc.model.ResourceSet
    
    properties(SetAccess = protected)
    end
    
    properties(SetAccess = protected)
        
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        function this = ExtDataTable( varargin )
            this@biotracs.core.mvc.model.ResourceSet( varargin{:} );
            this.classNameOfElements = {'biotracs.data.model.DataTable'};
        end

        function this = export( this, iFilePath, varargin )
            p = inputParser();
            p.addParameter('WorkingDirectory','',@ischar);
            p.addParameter('Delimiter','\t',@ischar);
            p.addParameter('WriteRowNames', true, @islogical);
            p.addParameter('WriteColumnNames', true, @islogical);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            [dirpath,filename,ext] = fileparts(iFilePath);
            if ~isempty(dirpath) && ~isfolder(dirpath)
                mkdir(dirpath);
            end
            
            if isempty(ext)
                ext = '.csv';
            end
            
            switch lower(ext)
                case {'.mat'}
                    this = biotracs.data.model.DataObject.export( iFilePath, varargin{:} );
                case {'.xls','.xlsx','.csv','.txt','.tsv','.tar','.tgz','.gz','.zip'}
                    n = this.getLength();
                    folder = [ dirpath, '/', filename, '/' ];
                    for i=1:n
                        name = regexprep( this.getElementName(i), '^([^\s]*).*', '$1');
                        isExcel = any(strcmpi({'.xls','.xlsx'}, ext));
                        
                        if ~isExcel, fileExt = '.csv';
                        else, fileExt = ext; end
                        filePath = [ folder , name, fileExt ];
                        this.getAt(i).export( filePath, varargin{:} );
                    end
                    
                    %compress directory
                    hasToCompressFolder = any(strcmpi({'.tar','.tgz','.gz','.zip'}, ext));
                    if hasToCompressFolder
                        if strcmpi( ext, '.zip' )
                            zip(iFilePath, folder);
                        else
                            tar(iFilePath, folder);
                        end
                        rmdir( folder, 's' );
                    end
                otherwise
                    error('Invalid file format');
            end
        end
        
    end
    
    
    % -------------------------------------------------------
    % Static methods
    % -------------------------------------------------------
    
    methods( Static )
        
        function this = fromExtDataTable( iExtDataTable )
            if ~isa( iExtDataTable, 'biotracs.data.model.ExtDataTable' )
                error('A ''biotracs.data.model.ExtDataTable'' is required');
            end
            this = biotracs.data.model.ExtDataTable();
            this.doCopy( iExtDataTable );
        end
        
        function this = import( iFilePath, varargin )
            p = inputParser();
            p.addParameter('WorkingDirectory','',@ischar);
            p.addParameter('ReadRowNames',true,@islogical);
            p.addParameter('ReadColumnNames',true,@islogical);
            p.addParameter('Delimiter','\t',@ischar);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            [~,~,ext] = fileparts(iFilePath);
            
            switch lower(ext)
                case {'.mat'}
                    this = biotracs.data.model.DataObject.import( iFilePath, varargin{:} );
                otherwise
                    process = biotracs.parser.model.TableParser();
                    c = process.getConfig();
                    c.hydrateWith( [ varargin, {'Mode', 'extended'} ] );
                    process.setInputPortData( 'DataFile', biotracs.data.model.DataFile(iFilePath) );
                    process.run();
                    this = process.getOutputPortData('ResourceSet').getAt(1);
            end
        end
        
    end
    
    
end
