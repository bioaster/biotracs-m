%"""
%biotracs.core.utils.regularizepath
%Regularize a file/folder path. Depreacated: use MATLAB `fullfile` function instead
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%"""

function path = regularizepath( iPath )
    path = regexprep(iPath, '(/|\\)+', filesep);
    path = regexprep(path, '(/|\\)+', filesep);
end