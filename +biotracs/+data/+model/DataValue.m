%"""
%biotracs.data.model.DataValue
%DataValue object. The inner data of DataValue is a scalar logical, scalar numeric or a string
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2018
%* See: biotracs.data.model.DataObject, biotracs.data.model.DataTable, biotracs.data.model.DataMatrix
%"""

classdef DataValue < biotracs.data.model.DataObject
    
    properties(SetAccess = protected)
    end
    
    properties(Dependent = true)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataValue( iData )
            this@biotracs.data.model.DataObject();
            if nargin == 1
                this.setData(iData);
            end
        end
        
    end
    
    methods(Access = protected)
        function doCheckDataType( this, iData )
            this.doCheckDataType@biotracs.data.model.DataObject(iData);
            
            if ~isscalar(iData) && ~islogical(iData) && ~isnumeric(iData) && ~ischar(iData)
                error('Invalid data. A scalar logical, scalar numeric or a string are required');
            end
        end
    end
    
end

