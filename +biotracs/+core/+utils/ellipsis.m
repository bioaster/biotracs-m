function str = ellipsis( str, maxlength)
    if length(str) > maxlength
        str = [ str(1:maxlength), '...' ];
    end
end

