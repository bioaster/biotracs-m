function tf = isQuoted( str )
    if ~ischar(str)
        error('A string is required');
    end
    endsWithQuotes = ~isempty(regexp(str, '"\s*$', 'once'));
    beginsWithQuotes = ~isempty(regexp(str, '^\s*"', 'once'));
    tf = beginsWithQuotes && endsWithQuotes;
end
