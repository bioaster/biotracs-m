%"""
%biotracs.core.ability.Queriable
%Base class to manage queries on Queriable objects such as DataTable,
%DataMatrix, DataSet, etc.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.data.model.DataTable, biotracs.data.model.DataTable,
%biotracs.data.model.DataMatrix, biotracs.data.model.DataSet 
%"""

classdef (Abstract) Queriable < handle
	 
	 properties(Constant)
	 end
	 
	 properties(SetAccess = protected)
	 end
	 
	 events
	 end
	 
	 % -------------------------------------------------------
	 % Public methods
	 % -------------------------------------------------------
	 
	 methods
		  
		  % Constructor
		  function this = Queriable()
				this@handle();
		  end
	 end
	 
	 % -------------------------------------------------------
	 % Public abstract methods/interfaces
	 % -------------------------------------------------------
	 
	 methods(Abstract, Access = public)
		  
		  % Select all the records that validate a query and applied a filter
		  % the retrun only a given set of fields
		  %> @param[in] iQuery [biotracs.core.db.Query] the query
		  %> @param[in] iFieldsFilter [string] a regexp used to filter fields
		  %> @return The records that match with the query in a queriable
		  % object
		  %queriable = select( this, iQuery, iFieldsFilter );
		  queriable = select( this, varargin )
		  
		  % Select all the records that validate a query
		  %> @param[in] iQuery [biotracs.core.db.Query] the query
		  %> @return The records that match with the query in a queriable
		  % object
		  %queriable = selectWhere( this, iQuery );
		  
		  queriable = insert( this, varargin );
		  queriable = remove( this, varargin );
		  
	 end
	 
end
