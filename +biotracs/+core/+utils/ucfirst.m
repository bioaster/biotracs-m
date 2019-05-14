%"""
%biotracs.core.utils.savefig
%Convert the first character of a string to uppercase
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%"""

function [ oStr ] = ucfirst( iStr )
    if ~ischar(iStr)
        error('Invalid argument, a string is required');
    end
    oStr = [ upper(iStr(1)), iStr(2:end) ];
end

