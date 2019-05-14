%"""
%biotracs.core.html.cell2str
%Convert and cell to a flat string. Each cell row is converted to a new
%line. Cell columns are separated by a comma.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%"""

function html = cell2str( iDataCell )
    html = '';
    if iscell(iDataCell)
        n = size(iDataCell,1);
        for i=1:n
            dataStr = '';
            for j=1:size(iDataCell,2)
                data = iDataCell{i,j};
                if isnumeric(data)
                    data = num2str(data);
                end
                dataStr = strcat(dataStr, ', ', data);
            end
            if ~isempty(dataStr), dataStr = dataStr(2:end); end
            html = sprintf('%s\n%s', html, dataStr);
        end
        html = regexprep(html,'(<br/>)$','');
    else
        error('Invalid list; A cell of string is required');
    end
end

