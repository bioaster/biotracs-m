%"""
%biotracs.data.model.DataMatrix
%DataMatrix object. The inner data of a DataMatrix is a generic cell of objects. A DataTable has also `ColumnNames` and `RowNames`. Columns and rows can also be tagged with further custom data.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.data.model.DataTableInterface, biotracs.data.model.DataObject, biotracs.data.model.ExtDataTable, biotracs.data.model.DataMatrix, biotracs.data.model.DataSet
%"""

classdef DataTable < biotracs.data.model.DataTableInterface & biotracs.data.model.DataObject
    
    properties(SetAccess = protected)
        columnNames = {};   % {1-by-N} cell
        rowNames = {};      % {1-by-M} cell
        tags = {{},{}};     % { {1-by-P} cell, {1-by-Q} cell } cell, P <= N, Q <= M
    end
    
    properties(GetAccess = private, SetAccess = protected)
        rowGroupStrategy;
        columnGroupStrategy;
        subTableClassName;
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        %> @param[in] iData n-by-m numeric array
        %> @param[in] iColumnNames [optional] 1-by-m cell of string
        %> @param[in] iRowNames [optional] 1-by-n cell of string
        %> @param[in] iTags [optional] 1-by-2 cell containing row and column
        % tags. iTags{1} = 1-by-n cell containing row tags given by
        % {key,val} structs, iTags{2} 1-by-m cell containing column tags given by {key,val} structs.
        %> @throw Error if constructor fails
        function this = DataTable( iData, iColumnNames, iRowNames, iTags )
            this@biotracs.data.model.DataTableInterface();
            this@biotracs.data.model.DataObject();
            this.dataType = 'cell';
            
            if nargin > 0
                this.setData( iData );
            end
            if nargin > 1
                this.setColumnNames( iColumnNames );
            end
            if nargin > 2
                this.setRowNames( iRowNames );
            end
            if nargin > 3 && ~isempty(iTags)
                this.tags = iTags;
            end
                
            % Class of the subtable when selection is applied
            this.subTableClassName = this.className;

            % Row and column name's patterns
            % If a row name may be 'Sample:KO_Time:1H_BR:1_AR:1_Seq:123'
            % Then rowNamePatterns  should be {'Sample', 'Time',  'BR', 'Seq'}
            this.meta.rowNamePatterns =  struct();
            this.meta.columnNamePatterns = struct();
            this.meta.nameSeparator = '_';
            
            this.bindView( biotracs.data.view.DataTable );
        end
        
        %-- A --
        
        function appendTagsFromFile( this, iFilePath, varargin )
            this.doAppendTags( iFilePath, varargin{:} )
        end
        
        %-- C --
        
        function strat = createRowGroupStrategy( this, iPatterns )
            if nargin == 1 || isempty(iPatterns)
                strat = biotracs.data.helper.GroupStrategy( this.rowNames, this.meta.rowNamePatterns );
            else
                strat = biotracs.data.helper.GroupStrategy( this.rowNames, iPatterns );
            end
        end
        
        function strat = createColumnGroupStrategy( this, iPatterns )
            if nargin == 1 || isempty(iPatterns)
                strat = biotracs.data.helper.GroupStrategy( this.columnNames, this.meta.columnNamePatterns );
            else
                strat = biotracs.data.helper.GroupStrategy( this.columnNames, iPatterns );
            end
        end
        
        %-- D --
        
        function dataTable = datafun( this, fun )
            dataTable = this.copy();
            dataTable.data = cellfun(fun, this.data ,'UniformOutput', false);
        end
        
        %-- E --
        
        function export( this, iFilePath, varargin )
            p = inputParser();
            p.addParameter('WorkingDirectory','',@ischar);
            p.addParameter('Delimiter','\t',@ischar);
            p.addParameter('WriteRowNames', true, @islogical);
            p.addParameter('WriteColumnNames', true, @islogical);
            p.addParameter('XlsSheet', 1, @(x)(isnumeric(x) || ischar(x)));
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            if isfile(iFilePath)
                delete(iFilePath);
            end
            
            [dirpath,filename,ext] = fileparts(iFilePath);
            if ~isempty(dirpath) && ~isfolder(dirpath)
                mkdir(dirpath);
            end

            areRowNamesEmpty = cellfun('isempty', this.rowNames );
            areColumnNamesEmpty = cellfun('isempty', this.columnNames );
            writeRowNames =  p.Results.WriteRowNames && all(~areRowNamesEmpty);
            writeColumnNames = p.Results.WriteColumnNames && all(~areColumnNamesEmpty);
            
            switch lower(ext)
                case {'.xlsx','.xls'}
                    if  ~iscellstr(this.data)
                        try
                            falttenedData = biotracs.core.utils.flattencell( this.data );
                        catch err
                            error('BIOTRACS:DataMatrix:Export:NestedCells', '1-level cells of string/numeric or up to 2-level nested cells of cellstr can be exported\n%s', err.message);
                        end
                    else
                        falttenedData = this.data;
                    end

                    if writeRowNames && writeColumnNames
                        [status, message] = xlswrite( iFilePath, [ {''}, this.columnNames ; this.rowNames(:), falttenedData ], p.Results.XlsSheet );
                    elseif writeRowNames
                        [status, message] = xlswrite( iFilePath, [ this.rowNames(:), falttenedData ], p.Results.XlsSheet );
                    elseif writeColumnNames
                        [status, message] = xlswrite( iFilePath, [ this.columnNames; falttenedData ], p.Results.XlsSheet );
                    else
                        [status, message] = xlswrite( iFilePath, falttenedData, p.Results.XlsSheet );
                    end
                    
                    if ~status
                        biotracs.core.env.Env.writeLog( '%s', message.message );
                    end
                    
                    if ~status
                        biotracs.core.env.Env.writeLog( '%s', 'Cannot export to Excel format (.xlsx,.xls), try to export to text format (.csv)' );
                        this.export( [dirpath,'/',filename,'.csv'] );
                    end
                case {'.csv','.txt','.tsv'}
                    fid = -1;
                    try
                        if ~iscellstr(this.data)
                            try
                                c = biotracs.core.utils.flattencell( this.data, 'QuoteString', true );
                            catch err
                                error('BIOTRACS:DataMatrix:Export:NestedCells', '1-level cells of string/numeric or up to 2-level nested cells of cellstr can be exported\n%s\n', err.message);
                            end
                        else
                            c = this.data;
                        end
                        
                        if writeRowNames && writeColumnNames
                            c =  [ {''}, this.columnNames ; this.rowNames(:), c ];
                        elseif writeRowNames
                            c = [ this.rowNames(:), c ];
                        elseif writeColumnNames
                            c = [ this.columnNames; c ];
                        else
                            %do not change
                        end
                        
                        delim = p.Results.Delimiter;
                        [m,n] = size(c);
                        fid = fopen(iFilePath,'w');
                        if fid == -1
                            error('BIOTRACS:DataMatrix:Export:InvalidFid', 'The file directory does not exist');
                        end
                        
                        if writeRowNames
                            if writeColumnNames
                                format = repmat({'%s'},1,n-1);
                                format = ['%s', delim, strjoin(format, delim), '\n'];
                                fprintf(fid,format,c{1,:});
                                k = 2;
                            else
                                k = 1;
                            end
                            format = repmat({'%s'},1,n-1);
                            format = ['%s', delim, strjoin(format, delim), '\n'];
                            for i = k:m
                                fprintf( fid, format, c{i,:} );
                            end
                        else
                            if writeColumnNames
                                format = repmat({'%s'},1,n);
                                format = [strjoin(format, delim), '\n'];
                                fprintf(fid,format,c{1,:});
                                k = 2;
                            else
                                k = 1;
                            end
                            format = repmat({'%s'},1,n);
                            format = [strjoin(format, delim), '\n'];
                            for i = k:m
                                fprintf( fid, format, c{i,:} );
                            end
                        end
                        fclose(fid);
                    catch err
                        if fid ~= -1, fclose(fid); end
                        biotracs.core.env.Env.writeLog( 'Cannot export to text format, try to export to binary .mat\n%s', err.message );
                        this.export( [dirpath,'/',filename,'.mat'] );
                    end
                otherwise
                    this.export@biotracs.data.model.DataObject( iFilePath, varargin{:} );
            end
            
            try
                this.exportTags( iFilePath, varargin{:} );
            catch exception
                warning(exception.identifier, 'Cannot export tags\n%s', exception.message);
            end
        end
        
        function exportTags( this, iFilePath, varargin )
            p = inputParser();
            p.addParameter('WorkingDirectory','',@ischar);
            p.addParameter('Delimiter','\t',@ischar);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            [dirpath,name,ext] = fileparts(iFilePath);
            if ~isempty(dirpath) && ~isfolder(dirpath)
                mkdir(dirpath);
            end
            if isempty(dirpath)
                dirpath = '.';
            end
			
            rowTagFilePath = [dirpath,'/',name,'.rtags.json'];
            columnTagFilePath = [dirpath,'/',name,'.ctags.json'];
            if isfile(rowTagFilePath)
                delete(rowTagFilePath);
            end
            if isfile(columnTagFilePath)
                delete(columnTagFilePath);
            end
            
            rt = this.doConvertTagsToTable('row');
            ct = this.doConvertTagsToTable('column');
            
            if ~isempty(rt)
                fid1 = fopen(rowTagFilePath, 'w');
                if fid1 == -1
                    error('BIOTRACS:DataTable:CannotCreateFile', 'Cannot create file %s. Please check disk access rights.', rowTagFilePath);
                end
            end
            
            if ~isempty(ct)
                fid2 = fopen(columnTagFilePath, 'w');
                if fid2 == -1
                    error('BIOTRACS:DataTable:CannotCreateFile', 'Cannot create file %s. Please check disk access rights.', columnTagFilePath);
                end
            end

            switch lower(ext)
                case {'.xlsx','.xls','.csv','.txt','.tsv'}
                    if ~isempty(rt)
                        str = jsonencode(rt);
                        fprintf(fid1, '%s', str);
                    end
                    if ~isempty(ct)
                        str = jsonencode(ct);
                        fprintf(fid2, '%s', str);
                    end
                otherwise
                    disp('Tags are only exported for .xlsx, .xls, .csv, .txt, .csv files');
            end
            
            if ~isempty(rt)
                fclose(fid1);
            end
            
            if ~isempty(ct)
                fclose(fid2);
            end
        end
        
        %-- F --
        
        %-- G --

        function data = getData( this )
            data = this.data;
        end
        
        function val = getDataAt(this, i, j)
            if nargin == 2
                val = this.data{i};
            else
                val = this.data{i,j};
            end
        end
        
        function val = getDataFor(this, iRowName, iColumnName)
            i = this.getRowIndexesByName(iRowName);
            j = this.getColumnIndexesByName(iColumnName);
            val = getDataAt(this, sort(i), sort(j));
        end
        
        function [data, rowIndexes, colIndexes] = getDataByRowAndColumnName(this, iRowName, iColumnName, iIsCaseSensitive)
            if nargin < 4, iIsCaseSensitive = true; end
            rowIndexes = this.getRowIndexesByName( iRowName, iIsCaseSensitive );
            colIndexes = this.getColumnIndexesByName( iColumnName, iIsCaseSensitive );
            data = this.data( rowIndexes, colIndexes );
        end
        
        function [data, indexes] = getDataByColumnName( this, iSearchedLabelPattern, iIsCaseSensitive )
            if strcmp(iSearchedLabelPattern,'.*')
                data = this.data;
                indexes = 1:this.getNbColumns();
                return;
            end
            if nargin < 3, iIsCaseSensitive = true; end
            indexes = this.getColumnIndexesByName( iSearchedLabelPattern, iIsCaseSensitive );
            data = this.data( :, indexes );
        end
        
        function [data, indexes] = getDataByRowName( this, iSearchedLabelPattern, iIsCaseSensitive )
            if strcmp(iSearchedLabelPattern,'.*')
                data = this.data;
                indexes = 1:this.getNbRows();
                return;
            end
            if nargin < 3, iIsCaseSensitive = true; end
            indexes = this.getRowIndexesByName( iSearchedLabelPattern, iIsCaseSensitive );
            data = this.data( indexes, : );
        end
        
        function [data, indexes] = getDataByColumnTag( this, iTags )
            indexes = this.getColumnIndexesByTag( iTags );
            data = this.data( :, indexes );
        end
        
        function nrows = getNbRows( this )
            nrows = size( this.data, 1 );
        end
        
        function ncols = getNbColumns( this )
            ncols = size( this.data, 2 );
        end
        
        function length = getLength( this )
            length = this.getNbRows() * this.getNbColumns();
        end
        
        % Vertorized getter
        function oNames = getRowNames( this, iIndexes )
            if nargin == 1
                oNames = this.rowNames;
            else
                oNames = this.rowNames(iIndexes);
            end
        end
        
        % Vertorized getter
        function oNames = getColumnNames( this, iIndexes )
            %oNames = this.data.Properties.VariableNames;
            if nargin == 1
                oNames = this.columnNames;
            else
                oNames = this.columnNames(iIndexes);
            end
        end
        
        
        function oName = getRowName( this, iIndex )
            oName = this.rowNames{iIndex};
        end
        
        function oName = getColumnName( this, iIndex )
            oName = this.columnNames{iIndex};
        end
        
        % Get the tags of all (or a given) row(s)
        %> @param[in] iRowIndex [optional, integer] The index of the row
        %> @Return A struct representing the tag
        function [ tag ] = getRowTag(this, iRowIndex)
            if isempty(iRowIndex), tag = struct([]); return; end
            [ tag ] = this.tags{1}{iRowIndex};
        end
        
        % Get the tags of all (or given) column(s)
        %> @param[in] iColumnIndex [optional, integer] The indexes of the
        % columns
        %> @Return A struct representing the tag
        function [ tag ] = getColumnTag(this, iColumnIndex)
            if isempty(iColumnIndex), tag = struct([]); return; end
            [ tag ] = this.tags{2}{iColumnIndex};
        end
        
        % Get the tags of all (or given) row(s)
        %> @param[in] iRowIndex [optional, array] The indexes of the rows
        %> @return A cell of struct corresponding to row tags
        function [ tags ] = getRowTags(this, iRowIndex)
            if nargin == 1
                tags = this.tags{1};
            else
                if isempty(iRowIndex), tags = {}; return; end
                tags = this.tags{1}(iRowIndex);
            end
        end
        
        % Get the tags of all (or a given) column(s)
        %> @param[in] iColumnIndex [optional, array] The indexes of the
        % columns
        %> @return A cell of struct corresponding to column tags
        function [ tags ] = getColumnTags(this, iColumnIndex)
            if nargin == 1
                tags = this.tags{2};
            else
                if isempty(iColumnIndex), tags = {}; return; end
                tags = this.tags{2}(iColumnIndex);
            end
        end
        
        % ...
        %> @ToDo : Optimizzation => use 'first' to only get the first index
        % ...
        function [ columnIndexes, booleanColumnIndexes ] = getColumnIndexesByName( this, iSearchedLabelPattern, iIsCaseSensitive, iFirst )
            if iscellstr(iSearchedLabelPattern)
                iSearchedLabelPattern = strcat('(',iSearchedLabelPattern,')');
                iSearchedLabelPattern = strjoin(iSearchedLabelPattern,'|');
            end    
            if ~ischar(iSearchedLabelPattern)
                error('BIOTRACS:DataTable:InvalidArgument','A string is required');
            end
            if nargin < 3, iIsCaseSensitive = true; end
            if nargin < 4, iFirst = false; end
            columnIndexes = biotracs.core.utils.cellstrmatch( this.getColumnNames(), iSearchedLabelPattern, iIsCaseSensitive, iFirst );
            
            if nargout == 2
                nbcols = this.getNbColumns();
               booleanColumnIndexes =  false(1,nbcols);
               booleanColumnIndexes( columnIndexes ) = true;
            end
        end
        
        function [ rowIndexes, booleanRowIndexes ] = getRowIndexesByName( this, iSearchedLabelPattern, iIsCaseSensitive, iFirst )
            if iscellstr(iSearchedLabelPattern)
                iSearchedLabelPattern = strcat('(',iSearchedLabelPattern,')');
                iSearchedLabelPattern = strjoin(iSearchedLabelPattern,'|');
            end
            if ~ischar(iSearchedLabelPattern)
                error('BIOTRACS:DataTable:InvalidArgument','A string is required');
            end
            if nargin < 3, iIsCaseSensitive = true; end
            if nargin < 4, iFirst = false; end
            rowIndexes = biotracs.core.utils.cellstrmatch( this.getRowNames(), iSearchedLabelPattern, iIsCaseSensitive, iFirst );
            
            if nargout == 2
               nbrows = this.getNbRows();
               booleanRowIndexes =  false(1,nbrows);
               booleanRowIndexes( rowIndexes ) = true;
            end
        end
        
        % Get indexes of columns where tags strictly match with a {key,
        % value} pair
        %> @param[in] iTagList List of tags given in a {key_1, value_1, ...
        % key_n, value_n} cell
        % Strict comparison is done (no regexp). If the searched value
        % starts with character '~', then columns that do not have the tag
        % or tags that do not match with the {kev, value(2:end)} pair are captured
        %> @return column indexes
        function [ columnIndexes, booleanColumnIndexes ] = getColumnIndexesByTag( this, iTagList )
            columnIndexes = [];
            if ~iscellstr(iTagList)
                error('Invalid argument; A cellstr is required');
            end
            tagStruct = struct(iTagList{:});
            
            for i=1:this.getNbColumns()
                
                isOk = true;
                keys = fields(tagStruct);
                
                for j=1:length(tagStruct)
                    key = keys{j};
                    value = tagStruct.(key);

                    isNoMatchTest = false;
                    if strcmp(value(1), '~')
                        isNoMatchTest = true;
                        value = value(2:end);
                    end

                    keyExists = ( i<=length(this.getColumnTags()) && isfield(this.getColumnTag(i), key) );
                    if keyExists
                        val = this.getColumnTag(i).(key);
                        isQueryValid = ~isNoMatchTest && strcmpi(val, value) || ...
                            isNoMatchTest && ~strcmpi(val, value);
                        if isQueryValid
                            %columnIndexes = [ columnIndexes, i ];
                        else
                            isOk = false;
                            break;
                        end
                    elseif isNoMatchTest
                        %columnIndexes = [ columnIndexes, i ];
                    else
                        isOk = false;
                        break;
                    end
                end
                
                if isOk
                    columnIndexes = [ columnIndexes, i ]; %#ok<AGROW>
                end
            end
            
            if nargout == 2
               nbcols = this.getNbColumns();
               booleanColumnIndexes = false(1,nbcols);
               booleanColumnIndexes( columnIndexes ) = true;
            end
        end
        
        
        % Get indexes of columns where tags strictly match with a {key,
        % value} pair
        %> @param[in] iTagList List of tags given in a {key_1, value_1, ...
        % key_n, value_n} cell
        % Strict comparison is done (no regexp). If the searched value
        % starts with character '~', then columns that do not have the tag
        % or tags that do not match with the {kev, value(2:end)} pair are captured
        %> @return column indexes
        function [ rowIndexes, booleanRowIndexes ] = getRowIndexesByTag( this, iTagList )
            rowIndexes = [];
            if ~iscellstr(iTagList)
                error('Invalid argument; A cellstr is required');
            end
            
            tagStruct = struct(iTagList{:});
            
            for i=1:this.getNbRows()
                
                isOk = true;
                keys = fields(tagStruct);
                
                for j=1:length(tagStruct)
                    key = keys{j};
                    value = tagStruct.(key);

                    isNoMatchTest = false;
                    if strcmp(value(1), '~')
                        isNoMatchTest = true;
                        value = value(2:end);
                    end

                    keyExists = ( i<=length(this.getRowTags()) && isfield(this.getRowTag(i), key) );
                    if keyExists
                        val = this.getRowTag(i).(key);
                        isQueryValid = ~isNoMatchTest && strcmpi(val, value) || ...
                            isNoMatchTest && ~strcmpi(val, value);
                        if isQueryValid
                            %rowIndexes = [ rowIndexes, i ];
                        else
                            isOk = false;
                            break;
                        end
                    elseif isNoMatchTest
                        %rowIndexes = [ rowIndexes, i ];
                    else
                        isOk = false;
                        break;
                    end
                end
                
                if isOk
                    rowIndexes = [ rowIndexes, i ]; %#ok<AGROW>
                end
            end
            
            if nargout == 2
               nbrows = this.getNbRows();
               booleanRowIndexes = false(1,nbrows);
               booleanRowIndexes( rowIndexes ) = true;
            end
        end
        
        function patterns = getColumnNamePatterns( this )
            patterns = this.meta.columnNamePatterns;
        end
        
        function patterns = getRowNamePatterns( this )
            patterns = this.meta.rowNamePatterns;
        end
        
        %-- I --
  
        %-- P --
        
        % See method doParseNames
        function parsingResults = parseColumnNames( this )
            parsingResults = biotracs.data.helper.GroupStrategy.parseNamesUsingNamePattern( this.columnNames, this.meta.columnNamePatterns, this.meta.nameSeparator );
        end
        
        % See method doParseNames
        function parsingResults = parseRowNames( this )
            parsingResults = biotracs.data.helper.GroupStrategy.parseNamesUsingNamePattern( this.rowNames, this.meta.rowNamePatterns, this.meta.nameSeparator );
        end
        
        
        %-- R --
        function oTable = repTable( this, m, n )
            t = repmat({this},1,n);
            t = horzcat(t{:});
            t = repmat({t},m,1);
            oTable = vertcat( t{:} );
        end
        
        function resetColumnNames( this )
            n = this.getNbColumns();
            this.columnNames = repmat({''},1,n);
        end
        
        function resetRowNames( this )
            m = this.getNbRows();
            this.rowNames = repmat({''},1,m);
        end
        
        function resetTags( this )
            m = this.getNbRows();
            n = this.getNbColumns();
            this.tags = { cell(1,m), cell(1,n) };
        end
        
        function [dataTable, colIndexes]  = removeByColumnName( this, iSearchedLabelPattern, iIsCaseSensitive, iFirst )
            if nargin < 3, iIsCaseSensitive = true; end
            if nargin < 4, iFirst = false; end
            n = getSize(this,2);
            colIndexes = this.getColumnIndexesByName( iSearchedLabelPattern, iIsCaseSensitive, iFirst );
            indexes = true(1, n);
            indexes(colIndexes) = false;
            dataTable = this.selectByColumnIndexes(indexes);
        end
        
        function [dataTable]  = removeByColumnIndexes( this, iColumnIndexes )
%             rowIndexes = this.getColumn( iColumnIndexes );
            n = getSize(this,2);
            indexes = true(1, n);
            indexes(iColumnIndexes) = false;
            dataTable = this.selectByColumnIndexes(indexes);
        end
        
          function [dataTable]  = removeByRowIndexes( this, iRowIndexes )
            n = getSize(this,1);
            indexes = true(1, n);
            indexes(iRowIndexes) = false;
            dataTable = this.selectByRowIndexes(indexes);
        end
          % Search column of which labels match with a given pattern and remove the corresponding DataTable
        %> @param[in] iSearchedLabelPattern Pattern to search (RegExp)
        %> @param[in] iIsCaseSensitive True if case-sensitive, False otherwise
        %> @return The DataTable corresponding without the rows found
        %> @return The indexes of the rows found in the original DataTable
        function [dataTable, rowIndexes]  = removeByRowName( this, iSearchedLabelPattern, iIsCaseSensitive, iFirst )
            if nargin < 3, iIsCaseSensitive = true; end
            if nargin < 4, iFirst = false; end
            n = getSize(this,1);
            rowIndexes = this.getRowIndexesByName( iSearchedLabelPattern, iIsCaseSensitive, iFirst );
            indexes = true(1, n);
            indexes(rowIndexes) = false;
            dataTable = this.selectByRowIndexes(indexes);
        end
        
             % Search tags of which labels match with a given pattern and extract the corresponding DataTable
        %> @param[in] iSearchedLabelPattern Pattern to search (RegExp)
        %> @param[in] iIsCaseSensitive True if case-sensitive, False otherwise
        %> @return The DataTable corresponding to the column tags found
        %> @return The indexes of the columns found in the original DataTable
        function [ dataTable, rowIndexes ] = removeByRowTag( this, iTags )
            rowIndexes = this.getRowIndexesByTag( iTags );
            n = getSize(this,1);
            indexes = true(1, n);
            indexes(rowIndexes) = false;
            dataTable = this.selectByRowIndexes(indexes);
        end
   
        function [ dataTable, colIndexes ] = removeByColumnTag( this, iTags )
            colIndexes = this.getColumnIndexesByTag( iTags );
            n = getSize(this,2);
            indexes = true(1, n);
            indexes(colIndexes) = false;
            dataTable = this.selectByColumnIndexes(indexes);
        end
        %-- S --
        
        function this = setData( this, iData, iResetNames )
            if nargin <= 2, iResetNames = true; end % by default, meta are reset
            wasDataEmpty = isempty(this.data);
            this.setData@biotracs.data.model.DataObject( iData );
            if wasDataEmpty || iResetNames
                this.resetRowNames();
                this.resetColumnNames();
                this.resetTags();
            end
        end
        
        function setDataAt(this, i, j, iValue)
            if isempty(i) || isempty(j)
                error('Row or column indexes is empty');
            elseif isnumeric(i) && isnumeric(j)
                [m,n] = size(this.data);
                if max(i) > m || max(j) > n
                    error('Index exceeds data dimensions');
                end
            end
            
            if isscalar(i) && isscalar(j)
                this.data{i,j} = iValue;
            else
                this.data(i,j) = iValue;
            end
        end
        
        function this = setDataFromArray( this, iArrayValues )
            if ~isnumeric( iArrayValues )
                error('Invalid argument, a numeric is required')
            end
            this.setData( num2cell( iArrayValues ) );
        end
        
        % Set row names using
        %> @param[in] iNames Pattern to search (RegExp)
        %> @return this
        function this = setRowNames( this, iNames )
            if isempty(iNames), return; end
            %this.doCheckColumnNames( iNames );
            if iscellstr(iNames)
                if length(iNames) ~= this.getNbRows()
                    error('Row name cell lengths are no consistent');
                end
                if iscolumn(iNames), iNames = iNames'; end
                this.rowNames = iNames;
            elseif ischar(iNames)
                %set with prefixe
                for i=1:this.getNbRows()
                    this.rowNames{i} = sprintf('%s%i', iNames, i);
                end
            else
                error('Invalid labels, a cell of string is required');
            end
        end
        
        %         % ToDo : Optimize this code
        %         % Check & use attributes directly
        %         function setColumnTags( this, iTags )
        %             if ~iscell(iTags)
        %                 error('A cell of string is regquired');
        %             end
        %             for i=1:length(iTags)
        %                 this.setColumnTag( i, iTags{i} );
        %             end
        %         end
        
        function this = setColumnNames( this, iNames )
            if isempty(iNames), return; end
            %this.doCheckColumnNames( iNames );
            if iscellstr(iNames)
                if length(iNames) ~= this.getNbColumns()
                    error('Column name cell lengths are no consistent');
                end
                if iscolumn(iNames), iNames = iNames'; end
                this.columnNames = iNames;
            elseif ischar(iNames)
                %set with prefixe
                for i=1:this.getNbColumns()
                    this.columnNames{i} = sprintf('%s%i', iNames, i);
                end
            else
                error('Invalid labels, a cell of string is required');
            end
        end
        
        function this = setRowName( this, iIndex, iName )
            if iIndex > this.getNbRows()
                error('Index out of range');
            end
            this.rowNames{iIndex} = iName;
        end
        
        function this = setColumnName( this, iIndex, iName )
            if iIndex > this.getNbColumns()
                error('Index out of range');
            end
            this.columnNames{iIndex} = iName;
        end
        
        function this = setRowTag( this, iRowIndex, iKey, iValue )
            try
                if iRowIndex > this.getNbRows()
                    error('Index out of range');
                end
                
                tag = this.tags{1}{iRowIndex};
                tag.(iKey) = iValue;        %add new tag
            catch
                tag = struct(iKey, iValue); %create new tag
            end
            this.tags{1}{iRowIndex} = tag;
        end
        
        %         % ToDo : Optimize this code
        %         % Check & use attributes directly
        %         function setRowTags( this, iTags )
        %             if ~iscell(iTags)
        %                 error('A cell of string is regquired');
        %             end
        %             for i=1:length(iTags)
        %                 this.setRowTag( i, iTags{i} );
        %             end
        %         end
        
        function this = setColumnTag( this, iColumnIndex, iKey, iValue )
            try
                if iColumnIndex > this.getNbColumns()
                    error('Index out of range');
                end
                tag = this.tags{2}{iColumnIndex};
                tag.(iKey) = iValue;            %add new tag
            catch
                tag = struct(iKey, iValue);     %create new tag
            end
            this.tags{2}{iColumnIndex} = tag;
        end
        
        function this = setColumnNamePatterns( this, iPatterns )
            if iscellstr(iPatterns)
                iPatterns = biotracs.data.helper.GroupStrategy.buildNamePatternsFromGroupList(iPatterns, this.meta.nameSeparator);
            end
            if ~isstruct(iPatterns)
                error('Invalid patterns, a struct or a cell is required');
            end
            this.meta.columnNamePatterns = iPatterns;
        end
        
        function this = setRowNamePatterns( this, iPatterns )
            if iscellstr(iPatterns)
                iPatterns = biotracs.data.helper.GroupStrategy.buildNamePatternsFromGroupList(iPatterns, this.meta.nameSeparator);
            end
            if ~isstruct(iPatterns)
                error('Invalid patterns, a struct ar a cell is required');
            end
            this.meta.rowNamePatterns = iPatterns;
        end
        
        
        function dataTable = selectByColumnIndexes( this, iColumnIndexes )
            dataTable = feval( ...
                this.subTableClassName, ...
                this.data(:, iColumnIndexes), ...
                this.getColumnNames(iColumnIndexes), ...
                this.getRowNames() ...
                );
            dataTable.tags{1}               = this.tags{1};
            dataTable.tags{2}               = this.tags{2}(iColumnIndexes);
            dataTable.meta                  = this.meta;
            dataTable.label                 = this.label;
        end
        
        % Search column of which labels match with a given pattern and extract the corresponding DataTable
        %> @param[in] iSearchedPattern Pattern to search (RegExp)
        %> @param[in] iIsCaseSensitive True if case-sensitive, False otherwise
        %> @return The DataTable corresponding to the columns found
        %> @return The indexes of the columns found in the original DataTable
        function [dataTable, colIndexes] = selectByColumnName( this, iSearchedLabelPattern, iIsCaseSensitive, iFirst )
            if strcmp(iSearchedLabelPattern,'.*')
                dataTable = this;
                colIndexes = 1:this.getNbColumns();
                return;
            end
            if nargin < 3, iIsCaseSensitive = true; end
            if nargin < 4, iFirst = false; end
            colIndexes = this.getColumnIndexesByName( iSearchedLabelPattern, iIsCaseSensitive, iFirst );
            dataTable = this.selectByColumnIndexes(colIndexes);
        end
        
        function dataTable = selectByRowIndexes( this, iRowIndexes )
            dataTable = feval( ...
                this.subTableClassName, ...
                this.data(iRowIndexes, :), ...
                this.getColumnNames(), ...
                this.getRowNames(iRowIndexes) ...
                );
            dataTable.tags{1}               = this.tags{1}(iRowIndexes);
            dataTable.tags{2}               = this.tags{2};
            dataTable.meta                  = this.meta;
            dataTable.label                 = this.label;
        end
        
        % Search column of which labels match with a given pattern and extract the corresponding DataTable
        %> @param[in] iSearchedLabelPattern Pattern to search (RegExp)
        %> @param[in] iIsCaseSensitive True if case-sensitive, False otherwise
        %> @return The DataTable corresponding to the rows found
        %> @return The indexes of the rows found in the original DataTable
        function [dataTable, rowIndexes]  = selectByRowName( this, iSearchedLabelPattern, iIsCaseSensitive, iFirst )
            if strcmp(iSearchedLabelPattern,'.*')
                dataTable = this;
                rowIndexes = 1:this.getNbRows();
                return;
            end
            if nargin < 3, iIsCaseSensitive = true; end
            if nargin < 4, iFirst = false; end
            rowIndexes = this.getRowIndexesByName( iSearchedLabelPattern, iIsCaseSensitive, iFirst );
            dataTable = this.selectByRowIndexes(rowIndexes);
        end
        
        % Search tags of which labels match with a given pattern and extract the corresponding DataTable
        %> @param[in] iSearchedLabelPattern Pattern to search (RegExp)
        %> @param[in] iIsCaseSensitive True if case-sensitive, False otherwise
        %> @return The DataTable corresponding to the column tags found
        %> @return The indexes of the columns found in the original DataTable
        function [ dataTable, colIndexes ] = selectByColumnTag( this, iTags )
            colIndexes = this.getColumnIndexesByTag( iTags );
            dataTable = this.selectByColumnIndexes(colIndexes);
        end
        
        function [ dataTable, rowIndexes ] = selectByRowTag( this, iTags )
            rowIndexes = this.getRowIndexesByTag( iTags );
            dataTable = this.selectByRowIndexes(rowIndexes);
        end

        function [s1,s2] = getSize( this, c )
            if nargin == 2
                s1 = size(this.data,c);
            else
                s = size(this.data);
                if nargout <= 1
                    s1 = s;
                else
                    s1 = s(1); s2 = s(2);
                end
            end
        end
        
        function summary( this )
            disp( this )
            try
                t = this.toTable();
                disp( t );
            catch err
                biotracs.core.env.Env.writeLog('Cannot print summary\n%s', err.message);
            end
        end
        
        %-- T --
        
        function tDataTable = transpose( this )
            tDataTable = feval(...
                this.className, ...
                transpose(this.data) , ...
                this.rowNames, ...
                this.columnNames ...
                );
            tDataTable.label   = this.label;
            tDataTable.meta    = this.meta;
            tDataTable.tags{1} = this.tags{2};
            tDataTable.tags{2} = this.tags{1};
            tDataTable.meta.rowNamePatterns = this.meta.columnNamePatterns;
            tDataTable.meta.columnNamePatterns = this.meta.rowNamePatterns;
        end
        
        function oMatrix = toMatrix( this )
            if hasEmptyData(this)
                oMatrix = [];
                return;
            end
            
            try
                oMatrix = cell2mat(this.data);
            catch err
                error( 'Cannot convert to ''biotracs.data.model.DataMatrix''. Data must be a numeric array.\n %s', err.message );
            end
        end
        
        function oTable = toTable( this )
            if hasEmptyData(this)
                oTable = table();
                return;
            end
            
            oTable = cell2table(this.data);
            try
                oTable.Properties.RowNames = this.getRowNames();
            catch err
                biotracs.core.env.Env.writeLog('%s\n%s', 'Cannot set row names; Row names are may be truncated.', err.message);
            end
            
            try
                oTable.Properties.VariableNames = this.getColumnNames();
            catch err
                biotracs.core.env.Env.writeLog('%s\n%s', 'Cannot set column names; Column names are may be truncated.', err.message);
            end
        end
        
        function oCell = toCell( this )
            oCell = this.data;
        end
        
        function dataMatrix = toDataMatrix( this )
            dataMatrix = biotracs.data.model.DataMatrix.fromDataTable(this);
        end
        
        function dataSet = toDataSet( this )
            dataSet = biotracs.data.model.DataSet.fromDataTable(this);
        end
        
    end
    
    % -------------------------------------------------------
    % Implementation of abstract interfaces inherited
    % from biotracs.core.ability.Queriable
    % -------------------------------------------------------
    
    methods(Access = public)
        
        function dataTable = count( this, varargin )
            
        end
        
        function insert( this, varargin )
        end
        
        function remove( this, varargin )
        end
        
        function [dataTable, rowIndexes] = selectWhere( this, iQuery, varargin )
            columns = iQuery.getColumns();
            predicate = iQuery.getPredicate();
            
            if predicate.isAny()
                dataTable = this;
                rowIndexes = 1:this.getNbRows();
                return;
            end
            
            %optimization
            p = inputParser();
            p.addParameter('First', false, @islogical);         %retrieve the first results
            p.addParameter('Successive', false, @islogical);    %retrieve all the results
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            m = this.getNbRows();
            targetedColumnIndexes = this.getColumnIndexesByName( columns, true );
            targetedRowIndexes = 1:m;
            rowIndexes = zeros(m, 1);
            
            first = p.Results.First;
            successive = p.Results.Successive;
            
            
            %ToDo : vecotrize here...
            if first
                Ok = false;
                for i = targetedRowIndexes
                    for j = targetedColumnIndexes
                        if validate( predicate, this.getDataAt(i,j) )
                            Ok = true;
                            break;
                        end
                    end
                    if Ok
                        rowIndexes(i) = i;
                        break;
                    end
                end
            elseif successive
                Ok = false; prevOk = false;
                for i = targetedRowIndexes
                    for j = targetedColumnIndexes
                        if validate( predicate, this.getDataAt(i,j) )
                            Ok = true;
                            break;
                        end
                    end
                    if Ok
                        rowIndexes(i) = i;
                        prevOk = Ok;
                    elseif prevOk
                        break;
                    end
                end
            else
                for i = targetedRowIndexes
                    for j = targetedColumnIndexes
                        if validate( predicate, this.getDataAt(i,j) )
                            rowIndexes(i) = i;
                            break;
                        end
                    end
                end
            end
            
            rowIndexes( rowIndexes == 0 ) = [];
            dataTable = this.selectByRowIndexes( rowIndexes );
        end
        
        function dataTable = replace( this, iTargetValue, iReplacementValue )
            dataTable = this.copy();
            if ~isscalar(iTargetValue)
                error('The target value must be a scalar');
                %dataTable.data( isnan(this.data) ) = iReplacementValue;
            elseif isnan(iTargetValue)
                dataTable.data( isnan(this.data) ) = iReplacementValue;
            else
                dataTable.data( this.data == iTargetValue ) = iReplacementValue;
            end
        end
        
        % Select records from DataTable after quering on columns and filter
        % by columns if required
        %> @param[in] Variables argument list
        % + 'WhereColumns' regular expression representing the names of the columns where the query is applied
        %   <column_value>
        % + 'EqualTo' | 'MatchAgainst' | 'GreaterThan' | 'GreaterOrEqualTo' | 'LessThan' | 'less_or _equal_to'  type of predicate to apply
        %   <predicate_value> (string for 'MatchAgainst' predicate, numeric
        %   'GreaterThan' and 'LessThan' predicated, any data for
        %   'EqualTo' predicate. Only one predicate can be applied a time in
        %   a query. If all the predictes are given only the most
        %   prioritary is use in the order of priority as given above.
        % + filter_by_col_name : [string] regular expression representing the names of columns to retrieve in the final results
        %   <filter_by_col_name_value>
        % + filter_by_row_name :  not yet activated (not yet available)
        %   <filter_by_col_name_value>
        function [dataTable, rowIndexes] = select( this, varargin )
            if nargin == 1
                dataTable = this;
                rowIndexes = 1:this.getNbRows();
                return;
            end
            
            p = inputParser();
            p.addParameter('WhereColumns', '.*', @ischar);
            
            %predicates
            p.addParameter('EqualTo', biotracs.core.db.Predicate.ANY);
            p.addParameter('MatchAgainst', biotracs.core.db.Predicate.ANY);
            p.addParameter('NotMatchAgainst', biotracs.core.db.Predicate.ANY);
            p.addParameter('GreaterThan', -Inf);
            p.addParameter('LessThan', Inf);
            p.addParameter('GreaterOrEqualTo', -Inf);
            p.addParameter('LessOrEqualTo', Inf);
            p.addParameter('Between', [-Inf, Inf]);
            
            %filters
            p.addParameter('FilterByColumnName', '.*', @ischar);
            p.addParameter('FilterByColumnTag', {}, @iscellstr);  %{key, value}
            p.addParameter('FilterByRowName', '.*', @ischar);
            p.parse(varargin{:});
            
            if ~strcmp(p.Results.EqualTo, biotracs.core.db.Predicate.ANY)
                q = biotracs.core.db.Query.equalTo( ...
                    p.Results.WhereColumns, ...
                    p.Results.EqualTo ...
                    );
                [dataTable, rowIndexes] = this.selectWhere( q, varargin{:} );
            elseif ~strcmp(p.Results.MatchAgainst, biotracs.core.db.Predicate.ANY)
                q = biotracs.core.db.Query.matchAgainst( ...
                    p.Results.WhereColumns, ...
                    p.Results.MatchAgainst ...
                    );
                [dataTable, rowIndexes] = this.selectWhere( q, varargin{:} );
            elseif ~strcmp(p.Results.NotMatchAgainst, biotracs.core.db.Predicate.ANY)
                q = biotracs.core.db.Query.notMatchAgainst( ...
                    p.Results.WhereColumns, ...
                    p.Results.NotMatchAgainst ...
                    );
                [dataTable, rowIndexes] = this.selectWhere( q, varargin{:} );
            elseif p.Results.GreaterThan ~= -Inf
                q = biotracs.core.db.Query.greaterThan( ...
                    p.Results.WhereColumns, ...
                    p.Results.GreaterThan ...
                    );
                [dataTable, rowIndexes] = this.selectWhere( q, varargin{:} );
            elseif p.Results.LessThan ~= Inf
                q = biotracs.core.db.Query.lessThan( ...
                    p.Results.WhereColumns, ...
                    p.Results.LessThan ...
                    );
                [dataTable, rowIndexes] = this.selectWhere( q, varargin{:} );
            elseif p.Results.GreaterOrEqualTo ~= -Inf
                q = biotracs.core.db.Query.greaterOrEqualTo( ...
                    p.Results.WhereColumns, ...
                    p.Results.GreaterOrEqualTo ...
                    );
                [dataTable, rowIndexes] = this.selectWhere( q, varargin{:} );
            elseif p.Results.LessOrEqualTo ~= Inf
                q = biotracs.core.db.Query.lessOrEqualTo( ...
                    p.Results.WhereColumns, ...
                    p.Results.LessOrEqualTo ...
                    );
                [dataTable, rowIndexes] = this.selectWhere( q, varargin{:} );
            elseif p.Results.Between(1) > -Inf || p.Results.Between(2) < Inf
                q = biotracs.core.db.Query.between( ...
                    p.Results.WhereColumns, ...
                    p.Results.Between ...
                    );
                [dataTable, rowIndexes] = this.selectWhere( q, varargin{:} );
            else
                dataTable = this;
                rowIndexes = 1:this.getNbRows();
            end
            
            %apply column filtering
            if ~strcmp(p.Results.FilterByColumnName, '.*')
                dataTable = dataTable.selectByColumnName( p.Results.FilterByColumnName );
            end
            
            %apply row filtering
            if ~strcmp(p.Results.FilterByRowName, '.*')
                rowIndexes = dataTable.getRowIndexesByName( p.Results.FilterByRowName, true );
                dataTable = dataTable.selectByRowIndexes( rowIndexes );
            end
            
            %apply column tag filtering
            if length(p.Results.FilterByColumnTag) == 2
                dataTable = dataTable.selectByColumnTag( p.Results.FilterByColumnTag );
            end
        end
        
        
        %        function  dataTable = transform( this, iTranformation, iColumns )
        %             p = inputParser();
        %             p.addParameter('concat_cols', '.*', @ischar);
        %             p.addParameter('add_cols','.*', @ischar);
        %        end
        
        function [dataTable, idx] = sortByRowNames( this )
            [sortedRowNames, idx] = sort(this.rowNames);
            if isequal(sortedRowNames, this.rowNames)
                idx = 1:length(this.rowNames);
                dataTable = this.copy();
                return;
            end
            
            dataTable = this.copy();
            dataTable.data = this.data( idx, : );
            dataTable.rowNames = this.rowNames(idx);
            for i=1:length(this.tags{1})
                dataTable.tags{1}(i) = this.tags{1}(idx(i));
            end
        end
        
        function [dataTable, idx] = sortByColumnNames( this )
            [sortedColumnNames, idx] = sort(this.columnNames);
            if isequal(sortedColumnNames, this.columnNames)
                idx = 1:length(this.columnNames);
                dataTable = this.copy();
                return;
            end
            
            dataTable = this.copy();
            dataTable.data = this.data( :, idx );
            dataTable.columnNames = this.columnNames(idx);
            for i=1:length(this.tags{2})
                dataTable.tags{2}(i) = this.tags{2}(idx(i));
            end
        end

    end
    
    % -------------------------------------------------------
    % Tranformation interfaces
    % -------------------------------------------------------
    
    methods(Access = public)
        
        % Concatenate horizontally several DataTable
        % Column names and tags are also concatenated in the final DataTable
        % Row names and tags of the first DataTable are used for the final
        % DataTable
        %> @param[in] Several DataTable
        %> @return The horizontally concatenated DataTable
        function dataTable = horzcat( varargin )
            if length(varargin) <= 1 || ischar(varargin{2})
                dataTable = varargin{1}.copy();
				%dataTable = varargin{1}.copy('IgnoreProcess', true);
                return;
            end
            
            data        = cellfun( @getData,varargin,'UniformOutput',false );
            colnames    = cellfun( @getColumnNames,varargin,'UniformOutput',false );
            coltags     = cellfun( @getColumnTags,varargin,'UniformOutput',false );
            
            %check data types
            classname = class(varargin{1});
            for i=1:length(varargin)
                if ~isa(varargin{i}, 'biotracs.data.model.DataTable')
                    error('Argument %d is invalid;\nOnly biotracs.data.model.DataTable (or subclasses of biotracs.data.model.DataTable) are allowed', i);
                end

            end

            dataTable = feval(...
                classname,...
                horzcat(data{:}), ...
                horzcat(colnames{:}), ...
                varargin{1}.getRowNames() ...
                );
            
            dataTable.tags{1} = varargin{1}.getRowTags(); 
            dataTable.tags{2} = horzcat(coltags{:});
            
            %preserve the meta of the first DataTable
            dataTable.doCopyMeta(varargin{1});
            %dataTable.meta = varargin{1}.meta;
        end
        
        % Merge horizontally several DataTable
        % Same behavior has horzcat expected that each table is sorted and
        % required to have the same row names (not necessarily in the same
        % order)
        %> @return The merged DataTable. The row names of the merged
        % DataTable are sorted
        %> @see vertcat
        function [ dataTable, discardedData ] = horzmerge( varargin )
            if length(varargin) <= 1 || ischar(varargin{2})
                dataTable = varargin{1}.copy();
				%dataTable = varargin{1}.copy('IgnoreProcess', true);
                discardedData = {};
                return;
            end
            
            forceMerge = false;
            checkNames = true;
            
            for i=1:length(varargin)
                if ~isa(varargin{i}, 'biotracs.data.model.DataTable')
                    if ischar( varargin{i} )
                        p = inputParser();
                        p.addParameter('Force', false, @islogical);
                        p.addParameter('CheckNames', true, @islogical);
                        %p.addParameter('AreRowNamesUnique', false, @islogical);
                        p.parse( varargin{i:end} );
                        forceMerge = p.Results.Force;
                        checkNames = p.Results.CheckNames;
                        varargin = varargin(1:i-1);
                        break;
                    else
                        error('BIOTRACS:DataTable:InvalidArgument','Invalid arguments or options');
                    end
                end
            end
            
            if checkNames
                %remove duplicated names
                for i=1:length(varargin)
                    [~, idx] = unique(varargin{i}.rowNames);
                    if length(idx) < length(varargin{i}.rowNames)
                        discaredIdx = true(1,getSize(varargin{i},1));
                        discaredIdx(idx) = false;
                        names = varargin{i}.rowNames(discaredIdx);
                        biotracs.core.env.Env.writeLog('%s', 'Warning: The following duplicated names are removed:');
                        biotracs.core.env.Env.writeLog('%s\n', names{:});
                        varargin{i} = varargin{i}.selectByRowIndexes(idx);
                    end
                end
                
                %check column names compatibility
                rnames = varargin{1}.rowNames;
                discaredRowNames = {};
                rowNamesMatch = true;
                for i=1:length(varargin)-1
                    n1 = length(rnames);
                    n2 = length(varargin{i+1}.rowNames);
                    discaredAIdx = true(1,n1);
                    discaredBIdx = true(1,n2);
                    [ newRnames, ia, ib ] = intersect(rnames, varargin{i+1}.rowNames);
                    discaredAIdx(ia) = false;
                    discaredBIdx(ib) = false;
                    discaredRowNames = [ discaredRowNames, rnames(discaredAIdx), varargin{i+1}.rowNames(discaredBIdx)]; %#ok<AGROW>
                    rnames = newRnames;
                    rowNamesMatch = rowNamesMatch && (length(rnames) == varargin{i}.getNbRows());
                end
                rowNamesMatch = rowNamesMatch && (length(rnames) == varargin{end}.getNbRows());
                
                n = length(varargin);
                discardedData = cell(1,n);
                %@TODO should not merge if rows are not unique
                if ~rowNamesMatch
                    if forceMerge
                        biotracs.core.env.Env.writeLog('%s', 'Warning: mismacthes in row names, force merging by discaring mismatches');
                        biotracs.core.env.Env.writeLog('%s is discarded\n', discaredRowNames{:} );
                        biotracs.core.env.Env.writeLog('The final row length is %d', length(rnames));

                        for i=1:n
                            idx = ismember(varargin{i}.rowNames, discaredRowNames);
                            discardedData{i} = varargin{i}.selectByRowIndexes(idx);
                        end
                        
                        for i=1:n
                            idx = ismember(varargin{i}.rowNames, rnames);
                            varargin{i} = varargin{i}.selectByRowIndexes(idx);
                        end
                    else
                        error('BIOTRACS:DataTable:RowNameMismatchs', 'Row names do not match');
                    end
                end
            end
            
            names = varargin{1}.getRowNames();
            areRowNamesInSameOrder = cellfun( @(x)(all(strcmp(names, x.rowNames))), varargin );
            if ~all(areRowNamesInSameOrder)
                for i=1:length(varargin)
                    varargin{i} = varargin{i}.sortByRowNames();
                end
            end
            
            dataTable = horzcat( varargin{:} );
        end
        
        % Concatenate vertically several DataTable
        % Row names and tags are also concatenated in the final DataTable
        % Column names and tags of the first DataTable are used for the final
        % DataTable
        %> @param[in] Several DataTable
        %> @return The vertically concatenated DataTable
        function dataTable = vertcat( varargin )
            if length(varargin) <= 1 || ischar(varargin{2})
                dataTable = varargin{1}.copy();
				%dataTable = varargin{1}.copy('IgnoreProcess', true);
                return;
            end
            
            data        = cellfun( @getData,varargin,'UniformOutput',false );
            rownames    = cellfun( @getRowNames,varargin,'UniformOutput',false );
            %coltags     = cellfun( @getColumnTags,varargin,'UniformOutput',false );
            rowtags     = cellfun( @getRowTags,varargin,'UniformOutput',false );
            
            %check data types
            classname = class(varargin{1});
            for i=1:length(varargin)
                if ~isa(varargin{i}, 'biotracs.data.model.DataTable')
                    error('Argument %d is invalid;\nOnly biotracs.data.model.DataTable (or subclasses of biotracs.data.model.DataTable) are allowed', i);
                end
                
                if ~strcmp(class(varargin{i}), classname)
                    %heterogeous datatype, return
                    %biotracs.data.model.DataTable by default
                    classname = 'biotracs.data.model.DataTable';
                    break;
                end
            end
            
            dataTable = feval(...
                classname,...
                vertcat(data{:}), ...
                varargin{1}.getColumnNames(), ...
                horzcat(rownames{:}) ...
                );
            
            dataTable.tags{1} = horzcat(rowtags{:});
            dataTable.tags{2} = varargin{1}.getColumnTags();
            
            %preserve meta of the first DataTable
            dataTable.doCopyMeta(varargin{1});
        end
        
        % Merge vertically several DataTable
        % Same behavior has vertcat expected that each table is sorted and
        % required to have the same column names (not necessarily in the same
        % order)
        %> @return The merged DataTable. The column names of the merged
        % DataTable are sorted
        %> @see vertcat
        function dataTable = vertmerge( varargin )
            if length(varargin) <= 1 || ischar(varargin{2})
                dataTable = varargin{1}.copy();
				%dataTable = varargin{1}.copy('IgnoreProcess', true);
                return;
            end
            
            n = length(varargin);
            if ischar(varargin{n-1})
                varargin(1:n-2) = cellfun( @transpose, varargin(1:n-2), 'UniformOutput', false );
            else
                varargin = cellfun( @transpose, varargin, 'UniformOutput', false );
            end
            
            try
                dataTable = horzmerge( varargin{:} );
                dataTable = transpose(dataTable);
            catch exception
                if strcmp(exception.identifier, 'BIOTRACS:DataTable:RowNameMismatchs')
                    error('BIOTRACS:DataTable:ColumnNameMismatchs', 'Column names do not match');
                else
                    rethrow(exception);
                end
            end
        end
        
    end
    
    
    
    % -------------------------------------------------------
    % Static methods
    % -------------------------------------------------------
    
    methods(Static)
        
        function this = fromDataObject( iDataObject )
            if ~isa( iDataObject, 'biotracs.data.model.DataObject' )
                error('A ''biotracs.data.model.DataObject'' is required');
            end
            this = biotracs.data.model.DataTable();
            this.doCopy( iDataObject );
        end
        
        function this = fromDataTable( iDataTable )
            if ~isa( iDataTable, 'biotracs.data.model.DataTable' )
                error('A ''biotracs.data.model.DataTable'' is required');
            end
            this = biotracs.data.model.DataTable();
            this.doCopy( iDataTable );
        end
        
        function this = fromDataMatrix( iDataMatrix )
            if ~isa( iDataMatrix, 'biotracs.data.model.DataMatrix' )
                error('A ''biotracs.data.model.DataMatrix'' is required');
            end
            this = biotracs.data.model.DataTable();
            this.doCopy( iDataMatrix );
        end
        
        function this = fromDataSet( iDataSet )
            if ~isa( iDataSet, 'biotracs.data.model.DataSet' )
                error('A ''biotracs.data.model.DataSet'' is required');
            end
            this = biotracs.data.model.DataTable();
            this.doCopy( iDataSet );
        end
        
        %@ToDo : replace by fromFile()
        function this = import( iFilePath, varargin )
            [~,~,ext] = fileparts(iFilePath);
            switch lower(ext)
                case {'.mat'}
                    this = biotracs.data.model.DataObject.import( iFilePath, varargin{:} );
                otherwise
                    process = biotracs.parser.model.TableParser();
                    process.getConfig().hydrateWith( varargin );
                    process.setInputPortData( 'DataFile', biotracs.data.model.DataFile(iFilePath) );
                    process.run();
                    this = process.getOutputPortData('ResourceSet').getAt(1);
                    this.doAppendTags( iFilePath, varargin{:} );
            end
        end
        
        function dataTable = convertMapToDataTable( iMap )
            keySet  = keys(iMap);
            m = length(keySet);
            
            %get all fields
            columnNames = {};
            for i=1:m
                s = iMap(keySet{i});
                fields = fieldnames(s)';
                idx = ismember(fields, columnNames);
                columnNames = [columnNames, fields(~idx)];
            end
            
            n = length(columnNames);
            rowNames = cell(1,m);
            data = cell( m,n );
            for i=1:m
                key = keySet{i};
                s = iMap(key);
                for j = 1:n
                    fieldname = columnNames{j};
                    if isfield(s,fieldname)
                        data{i,j} = s.(fieldname);
                    else
                        data{i,j} = '';
                    end
                end
                rowNames{i} = key;
            end
            dataTable = biotracs.data.model.DataTable(...
                data, ...
                columnNames, ...
                rowNames ...
                );
        end
        
        function oMap = convertDataTableToMap( this )
            [m,n] = getSize(this);
            oMap = containers.Map(); %cell(1,m);
            for i=1:m
                rowName = this.rowNames{i};
                s = struct();
                for j=1:n
                    columnName = this.columnNames{j};
                    s.(columnName) = this.getDataAt(i,j);
                end
                oMap( rowName ) = s;
            end
        end
        
    end
    
    
    % -------------------------------------------------------
    % Protected methodsimport
    % -------------------------------------------------------
    
    methods(Access = protected)

        function doCheckDataType( this, iData )
            this.doCheckDataType@biotracs.data.model.DataObject( iData );
            if ~isempty(this.data) && ~isequal(size(iData), getSize(this))
                error('Data dimensions do not match');
            end
        end
        
        function doCopy( this, iDataObject, varargin )
            this.doCopy@biotracs.data.model.DataObject( iDataObject, varargin{:} );
            if isa(iDataObject, 'biotracs.data.model.DataTable')
                this.columnNames            = iDataObject.columnNames;
                this.rowNames               = iDataObject.rowNames;
                this.tags                   = iDataObject.tags;
                this.subTableClassName      = this.className;   %override subTableClassName
                this.rowGroupStrategy       = iDataObject.rowGroupStrategy;
                this.columnGroupStrategy    = iDataObject.columnGroupStrategy;
            end
        end
        
        
        %Only copy current attributes (not parent class attributes)
        function doCopyData( this, iDataObject )
            if isa(iDataObject, 'biotracs.data.model.DataMatrix')
                 this.doSetData( num2cell( iDataObject.data ) );
            elseif isa(iDataObject, 'biotracs.data.model.DataTable')
                this.doSetData( iDataObject.data );
            elseif isa(iDataObject, 'biotracs.data.model.DataObject')
                if iscell( iDataObject.data )
                    this.doSetData( iDataObject.data );
                else
                    error('Cannot copy this DataObject as DataTable. The inner data is a %s must be a cell', class(iDataObject.data))
                end
            end
        end
        
        %-- P --
        
%         function tagJson = doConvertTagsToJson( this, iTagType )
%             if strcmp(iTagType, 'row')
%                 iTags = this.tags{1};
%             elseif strcmp(iTagType, 'column')
%                 iTags = this.tags{2};
%             else
%                 error('Unknown tag type');
%             end
%             
%             tagJson = jsonencode(iTags);
%         end
%         
%         function oTags = doConvertJsonToTag( ~, iTable )
%             [m,n] = size(iTable);
%             oTags = cell(1,m);
%             keys = iTable.Properties.VariableNames;
%             for i=1:m
%                 for j=1:n
%                     val = iTable{i,j};
%                     oTags{i}.(keys{j}) = val{1};
%                 end
%             end
%         end
        
        function tagTable = doConvertTagsToTable( this, iTagType )
            if strcmp(iTagType, 'row')
                iTags = this.tags{1};
            elseif strcmp(iTagType, 'column')
                iTags = this.tags{2};
            else
                error('Unknown tag type');
            end
            
            %preallocate fields
            uniqueTagKeys = {};
            n = length(iTags);
            for i=1:n
                if ~isempty(iTags{i})
                    uniqueTagKeys = [ uniqueTagKeys; fieldnames(iTags{i}) ];
                end
            end
            uniqueTagKeys = unique(uniqueTagKeys);
            for j=1:length(uniqueTagKeys)
                s(1).(uniqueTagKeys{j}) = [];
            end
            
            %export tags
            for i=1:n
                if ~isempty(iTags{i})
                    keys = fieldnames(iTags{i});
                    for j=1:length(keys)
                        s(i).(keys{j}) = iTags{i}.(keys{j});
                    end
                end
            end
            if exist('s','var')
                if length(s) < n   %fill the last entry
                    s(n).(keys{1}) = '';
                end
                tagTable = struct2table(s);
                
                if strcmp(iTagType, 'row')
                    tagTable.Properties.RowNames = this.rowNames;
                else
                    tagTable.Properties.RowNames = this.columnNames;
                end
            else
                tagTable = table();
            end
        end
        
        function oTags = doConvertTableToTag( ~, iTable )
            [m,n] = size(iTable);
            oTags = cell(1,m);
            keys = iTable.Properties.VariableNames;
            for i=1:m
                for j=1:n
                    val = iTable{i,j};
                    oTags{i}.(keys{j}) = val{1};
                end
            end
        end
        
        function doAppendTags( this, iFilePath, varargin )
            p = inputParser();
            p.addParameter('WorkingDirectory','',@ischar);
            p.addParameter('Delimiter','\t',@ischar);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            [dirpath,name,ext] = fileparts(iFilePath);
			
            rowTagFileName = fullfile(dirpath,[name,'.rtags.json']);
            columnTagFileName = fullfile(dirpath,[name,'.ctags.json']);
            
            switch lower(ext)
                case {'.xlsx','.xls'}
                    if isfile(columnTagFileName)
                        str = fileread(columnTagFileName);
                        if ~isempty(str)
                            t = jsondecode(str)';
                            this.tags{2} = arrayfun( @(x)(x), t, 'UniformOutput', false );
                        end
                    end
                    if isfile(rowTagFileName)
                        str = fileread(rowTagFileName);
                        if ~isempty(str)
                            t = jsondecode(str)';
                            this.tags{1} = arrayfun( @(x)(x), t, 'UniformOutput', false );
                        end
                    end
                    
                case {'.csv','.tsv','.txt'}
                    if isfile(columnTagFileName)
                        str = fileread(columnTagFileName);
                        if ~isempty(str)
                            t = jsondecode(str)';
                            this.tags{2} = arrayfun( @(x)(x), t, 'UniformOutput', false );
                        end
                    end
                    if isfile(rowTagFileName)
                        str = fileread(rowTagFileName);
                        if ~isempty(str)
                            t = jsondecode(str)';
                            this.tags{1} = arrayfun( @(x)(x), t, 'UniformOutput', false );
                        end
                    end
                otherwise
                    %...
            end
            
        end
        
    end
    
end