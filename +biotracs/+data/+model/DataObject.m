%"""
%biotracs.data.model.DataObject
%Generic data object. The inner data can be any MATLAB object.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.data.model.DataTable, biotracs.data.model.DataMatrix, biotracs.data.model.DataSet 
%"""

classdef DataObject < biotracs.data.model.DataObjectInterface & biotracs.core.mvc.model.Resource
    
    properties(SetAccess = protected)
        data;               %any matlab object
        dataType = 'any';
    end
    
    properties(GetAccess = private, SetAccess = protected)
        
    end

    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataObject( iData )
            this@biotracs.core.mvc.model.Resource();
            if nargin == 1
                this.setData( iData );
            end
            this.bindView( biotracs.data.view.DataObject );
        end
        
        %-- C --

        %-- G --
        
        function oData = getData( this )
            oData = this.data;
        end

        %-- H --

        function tf = hasEmptyData( this )
            tf = isNil(this) || isempty(this.data);
        end

        %-- I --
        
        function tf = isEqualTo( this, iDataObject )
            if isa(this.data, 'biotracs.core.ability.Comparable')
                tf = this.data.isEqualTo( iDataObject.data );
                if ~tf, return; end
            end
            
            tf = this.isEqualTo@biotracs.core.mvc.model.Resource(iDataObject) ...
                && isequal(this.data,  iDataObject.data);
        end
        
        %-- S --
        
        function this = setData( this, iData )
            this.doSetData( iData );
        end

    end
    
    % -------------------------------------------------------
    % Static methods
    % -------------------------------------------------------
    
    methods(Static)
        
        function this = fromDataObject( iDataObject )
            this = iDataObject.copy();
        end
        
        function this = fromDataTable( iDataTable )
            if isa( iDataTable, 'biotracs.data.model.DataTable' )
                this = biotracs.data.model.DataObject( iDataTable.data );
            else
                error('A ''biotracs.data.model.DataTable'' is required');
            end
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)  
        
        function doCopy( this, iDataObject, varargin )
            this.doCopy@biotracs.core.mvc.model.Resource( iDataObject, varargin{:} );
            this.doCopyData( iDataObject );
            this.dataType = iDataObject.dataType;
        end
        
        function doCopyData( this, iDataObject )
            this.doSetData( iDataObject.data );
        end
        
        function doSetData( this, iData )
            this.doCheckDataType( iData );
            this.data = iData;
        end
       
        function doCheckDataType( this, iData )
            if ~strcmp(this.dataType, 'any') && ~isa( iData, this.dataType )
                error('Invalid data, A %s is required', this.dataType)
            end
        end
        
    end
    
    
end
