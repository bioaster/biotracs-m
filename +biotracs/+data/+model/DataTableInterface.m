%"""
%biotracs.data.model.DataTableInterface
%DataTable interface
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.data.model.DataTable
%"""

classdef (Abstract) DataTableInterface < biotracs.core.ability.Queriable & biotracs.data.model.DataObjectInterface
    
    properties(SetAccess = protected)
    end
    
    properties(Dependent = true)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataTableInterface( )
            this@biotracs.core.ability.Queriable();
            this@biotracs.data.model.DataObjectInterface();
        end
        
    end
    
    % -------------------------------------------------------
    % Abstract interfaces
    % -------------------------------------------------------
    
    methods( Abstract )
        
        %-- G --
        
        % Getters

        % Get data of columns of which names match with a given pattern
        %> @param[in] iSearchedLabelPattern Pattern to search (RegExp)  
        %> @param[in] iIsCaseSensitive True for case-sensitive match, False otherwise 
        %> @return The data corresponding to the columns found
        %> @return The indexes of the columns found
        [data, indexes] = getDataByColumnName( this, iSearchedLabelPattern, iIsCaseSensitive );
        
        % Get data of rows of which names match with a given pattern
        %> @param[in] iSearchedLabelPattern Pattern to search (RegExp)  
        %> @param[in] iIsCaseSensitive True for case-sensitive match, False otherwise 
        %> @return The data corresponding to the rows found
        %> @return The indexes of the rows found
        [data, indexes] = getDataByRowName( this, iSearchedLabelPattern, iIsCaseSensitive );
        
        % Get data of columns of which tags match with a given (key,value) tag
        %> @param iTagKey The key of the tag  
        %> @param iSearchedTagValue The value of the tag searched  
        %> @return The data corresponding to the columns found
        %> @return The indexes of the columns found
        [data, indexes] = getDataByColumnTag( this, iTags );
        
        nrows = getNbRows( this );

        ncols = getNbColumns( this );

        len = getLength( this );
        
        % Vectorized getter
        % Get the names of given rows
        %> @return cell of string
        rowNames = getRowNames( this, iRowIndexes );
        
        % Vectorized getter
        % Get the names of given columns
        %> @return cell of string
        columnNames = getColumnNames( this, iColumnIndexes );
        
        % Get the name of a given row
        %> @return string
        rowName = getRowName( this, iRowIndex );
        
        % Get the name of a given column
        %> @return string
        columnName = getColumnName( this, iColumnIndex );
        
        % Get the tags of all (or a given) row(s)
        %> @param[in] iRowIndex [optional, integer] The index of the row
        %> @Return A struct representing the tag
        getRowTag( this, iRowIndex );
        
        % Get the tags of all (or given) column(s)
        %> @param[in] iColumnIndex [optional, integer] The indexes of the
        % columns
        %> @Return A struct representing the tag
        getColumnTag( this, iColumnIndex );
        
        % Get the tags of all (or given) row(s)
        %> @param[in] iRowIndex [optional, array] The indexes of the rows
        %> @return A cell of struct corresponding to row tags
        getRowTags( this, iRowIndex );
        
        % Get the tags of all (or a given) column(s)
        %> @param[in] iColumnIndex [optional, array] The indexes of the
        % columns
        %> @return A cell of struct corresponding to column tags
        getColumnTags( this, iColumnIndex );
        
        getColumnIndexesByName( this, iSearchedLabelPattern, iIsCaseSensitive );
        
        getRowIndexesByName( this, iSearchedLabelPattern, iIsCaseSensitive );
        
        getRowIndexesByTag( this, iTags );
        
        getColumnIndexesByTag( this, iTags );
        
        %-- S --
        
        % Setters
        
        this = setRowNames( this, iNames );
        
        this = setColumnNames( this, iNames );

        this = setRowName( this, iIndex, iName );
        
        this = setColumnName( this, iIndex, iName );
        
        this = setRowTag( this, iRowIndex, iKey, iValue );
        
        this = setColumnTag( this, iColumnIndex, iKey, iValue );
        
        
        % Queries
        
        dataTable = select( this, iQuery, iFields );
        
        dataTable = selectByColumnIndexes( this, iColumnIndexes );
        
        dataTable = selectByRowIndexes( this, iRowIndexes );

        % Search columns of which labels match with a given pattern and select the corresponding Data*
        %> @param[in] iSearchedPattern Pattern to search (RegExp)  
        %> @param[in] iIsCaseSensitive True if case-sensitive, False otherwise
        %> @return The Data* corresponding to the columns found
        dataTable = selectByColumnName( this, iSearchedLabelPattern, iIsCaseSensitive );
        
        % Search rows of which labels match with a given pattern and select the corresponding Data*
        %> @param[in] iSearchedLabelPattern Pattern to search (RegExp)  
        %> @param[in] iIsCaseSensitive True if case-sensitive, False otherwise
        %> @return The Data* corresponding to the rows found
        dataTable = selectByRowName( this, iSearchedLabelPattern, iIsCaseSensitive );
        
        % Search tags of which labels match with a given pattern and select the corresponding Data*
        %> @param[in] iSearchedLabelPattern Pattern to search (RegExp)  
        %> @return The Data* corresponding to the columns found
        dataTable = selectByColumnTag( this, iTagKey, iSearchedTagValue );
        
        % Transformation
        
        %dataTable = transform( this, iTranformation, iColumns );
        
        dataTable = horzcat( this, iDataTable );
        dataTable = vertcat( this, iDataTable );
    end

end
