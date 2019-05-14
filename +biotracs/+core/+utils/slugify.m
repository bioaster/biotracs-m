function [ str ] = slugify( str )
    if ~ischar(str)
        error('BIOTRACS:Slugify:InvalidArgument', 'A string is required');
    end
    str = regexprep(str, '[^\w]', '-');
end

