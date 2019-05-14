function [ result ] = isfolder( dirpath )
    result = exist(dirpath,'dir') == 7;
end

