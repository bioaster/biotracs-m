%"""
%biotracs.core.utils.isuuid
%Test that s string is a universal unique identifier
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2018
%"""

function tf = isuuid( str )
    tf = ~isempty(regexp(str, '^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$', 'once'));
end