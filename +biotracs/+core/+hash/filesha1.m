function [ hash ] = filesha1( str )
    opt.Method = 'SHA-1';
    opt.Input = 'file';
    hash = datahash.DataHash( str, opt );
end

