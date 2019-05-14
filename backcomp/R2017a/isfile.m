function [ result ] = isfile( filepath )
    if exist(filepath,'file')
        result = true;
    else
        result = false;
    end
end

