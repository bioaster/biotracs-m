%"""
%biotracs.core.utils.optgrid
% Compute the optimal grid [n x m] in which a given number of elements N can be put. n and m are the closed integers such as n x m = N.
%* `nbElements` the number of elements to put in the grid
%* return the grid dimensions
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%"""

function ogrid = optgrid( N )
    %compute grid
    dist = N-1; ogrid = [1, N];
    for i=1:N
        m = N/i;
        if abs(m-i) < dist
            ogrid = [m, i];
            dist = abs(m-i);
        end
    end
    
%     m = ogrid(1);
%     f = floor(m);
%     if f < m
%         ogrid(1) = f+1;
%     else
%         ogrid(1) = f;
%     end
    
    ogrid(1) = ceil(ogrid(1));
    ogrid = [ max(ogrid), min(ogrid) ];
end
