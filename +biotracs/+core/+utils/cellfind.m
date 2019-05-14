%"""
%biotracs.core.utils.cellfind
%Find a value in a cell and return its indexes in an array
%* Inputs
%** `iCell` in which to search for
%** `iSearchedValue` to look for
%** `iFirst` If equal to 'first', only first index is returned
%* Outputs
%** returns The index(es) of `iSearchedValue` in `iCell` if it is found, [] otherwise.  
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%"""
        
function indexes = cellfind( iCell, iSearchedValue, iFirst )
    if ~isa( iCell, 'cell' )
        error('Invalid argument, a cell is required');
    end
    if nargin == 3 && strcmp(iFirst, 'first')
        iFirst = true;
    else
        iFirst = false;
    end
    n = length(iCell);
    indexes = [];
    for i=1:n
        isFound =   ( isnumeric(iCell{i}) && isequal(iCell{i}, iSearchedValue) ) || ...
                    ( isa(iCell{i}, 'cell') && isequal(iCell{i}, iSearchedValue) ) || ...
                    ( isa(iCell{i}, 'char') && ~isempty(regexpi(iCell{i}, ['^',iSearchedValue,'$'], 'once')) );

        if isFound
            indexes(end+1) = i;
            if iFirst, return; end
            %j = j + 1;
        end
    end
end
