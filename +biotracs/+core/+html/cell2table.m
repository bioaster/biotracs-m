%"""
%biotracs.core.html.cell2table
%Convert and cell to a html table
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%"""

function html = cell2table( iDataCell )
    if iscell(iDataCell)
        html = '<table style="border-spacing: 0px; border-collapse: collaspe;">';
        for i=1:size(iDataCell,1)
            html = strcat(html,'<tr>');
            for j=1:size(iDataCell,2)
                data = iDataCell{i,j};
                if isnumeric(data)
                    data = num2str(data);
                end
                html = strcat(html,'<td style="border: 1px dotted #a9a9a9; padding: 3px">',data,'</td>');
            end
            html = strcat(html,'</tr>');
        end

        html = strcat(html, '</table>');
    else
        error('Invalid list; A cell of string is required');
    end
end
