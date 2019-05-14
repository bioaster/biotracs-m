%"""
%biotracs.core.html.cell2list
%Convert and cell to a html list (using ol, ul, li tags)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%"""

function html = cell2list( iDataCell, iOrderedBullets )
    if nargin == 1
        iOrderedBullets = true;
    end
    
    if isnumeric(iDataCell)
        iDataCell = num2cell(iDataCell);
    end
    
    if iscell(iDataCell)
        if iOrderedBullets
            html = '<ol>';
        else
            html = '<ul>';
        end

        if isrow(iDataCell)
            iDataCell = iDataCell(:);
        end
        
        for i=1:size(iDataCell,1)
            dataStr = '';
            for j=1:size(iDataCell,2)
                data = iDataCell{i,j};
                if isnumeric(data)
                    data = num2str(data);
                end
                dataStr = strcat(dataStr, ', ', data);
            end
            if ~isempty(dataStr), dataStr = dataStr(2:end); end
            html = strcat(html, '<li>', dataStr, '</li>' );
        end

        if iOrderedBullets
            html = strcat(html, '</ol>');
        else
            html = strcat(html, '</ul>');
        end
    else
        error('Invalid list; A cell of string is required');
    end
end

