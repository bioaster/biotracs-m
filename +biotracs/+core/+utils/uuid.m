%"""
%biotracs.core.utils.uuid
%Generate a random universal unique identifier (UUID)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%"""

function uuid = uuid( iLength )
    if nargin == 0
        uuid = char(java.util.UUID.randomUUID);
    else
        uuid = cell(1,iLength);
        for i = 1:iLength
            uuid{i} = char(java.util.UUID.randomUUID);
        end
    end
end