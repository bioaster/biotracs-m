%"""
%biotracs.core.html.List
%List object allows manipulating and creating html lists
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%"""

classdef List < biotracs.core.html.DomChild
    
    properties
        data;
        isOrdered = false;
    end
    
    methods
        
        function this = List( iCellOrDataTable, iIsOrdered )
            this@biotracs.core.html.DomChild();
            this.tagName = 'ul,ol';
            if nargin >= 1
                this.setData( iCellOrDataTable );
            end
            
            if nargin >= 2
                this.isOrdered = iIsOrdered;
            end
        end
        
        %-- A --

        %-- S --
        
        function this = setIsOrdered( this, iIsOrdered )
            this.isOrdered = iIsOrdered;
        end
        
        function this = setData( this, iData )
            if ~iscell(iData) && ~isa(iData, 'biotracs.data.model.DataTable')
                error('BIOTRACS:Html:List:InvalidArgument', 'Data must be a biotracs.data.model.DataTable');
            end
            this.data = iData;
        end
        
    end
    
    methods(Access = protected)
        
        function [ html ] = doGenerateHtml( this )
            if iscell(this.data)
                html = biotracs.core.html.cell2list( this.data, this.isOrdered );
            else %-- is DataTable
                html = biotracs.core.html.cell2list( this.data.getData(), this.isOrdered );
            end
        end

    end
    
end

