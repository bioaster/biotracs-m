function [ hash ] = sha1( str )
    opt.Method = 'SHA-1';
    hash = datahash.DataHash( str, opt );
end

