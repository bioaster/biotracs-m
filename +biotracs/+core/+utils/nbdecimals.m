%"""
%biotracs.core.utils.nbdecimals
%Compute the number of decimals of a number
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%"""

function ndec = nbdecimals( number )
    n = length(number);
    ndec = zeros(1,n);
    for i=1:n
        fixedNumber = abs(number(i) - fix(number(i)));
        ndec(i) = numel(num2str(fixedNumber)) - 2;
        if ndec(i) < 0, ndec(i) = 0; end;
    end
end
