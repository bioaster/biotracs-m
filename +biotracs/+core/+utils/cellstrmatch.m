%"""
%biotracs.core.utils.cellfind
%Find a value in a cell and return its indexes in an array
%* Inputs
%** `iCell` in which to search for
%** `iSearchedValue` to look for
%** `iIsCaseSensitive` True for case-sensitive match, False otherwise
%* Outputs
%** return The index(es) of `iSearchedValue` in `iCell` if it is found, [] otherwise.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%"""
      
function indexes = cellstrmatch( iCell, iSearchedValue, iIsCaseSensitive, iFirst )
    indexes = [];
    if isempty(iCell), return; end 
    if nargin < 3, iIsCaseSensitive = true; end
    if nargin < 4, iFirst = false; end
    if ~iscell( iCell ), error('Invalid argument, a cellstr is required'); end
    
    if iIsCaseSensitive
        caseOption = 'matchcase';
    else
        caseOption = 'ignorecase';
    end
    
    
    matchIndexes = cellfun( @(x)regexp(x, iSearchedValue, 'once',  caseOption), iCell, 'UniformOutput', false);
    indexes = cellfun( @(x)(~isempty(x)), matchIndexes );
    
    if iFirst
        indexes = find( indexes == true, 1 );
    else
        indexes = find( indexes == true );
    end 
    
end
