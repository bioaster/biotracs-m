%"""
%biotracs.data.model.DataMatrix
%DataMatrix object. A DataSet is a DataMatrix, but for machine learning analysis. The columns of the inner data of a DataSet can be tagged as X input data (by default) or Y output data for supervised analysis.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.data.model.DataObject, biotracs.data.model.DataTable, biotracs.data.model.DataMatrix
%"""

classdef DataSet < biotracs.data.model.DataMatrix
    
    properties(Dependent = true)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        %> @param[in] iData Array of double || biotracs.data.model.DataSet
        %> @param[in] iColumnNames [optional] Cell of string
        %> @param[in] iRowNames [optional] Cell of string
        function this = DataSet( iData, varargin )
            if nargin == 0, iData = []; end
            this@biotracs.data.model.DataMatrix( iData, varargin{:} );
            this.bindView( biotracs.data.view.DataSet );
        end
        
        %-- C --
        
        function YDataSet = createYDataSet( this, iGroupLabel )
            rowGrpStrat = this.createRowGroupStrategy();
            
            if nargin == 1
                [idx, sliceNames] = rowGrpStrat.getSlicesIndexes();
            else
                [idx, sliceNames] = rowGrpStrat.getSlicesIndexesOfGroup(iGroupLabel);
            end

            nbSlices = length(sliceNames);
            YDataSet = biotracs.data.model.DataSet( double(idx) );
            for j=1:nbSlices
                YDataSet.setColumnTag( j, 'IsOutput', 'yes' );
                YDataSet.setColumnTag( j, 'IsCategorical', 'yes' );
                YDataSet.setColumnName( j, sliceNames{j} );
            end
            
            YDataSet.doCopyMeta(this);
            YDataSet.setLabel( this.getLabel() );
            YDataSet.setRowNames( this.rowNames );
            YDataSet.setRowNamePatterns( this.meta.rowNamePatterns );
        end
        
        function XYDataSet = createXYDataSet( this, iGroupLabel )
            if nargin == 1
                YDataSet = this.createYDataSet();
            else
                YDataSet = this.createYDataSet(iGroupLabel);
            end
            
            XYDataSet = horzcat(this.selectXSet(), YDataSet);
            XYDataSet.doCopyMeta(this);
            XYDataSet.setLabel( this.getLabel() );
        end
         
        %-- G --
        
        function position = getVariablePositions( this, varargin )
            names = this.getColumnNames();
            position = str2double(names);
            if any(isnan( position ))
                position = 1:getSize(this,2);
            end
        end
        
        function n = getNbVariables( this )
            indexes = this.getColumnIndexesByTag( {'IsOutput', '~yes'} );
            n = length(indexes);
        end
        
        function n = getNbResponses( this )
            indexes = this.getColumnIndexesByTag( {'IsOutput', 'yes'} );
            n = length(indexes);
        end
        
        function oNames = getVariableNames( this, varargin )
            indexes = this.getColumnIndexesByTag( {'IsOutput', '~yes'} );
            oNames = this.getColumnNames( indexes(varargin{:}) );
        end
        
        function oNames = getResponseNames( this, varargin )
            indexes = this.getColumnIndexesByTag( {'IsOutput', 'yes'} );
            oNames = this.getColumnNames( indexes(varargin{:}) );
        end
        
        % Alias of getRowNames (for all row names)
        % Cannot be used to select a given range of row names
        function oNames = getInstanceNames( this, varargin )
            oNames = this.getRowNames( varargin{:} );
        end
        
        function indexes = getOutputIndexes( this )
            indexes = this.getColumnIndexesByTag( ...
                {'IsOutput', 'yes'} ...
            );
        end
        
        function indexes = getInputIndexes( this )
            indexes = 1:this.getNbColumns();
            yIdx = this.getOutputIndexes();
            indexes(yIdx) = [];
        end
        
        %-- H --
        
        function tf = hasResponses( this )
            indexes = this.getColumnIndexesByTag( {'IsOutput', 'yes'} );
            tf = ~isempty(indexes);
        end
        
        function tf = hasCategoricalResponses( this )
            indexesA = this.getColumnIndexesByTag( ...
                {'IsOutput', 'yes'} ...
            );
            indexesB = this.getColumnIndexesByTag( ...
                {'IsCategorical', 'yes'} ...
            );
            tf = ~isempty( intersect(indexesA,indexesB) );
        end
        
        %-- T --
        
        % Depreacated. Use setOutputIndexes instead
        function tagYSet( this, iColumnIndexes )
            warning('BIOTRACS:DataSet:DeprecatedMethod','Method ''tagYSet'' is deprecated and will be removed in next releases. Please use ''setOutputIndexes'' instead.');
            this.setOutputIndexes(iColumnIndexes);
        end
        
        function dataMatrix = toDataMatrix( this )
            dataMatrix = biotracs.data.model.DataMatrix.fromDataSet(this);
        end
        
        function dataSet = toDataSet( this )
            dataSet = biotracs.data.model.DataSet.fromDataSet(this);
        end
        
        %-- S --

        function setOutputIndexes( this, iColumnIndexes )
            for i=iColumnIndexes
               this.setColumnTag( i, 'IsOutput', 'yes' );
            end
        end
        
        function XSet = selectXSet( this )
            if this.hasResponses()
                XSet = this.selectByColumnTag({'IsOutput', '~yes'});
            else
                XSet = this.copy();
            end
        end
        
        function YSet = selectYSet( this )
            YSet = this.selectByColumnTag({'IsOutput', 'yes'});
        end
        
        %-- R --
        
    end

    % -------------------------------------------------------
    % Static methods
    % -------------------------------------------------------
    
    methods(Static)
        
        function this = fromDataObject( iDataObject )
            if ~isa( iDataObject, 'biotracs.data.model.DataObject' )
                error('BIOTRACS:DataSet:InvalidArgument','Invalid argument. A ''biotracs.data.model.DataObject'' is required');
            end
            this = biotracs.data.model.DataSet();
            this.doCopy( iDataObject );
        end
        
        function this = fromDataTable( iDataTable )
            if ~isa( iDataTable, 'biotracs.data.model.DataTable' )
                error('BIOTRACS:DataSet:InvalidArgument','Invalid argument. A ''biotracs.data.model.DataTable'' is required');
            end
            this = biotracs.data.model.DataSet();
            this.doCopy( iDataTable );
        end
        
        function this = fromDataMatrix( iDataMatrix )
            if ~isa( iDataMatrix, 'biotracs.data.model.DataMatrix' )
                error('BIOTRACS:DataSet:InvalidArgument','Invalid argument. A ''biotracs.data.model.DataMatrix'' is required');
            end
            this = biotracs.data.model.DataSet();
            this.doCopy( iDataMatrix );
        end
        
        function this = fromDataSet( iDataSet )
            if ~isa( iDataSet, 'biotracs.data.model.DataSet' )
                error('BIOTRACS:DataSet:InvalidArgument','Invalid argument. A ''biotracs.data.model.DataSet'' is required');
            end
            this = biotracs.data.model.DataSet();
            this.doCopy( iDataSet );      
        end

        function this = import( iFilePath, varargin )
            isTableClassDefined = any(strcmpi(varargin, 'TableClass'));
            if ~isTableClassDefined
                varargin = [varargin, {'TableClass', 'biotracs.data.model.DataSet'}];
            end
            this = biotracs.data.model.DataMatrix.import(iFilePath, varargin{:});
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        %-- P --

        %-- R --
        
    end
    
end
