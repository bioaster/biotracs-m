%"""
%biotracs.data.model.DataMatrix
%DataMatrix object. The inner data of a DataMatrix is a array of numeric values
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.data.model.DataMatrixInterface, biotracs.data.model.DataObject, biotracs.data.model.DataTable, biotracs.data.model.DataSet 
%"""

classdef DataMatrix < biotracs.data.model.DataMatrixInterface & biotracs.data.model.DataTable % & biotracs.core.ability.Helpable
    
    properties(SetAccess = protected)
    end
    
    properties(Dependent = true)
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
        function this = DataMatrix( iData, iColumnNames, iRowNames, iTags )
            this@biotracs.data.model.DataMatrixInterface();
            this@biotracs.data.model.DataTable();
            this.dataType = 'numeric';
            
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
            this.subTableClassName = this.className;
            this.bindView( biotracs.data.view.DataMatrix );
        end
        
        %-- A --
        
        %-- C --

        %-- D --
        
        function dataMatrix = datafun( this, fun )
            dataMatrix = this.copy();
            dataMatrix.data = arrayfun(fun, dataMatrix.data);
        end
        
        %-- E --
        
        %-- F --
        
        %-- G --
        
        function val = getDataAt(this, i, j)
            if nargin == 2
                val = this.data(i);
            else
                val = this.data(i,j);
            end
        end
        
        %-- E --
        
        function export( this, iFilePath, varargin )
            p = inputParser();
            %p.addParameter('WorkingDirectory','',@ischar);
            p.addParameter('Delimiter','\t',@ischar);
            p.addParameter('WriteRowNames', true, @islogical);
            p.addParameter('WriteColumnNames', true, @islogical);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            [dirpath,filename,ext] = fileparts(iFilePath);
            if ~isempty(dirpath) && ~isfolder(dirpath)
                mkdir(dirpath);
            end
            
            if isfile(iFilePath)
                delete(iFilePath);
            end
            
            areRowNamesEmpty = cellfun('isempty', this.rowNames );
            areColumnNamesEmpty = cellfun('isempty', this.columnNames );
            writeRowNames =  p.Results.WriteRowNames && all(~areRowNamesEmpty);
            writeColumnNames = p.Results.WriteColumnNames && all(~areColumnNamesEmpty);
            
            switch lower(ext)
                case {'.xlsx','.xls'}
                    
                    if writeRowNames && writeColumnNames
                        [status, ~] = xlswrite( iFilePath, [ {''}, this.columnNames ; this.rowNames(:), num2cell(this.data) ] );
                    elseif writeRowNames
                        [status, ~] = xlswrite( iFilePath, [ this.rowNames(:), num2cell(this.data) ] );
                    elseif writeColumnNames
                        [status, ~] = xlswrite( iFilePath, [ this.columnNames; num2cell(this.data) ] );
                    else
                        [status, ~] = xlswrite( iFilePath, num2cell(this.data) );
                    end
                    
                    if ~status
                        biotracs.core.env.Env.writeLog( '%s', 'Cannot export to Excel format (.xlsx,.xls), try to export to text format (.csv)' );
                        this.export( [dirpath,'/',filename,'.csv'] );
                    end
                    
                case {'.csv','.txt','.tsv'}
                    fid = -1;
                    try
                        fid = fopen(iFilePath,'w');
                        if fid == -1
                            error('BIOTRACS:DataMatrix:Export:InvalidFid', 'The file directory does not exist');
                        end
                        
                        if writeRowNames && writeColumnNames
                            c =  [ {''}, this.columnNames ; this.rowNames(:), num2cell(this.data) ];
                        elseif writeRowNames
                            c = [ this.rowNames(:), num2cell(this.data) ];
                        elseif writeColumnNames
                            c = [ this.columnNames; num2cell(this.data) ];
                        else
                            c = num2cell(this.data);
                        end
                        
                        delim = p.Results.Delimiter;
                        [m,n] = size(c);
                        if writeRowNames
                            if writeColumnNames
                                format = repmat({'%s'},1,n-1);
                                format = ['%s', delim, strjoin(format, delim), '\n'];
                                fprintf(fid,format,c{1,:});
                                k = 2;
                            else
                                k = 1;
                            end
                            format = repmat({'%1.9e'},1,n-1);
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
                            format = repmat({'%1.9e'},1,n);
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
            
            %try
                this.exportTags( iFilePath, varargin{:} );
            %catch exception
            %    warning(exception.identifier, 'Cannot export tags\n%s', exception.message);
            %end
        end
        
        
 
        %-- R --
        
		 function [dataMatrix] = replace( this, iSearchValue, iReplacementValue )
            dataMatrix = this.copy();
			if ~isnumeric(iSearchValue) || ~isscalar(iSearchValue) || ~isnumeric(iReplacementValue) || ~isscalar(iReplacementValue)
				error('BIOTRACS:DataMatrix:InvalidArguments', 'The search and replacement values must be scalar numerics')
			end
			if isnan(iSearchValue)
				dataMatrix.data(isnan(dataMatrix.data)) = iReplacementValue;
			else
				dataMatrix.data( dataMatrix.data == iSearchValue ) = iReplacementValue;
			end
        end
    
        %-- S --
        
        % Set data values
        %> @param[in] iData N-by-2 array of double OR a N-by-2 table of array of double
        function this = setData( this, iData, iResetNames )
            if nargin <= 2, iResetNames = true; end
            this.setData@biotracs.data.model.DataTable( iData, iResetNames );
        end
        
        function this = setDataAt(this, i, j, iValue)
            if ~isnumeric(iValue)
                error('A numeric scalar value is required');
            end
            
            if isnumeric(i) && isnumeric(j)
                [m,n] = size(this.data);
                if max(i) > m || max(j) > n
                    error('Index exceeds data dimensions');
                end
            end
            
            this.data(i,j) = iValue;
        end
        
        %function [] = sortrows( ~ )
        %    error('This method has been deactivated');
        %end
        
        function [ds, idx] = sortRows( this, column )
            if nargin == 1
                column = 1;
            end
            ds = this.copy();
            [sdata, idx] = sortrows(this.data, column);
            ds.data = sdata;
            ds.rowNames = this.rowNames(idx);
            %ToDo : fix bug !
            %ds.tags{2} = this.tags{2}(idx);
            for i=1:length(this.tags{1})
                ds.tags{1}(idx(i)) = this.tags{1}(i);
            end
        end
        
        %-- T --
        
        % Overload toMatrix()
        %> @return The member @a data
        function oMatrix = toMatrix( this )
            oMatrix = this.data;
        end
        
        % Overload toTable()
        function oTable = toTable( this )
            oTable = array2table(this.data);
            try
                oTable.Properties.RowNames = this.getRowNames();
            catch err
                biotracs.core.env.Env.writeLog('%s\n%s', 'Cannot set all row names; Row names are may be truncated.', err.message);
            end
            
            try
                oTable.Properties.VariableNames = this.getColumnNames();
            catch err
                biotracs.core.env.Env.writeLog('%s\n%s', 'Cannot set all column names; Column names are may be truncated.', err.message);
            end
        end
        
        function dataSet = toDataSet( this )
            dataSet = biotracs.data.model.DataSet.fromDataMatrix(this);
        end
        
        function dataTable = toDataTable( this )
            dataTable = biotracs.data.model.DataTable.fromDataMatrix(this);
        end
        
        %--Z--
        function dataMatrix = zerosToNan( this )
            dataMatrix = this.copy();
            dataMatrix.data(dataMatrix.data==0) = NaN;
            
        end
        
    end
    
    % -------------------------------------------------------
    % Public Math methods
    % -------------------------------------------------------
    
    methods(Access = public)
        
        function [ stats ] = computeStatistics( this, varargin )
            process = biotracs.dataproc.model.DataStatsCalculator();
            process.setInputPortData('DataMatrix', this);
            c = process.getConfig();
            c.hydrateWith(varargin)
            process.run();
            [ stats ] = process.getOutputPortData('Statistics');
        end
        
        function sdm = standardize( this, varargin )
            process = biotracs.dataproc.model.DataStandardizer();
            process.setInputPortData('DataMatrix', this);
            c = process.getConfig();
            c.hydrateWith(varargin);
            process.run();
            [ sdm ] = process.getOutputPortData('DataMatrix');
        end
        
        %> @warning: It is recommanded to use computeStatistics() to allow
        % full traceability
        function m = mean( this, varargin )
            p = inputParser();
            p.addParameter('Direction','column',@ischar);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            %ToDo : Define mean process
            if strcmp(p.Results.Direction, 'column')
                dir = 1;
                dirPrefix = 'Column';
            else
                dir = 2;
                dirPrefix = 'Row';
            end
            
            m = biotracs.data.model.DataMatrix();
            m.setData( mean(this.data, dir, 'omitnan') )...
                .setLabel( [dirPrefix, ' means'] )...
                .setDescription( ['Mean matrix of ', this.label] );
            
            if strcmp(p.Results.Direction, 'column')
                m.setColumnNames( this.columnNames )...
                    .setRowNames( {'Mean'} );
            else
                m.setColumnNames( {'Mean'} )...
                    .setRowNames( this.rowNames );
            end
            
        end
        
%         function [ dataSet ] = normalize( this, varargin )
%             p = inputParser();
%             p.addParameter('Center', true, @islogical);
%             p.addParameter('Scale', 'uv', @ischar);
%             p.addParameter('Direction', 'column', @ischar);
%             p.KeepUnmatched = true;
%             p.parse(varargin{:});
%     
%             normalizedData = biotracs.core.math.centerscale( ...
%                 this.data, ...
%                 'Center', p.Result.Center, ...
%                 'Scale', p.Result.Scale, ...
%                 'Direction', p.Result.Direction ...
%                 );
%             
%             dataSet = this.copy();
%             dataSet.setData( normalizedData, false );
%         end
        
        %> @warning: It is recommanded to use computeStatistics() to allow
        % full traceability
        function s = std( this, varargin )
            p = inputParser();
            p.addParameter('Direction','column',@ischar);
            p.addParameter('Unbiased',true,@islogical);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            if strcmp(p.Results.Direction, 'column')
                dir = 1;
                dirPrefix = 'Column';
            else
                dir = 2;
                dirPrefix = 'Row';
            end
            
            if p.Results.Unbiased
                biased = 0;
                biasPrefix = 'Unbiased';
            else
                biased = 1;
                biasPrefix = 'Biased';
            end
            
            %ToDo : Define std process
            s = biotracs.data.model.DataMatrix();
            s.setData( std(this.data, biased, dir, 'omitnan') )...
                .setLabel( [dirPrefix, ' standard deviations'] )...
                .setDescription( [biasPrefix, ' standard deviation matrix of ', this.label] );
            
            if strcmp(p.Results.Direction, 'column')
                s.setColumnNames( this.columnNames )...
                    .setRowNames( {'Std'} );
            else
                s.setColumnNames( {'Std'} )...
                    .setRowNames( this.rowNames );
            end
        end
        
        function [dRho, dPval] = corr( X, Y )
            if nargin == 1
                [rho, pval] = corr( X.data, X.data );
                xnames = X.columnNames;
                ynames = xnames;
            else
                [rho, pval] = corr( X.data, Y.data );
                xnames = X.columnNames;
                ynames = Y.columnNames;
            end
            
            dRho = biotracs.data.model.DataMatrix( rho, ynames, xnames );
            dRho.setLabel('Values of correlation matrix');
            
            dPval = biotracs.data.model.DataMatrix( pval, ynames, xnames );
            dPval.setLabel('Pvalues of correlation matrix');
        end
        
        % Coefficient of variation (std/mean)
        %> @warning: It is recommanded to use computeStatistics() to allow
        % full traceability
        function [ cv ] = varcoef( this, varargin )
            p = inputParser();
            p.addParameter('Direction','column',@ischar);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            sd = std(this, varargin{:});
            m = mean(this, varargin{:});
            
            cv = biotracs.data.model.DataMatrix(...
                sd.data ./ m.data);
            
            if strcmp(p.Results.Direction, 'column')
                cv.setColumnNames( this.columnNames )...
                    .setRowNames( {'CV'} );
            else
                cv.setColumnNames( {'CV'} )...
                    .setRowNames( this.rowNames );
            end
            
            cv.setLabel( [p.Results.Direction, ' CV'] )...
                .setDescription( ['CV matrix of ', this.label] );
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
            this = biotracs.data.model.DataMatrix();
            this.doCopy( iDataObject );
        end
        
        function this = fromDataTable( iDataTable )
            if ~isa( iDataTable, 'biotracs.data.model.DataTable' )
                error('A ''biotracs.data.model.DataTable'' is required');
            end
            this = biotracs.data.model.DataMatrix();
            this.doCopy( iDataTable );
        end
        
        function this = fromDataMatrix( iDataMatrix )
            if ~isa( iDataMatrix, 'biotracs.data.model.DataMatrix' )
                error('A ''biotracs.data.model.DataMatrix'' is required');
            end
            this = biotracs.data.model.DataMatrix();
            this.doCopy( iDataMatrix );
        end
        
        function this = fromDataSet( iDataSet )
            if ~isa( iDataSet, 'biotracs.data.model.DataSet' )
                error('A ''biotracs.data.model.DataSet'' is required');
            end
            this = biotracs.data.model.DataMatrix();
            this.doCopy( iDataSet );
        end
        
        function this = import( iFilePath, varargin )
            isTableClassDefined = any(strcmpi(varargin, 'TableClass'));
            if ~isTableClassDefined
                varargin = [varargin, {'TableClass', 'biotracs.data.model.DataMatrix'}];
            end
            this = biotracs.data.model.DataTable.import( iFilePath, varargin{:} );
        end
        
    end
    
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function doCopyData( this, iDataObject )
            if isa(iDataObject, 'biotracs.data.model.DataMatrix')
                 this.doSetData( iDataObject.data );
            elseif isa(iDataObject, 'biotracs.data.model.DataTable')
                try
                   if iscellstr( iDataObject.data )
                       this.doSetData( str2double(iDataObject.data) );
                   else
                       this.doSetData( cell2mat(iDataObject.data) );
                   end
               catch err
                   error('Cannot copy this DataObject as DataMatrix. The inner data is a %s and cannot be converted to numeric array\n%s', class(iDataObject.data), err.message);
               end
            elseif isa(iDataObject, 'biotracs.data.model.DataObject')
                if iscell( iDataObject.data )
                    this.doSetData( iDataObject.data );
                else
                    error('Cannot copy this DataObject as DataMatrix. The inner data is a %s must be a numeric array', class(iDataObject.data))
                end
            end
        end
        
    end
end
