%"""
%biotracs.core.utils.flattencell
%Convert a nested cell to a flat cell
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%"""

function [ oFlattenCell ] = flattencell( iNestedCell, varargin )
    if ~iscell(iNestedCell)
        error('Invalid argument. A cell is required');
    end
    
    p = inputParser();
    p.addParameter('QuoteString', false, @islogical)
    p.parse(varargin{:});
    
    oFlattenCell = iNestedCell;
    if iscellstr(iNestedCell), return; end
    if isempty(iNestedCell)
        oFlattenCell = '';
        return;
    end
    
    maxStringLength = 32767;        %/!\ For Excel compatibility
    
    [m,n] = size(iNestedCell);
    for i=1:m
        for j=1:n
            if ischar( iNestedCell{i,j} )
                %nothing
            elseif isnumeric( iNestedCell{i,j} )
                str = num2str( iNestedCell{i,j} );
                if ~isscalar(iNestedCell{i,j}) && p.Results.QuoteString
                    str = strcat('"', str,'"');  %protect with double-quote
                end
                oFlattenCell{i,j} = str;
            elseif iscellstr( iNestedCell{i,j} )
                str = flattencellstr( iNestedCell{i,j} );
                N = length(str);
                if N > maxStringLength
                    str = [str(1:min(n, maxStringLength-50)), ' ...[truncated]'];
                    warning('Some cell contents were truncated to %d characters for Excell compatiability\nPlease, export to .csv or .mat for full export', maxStringLength);
                end
                
                if p.Results.QuoteString
                    str = strcat('"', strrep(str,'"','""') ,'"');  %protect with double-quote
                end
                oFlattenCell{i,j} = str;
            elseif iscell(iNestedCell{i,j})
                error('Only 1-level nested cells of string are allowed. Please ensure that elements in the cell are strings');
            end
        end
    end     
end

function str = flattencellstr( icellstr )
    str = '';
    if isempty(icellstr), return; end
    
    [m] = size(icellstr,1);
    str = strjoin( icellstr(1,:), ' # ' );
    for i=2:m
        str = sprintf('%s\n%s', str, strjoin( icellstr(i,:), ' # '));
        %n = length(str);
        %str = str(1: min(30000,n));
    end
end