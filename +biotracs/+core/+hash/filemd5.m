function [ hash ] = filemd5( str )
	Opt.Input = 'file';
    hash = datahash.DataHash( str, opt );
end