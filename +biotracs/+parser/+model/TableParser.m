%"""
%biotracs.parser.model.TableParser
%TableParser process used to parse table files (`.csv, .xls, .xlsx, ...`). This process produce a DataTable.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.parser.model.TableParserConfig
%"""

classdef TableParser < biotracs.core.parser.model.BaseParser
    
    properties(Constant)
    end
    
    properties(Access = private)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        % Constructor
        function this = TableParser( )
            this@biotracs.core.parser.model.BaseParser();
            this.data = table();
        end
        
        %-- G --

    end
    
    methods(Access = protected)
        
        function [ dataTable ] = doParse( this, iFilePath )
            mode = this.config.getParamValue('Mode');
            if strcmpi(mode, 'extended')
                [ dataTable ] = doParseExtendedTable( this, iFilePath );
            else
                [ dataTable ] = doParseSimpleTable( this, iFilePath );
                rowNamesToIgnore = this.config.getParamValue('NamesOfRowsToIgnore');
                if ~isempty(rowNamesToIgnore)
                    rowNamesToIgnore = strcat('(',rowNamesToIgnore,')');
                    dataTable = dataTable.removeByRowName( strjoin(rowNamesToIgnore,'|') );
                end
            end
        end
        
        function [ dataTable ] = doParseSimpleTable( this, iFilePath )
            disp( ['Parsing file ', iFilePath, ' ...'] );
            [~,filename,ext] = fileparts(iFilePath);
            
            sheet = this.config.getParamValue('Sheet');
            if iscell(sheet)
                sheet = sheet{ this.fileCursor };
            end
            
            switch lower(ext)
                case {'.xlsx','.xls'}
                    t = readtable( ...
                        iFilePath,...
                        'ReadVariableNames', this.config.getParamValue('ReadColumnNames'), ...
                        'ReadRowNames', this.config.getParamValue('ReadRowNames'), ...
                        'Sheet', sheet ...
                        );
                    [ dataTable ] = this.doCreateSimpleOutputTable();
                    rowNames = t.Properties.RowNames;
                    colNames = t.Properties.VariableNames;
                    if strcmp(dataTable.dataType, 'numeric')
                        try
                            t = table2array(t);
                        catch 
                            error('Check that your data are numeric');
                        end
                    else
                        t = table2cell(t);
                    end
                    dataTable.setData( t, false )...
                            .setRowNames(rowNames)...
                            .setColumnNames(colNames);
                case {'.csv','.tsv','.txt'}
                    dataTable = this.doReadCsvTableQuick( iFilePath );
                otherwise
                    if strcmp(this.config.getParamValue('FileType'), 'text')
                        dataTable = this.doReadCsvTableQuick( iFilePath );
                    elseif strcmp(this.config.getParamValue('FileType'), 'spreadsheet')
                        t = readtable( ...
                            iFilePath,...
                            'ReadVariableNames' , this.config.getParamValue('ReadColumnNames'), ...
                            'ReadRowNames'      , this.config.getParamValue('ReadRowNames'), ...
                            'Delimiter'         , this.config.getParamValue('Delimiter'), ...
                            'FileEncoding'      , this.config.getParamValue('FileEncoding'), ...
                            'HeaderLines'       , this.config.getParamValue('NbHeaderLines'), ...
                            'FileType'          , this.config.getParamValue('FileType'), ...
                            'Sheet'             , sheet ...
                            );
                        [ dataTable ] = this.doCreateSimpleOutputTable();
                        rowNames = t.Properties.RowNames;
                        colNames = t.Properties.VariableNames;
                        if strcmp(dataTable.dataType, 'numeric')
                            t = table2array(t);
                        else
                            t = table2cell(t);
                        end
                        dataTable.setData( t, false )...
                            .setRowNames(rowNames)...
                            .setColumnNames(colNames);
                    else
                        error('Wrong ''FileType'' parameter');
                    end
            end
            dataTable.setLabel( filename );
            dataTable.setRowNamePatterns(this.config.getParamValue('RowNamePatterns'));
            dataTable.setColumnNamePatterns(this.config.getParamValue('ColumnNamePatterns'));
            dataTable.appendTagsFromFile( iFilePath, ...
                'Delimiter', this.config.getParamValue('Delimiter'), ... 
                'WorkingDirectory', this.config.getParamValue('WorkingDirectory') ... 
                );
        end
        
        function [ dataTable ] = doParseExtendedTable( this, iFilePath )
            disp( ['Parsing file ', iFilePath, ' ...'] );
            delimiter = this.config.getParamValue('Delimiter');            
            nbLinesToSkip = this.config.getParamValue('NbHeaderLines');          
            [~,filename,ext] = fileparts(iFilePath);           
            switch lower(ext)
                case {'.xlsx','.xls'}
                    error('Not yet supported for extended tables');
                case {'.csv','.txt','.tsv'}
                    fid = fopen(iFilePath, 'r');
                    
                    %skip lines if necessary
                    tline = fgetl(fid);
                    for i=1:nbLinesToSkip
                        tline = fgetl(fid);
                    end
                    
                    %read table names and variable names
                    tableNames = {};
                    tableVarNames = {};
                    i = 1; positionInFile = ftell(fid);
                    while ischar(tline)
                        if strcmp(tline(1),'#')
                            c = strsplit( tline(2:end),  delimiter, 'CollapseDelimiters', false );
                            if length(c) == 1
                                nchars = 25;
                                if length(tline) > nchars, dots = '...';
                                else, dots = ''; end
                                error('No variable names found for line %d: ''%s%s''\nSkip headers using parameter ''NbHeaderLines''', i, tline(1:nchars), dots);
                            else
                                tableNames{i} = c{1};
                                tableVarNames{i} = regexprep( c(2:end), '(^$)|("$)', '' );
                                i = i + 1;
                            end
                            
                        else
                            break;
                        end
                        positionInFile = ftell(fid);
                        tline = fgetl(fid);
                    end
                    %go to the the current position just after the headers
                    fseek(fid, positionInFile, 'bof');
                    
                    %scan document
                    maxNbCols = max( cellfun( @length, tableVarNames ) );
                    pattern = repmat('%s', 1, maxNbCols+1);
                    C = textscan( fid, pattern, 'MultipleDelimsAsOne', false, 'CollectOutput', true, 'Delimiter', delimiter );
                    mapNames = C{1}(:,1);
                    [~, locIdx] = ismember(mapNames, tableNames);
                    [tableIdx, ~] = ismember(tableNames, mapNames);
                    
                    %create the ExtDataTable
                    [ dataTable ] = this.doCreateExtendedOutputTable();

                    %tableData = cell( size(tableNames) );
                    nbTables = length(tableNames);
                    for i=1:nbTables
                        ncols = length(tableVarNames{i});
                        if ~tableIdx(i)
                            t = biotracs.data.model.DataTable( cell(0, ncols), tableVarNames{i} );
                        else
                            rowIdx = (locIdx == i);
                            t = biotracs.data.model.DataTable( C{1}(rowIdx, 2:ncols+1), tableVarNames{i} ); 
                        end
                        
                        t.setLabel(tableNames{i});
                        dataTable.add( t, tableNames{i} );
                    end
                    fclose(fid);
                otherwise
                    error('Invalid file format');
            end
            dataTable.setLabel( filename );
        end
        
        function [ dataTable ] = doReadCsvTableQuick( this, iFilePath )
            delimiter = this.config.getParamValue('Delimiter');
            nbLinesToSkip = this.config.getParamValue('NbHeaderLines');
            readRowNames = this.config.getParamValue('ReadRowNames');
            readColumnNames = this.config.getParamValue('ReadColumnNames');

            fid = fopen(iFilePath);
            if fid == -1
                error('Cannot open file %s', iFilePath);
            end

            %skip lines if necessary
            for i=1:nbLinesToSkip
                tline = fgetl(fid);
            end
            
            %read number of columns
            dataPosition = ftell(fid);
            tline = fgetl(fid);
            c = strsplit( tline,  delimiter, 'CollapseDelimiters', false );
            ncols = length(c);
            
            fseek(fid, dataPosition, 'bof');
            pattern = repmat('%s', 1, ncols);
            %pattern = strjoin(pattern, delimiter);
            C = textscan( fid, pattern, 'MultipleDelimsAsOne', false, 'CollectOutput', true, 'TreatAsEmpty', {''}, 'Delimiter', delimiter );
            nrows = size(C{1},1);
            
            % BugFix
            % If the document starts with '' or a white char followed by a
            % delimiter, the first value is ommitted by textscan
            C{1}(1,:) = c;      
            if readColumnNames
                if readRowNames
                    columnNames = C{1}(1,2:end);
                    rowNames = C{1}(2:end,1);
                    tableData = C{1}(2:end,2:end);
                else
                    nrows = size(C{1},1)-1;
                    columnNames = C{1}(1,:);
                    rowNames = repmat({''},1,nrows);
                    tableData = C{1}(2:end,:);
                end
            else
                if readRowNames
                    columnNames = repmat({''},1,ncols);
                    rowNames = C{1}(2:end,1);
                    tableData = C{1}(1:end,2:end);
                else
                    columnNames = repmat({''},1,ncols);
                    rowNames = repmat({''},1,nrows);
                    tableData = C{1};
                end
            end
            columnNames = regexprep( columnNames, '(^")|("$)', '' );
            rowNames = regexprep( rowNames, '(^")|("$)', '' );
            [ dataTable ] = this.doCreateSimpleOutputTable();
            
            if strcmp(dataTable.dataType, 'numeric')
                tableData = str2double(tableData);
            end
            dataTable.setData(tableData,false)...
                        .setRowNames(rowNames)...
                        .setColumnNames(columnNames);
                    
            fclose(fid);       
        end

        function [ dataTable ] = doCreateSimpleOutputTable( this )
            tableOutputClass = this.config.getParamValue('TableClass');
            if ~isempty(tableOutputClass)
                dataTable = feval(tableOutputClass);
            else
                dataTable = biotracs.data.model.DataTable();
            end
        end
        
        function [ dataTable ] = doCreateExtendedOutputTable( this )
            tableOutputClass = this.config.getParamValue('TableClass');
            if ~isempty(tableOutputClass)
                dataTable = feval(tableOutputClass);
            else
                dataTable = biotracs.data.model.ExtDataTable();
            end
        end
        
    end
    
end


