%"""
%biotracs.core.html.Grid
%Grid object allows manipulating and creating html grids (base on html div)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Table 
%"""

classdef Grid < biotracs.core.html.Div
    
    properties(SetAccess = protected)
        nbRows;
        nbColumns;
    end
    
    properties(Access = protected)
        map = {};
    end
    
    methods
        
        function this = Grid( iNbRow, iNbCols )
            this@biotracs.core.html.Div( );
            this.attributes = struct(...
                'class', '' ...
            );
            if iNbCols > 12
               error('BIOTRACS:Html:Grid:NbRowsOutOfRange', 'The number of rows mus be lower or equal to 12'); 
            end
            this.nbRows = iNbRow;
            this.nbColumns = iNbCols;
            this.map = cell(iNbRow, iNbCols);
            for i=1:iNbRow
                rowDiv = biotracs.core.html.Div();
                rowDiv.setAttributes( struct('class','row') );
                for j=1:iNbCols
                    colDiv = biotracs.core.html.Div();
                    colDiv.setAttributes( struct('class','col') );
                    rowDiv.append(colDiv);
                    this.map{i,j} = colDiv;
                end
                this.append(rowDiv);
            end
        end

        function div = getAt( this, iRowIndex, iColumnIndex )
            div = this.map{iRowIndex, iColumnIndex};
        end
        
        
        function div = appendAt( this, iRowIndex, iColumnIndex, iData )
            div = this.map{iRowIndex, iColumnIndex};
            div.append(iData);
        end
        
    end
    
    methods(Access = protected)
        
        function [ html ] = doGenerateHtml( this )
            openingTag = ['<',this.tagName ];
            closingTag = ['</',this.tagName,'>'];
            %write attributes
            attr = this.getAttributes();
            if ~isempty(attr)
                attrNames = fields(attr);
                for i=1:length(attrNames)
                    openingTag = [ openingTag, ' ', attrNames{i}, '="', attr.(attrNames{i}), '"' ];
                end
            end
            openingTag = [openingTag, ' id="',this.uid,'">'];
            
            html = '';
            for i=1:getLength( this.children )
                html = strcat( html, this.children.getAt(i).generateHtml() );
            end
            
            html = [ openingTag, html closingTag ];
        end

    end
    
end

