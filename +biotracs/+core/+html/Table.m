%"""
%biotracs.core.html.Table
%Table object allows manipulating and creating html tables
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.core.html.Figure, biotracs.core.html.Grid 
%"""

classdef Table < biotracs.core.html.DomChild
    
    properties(SetAccess = protected)
        data;
    end
    
    methods
        
        function this = Table( iTableData )
            this@biotracs.core.html.DomChild();
            this.tagName = 'table';
            this.attributes = struct(...
                'class', 'table table-striped table-bordered table-light', ...
                'style', 'border-collapse: collapse; border-spacing: 0px' ...
                );
            
            if nargin >= 1
                this.setData( iTableData );
            end
        end
        
        %-- A --

        %-- G --

        %-- S --
        
        function this = setData( this, iData )
            if ~isa(iData, 'biotracs.data.model.DataTable')
                error('BIOTRACS:Html:Table:InvalidArgument', 'Data must an instance of biotracs.data.model.DataTable');
            end
            this.data = iData;
        end
        
    end
    
    methods(Access = protected)
        
        function [ html ] = doGenerateHtml( this )
            header = horzcat({''}, this.data.getColumnNames());
            html = this.doWriteHeader(header);
            
            c = this.data.getData();
            if isnumeric(this.data.getData())
                c = num2cell(c);
            end
            rowNames = this.data.getRowNames();
            body = horzcat(rowNames(:), c);
            html = [html, this.doWriteRows(body) ];
            
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
            openingTag = [openingTag, '>'];
            html = [ openingTag, html, closingTag ];
        end
        
        %> @param iHeaderCell A cell of string containing headers. E.g. {'Column1', 'Column2', ..., 'ColumnN'}
        function html = doWriteHeader( ~, iHeaderCell )
            tag = {'thead', 'tfoot'};
            html = '';
            for i=1:2
                html = [html,'<',tag{i},'><tr>'];
                for col = 1:length(iHeaderCell)
                    html = [html, '<th style="max-width: 150px">', iHeaderCell{col} ,'</th>']; %#ok<AGROW>
                end
                html = [html, '</tr></',tag{i},'>'];
            end
        end
        
        %> @param iHeaderCell A cell of string containing headers.
        function html = doWriteRows( ~, iBodyCell )
            if isnumeric( iBodyCell )
                iBodyCell = num2cell(iBodyCell);
            end
            
            dim = size(iBodyCell);
            nrow = dim(1); ncols = dim(2);
            html = '<tbody>';
            for rowIdx = 1:nrow
                rowBody = '<tr>';
                for colIdx = 1:ncols
                    if iscell(iBodyCell{rowIdx,colIdx})
                        body = biotracs.core.html.cell2table( iBodyCell{rowIdx,colIdx} );
                    elseif isa(iBodyCell{rowIdx,colIdx}, 'biotracs.data.model.DataTable')
                        error('Nested DataTable not allowed');
                    else
                        body = iBodyCell{rowIdx,colIdx};
                    end
                    if isnumeric(body), body = num2str(body); end
                    rowBody = [rowBody, '<td>', body ,'</td>']; %#ok<AGROW>
                end
                rowBody = [rowBody, '</tr>']; %#ok<AGROW>
                html = [html, rowBody]; %#ok<AGROW>
            end
            html = [html, '</tbody>'];
        end
        
    end
    
    methods(Static)
    end

end

