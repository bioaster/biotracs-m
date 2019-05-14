%"""
%biotracs.core.utils.uncompress
%Uncompress .tar, .tar.gz (or .tgz), .zip files
%* `iFile` path of the file/folder to uncompress
%* `iWorkingDir` directroy where to uncompress
%* `iFormat` tar|gz|zip|tar.gz|tgz
%* return The path of the uncompressed file/folder
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%"""

function outputFileNames = uncompress( iFile, iWorkingDir, iFormat )
    outputFileNames = '';
    [~,filename,fileext] = fileparts(iFile);
    
    if nargin <= 2
        if length(fileext) > 1
            iFormat = fileext(2:end);
        else
            error('Cannot determine file format');
        end
    end

    switch lower(iFormat)
        case {'tar.gz', 'tgz', 'gz'}
            outputFileNames = gunzip( iFile, iWorkingDir );
            [~,~,subext] = fileparts(filename);
            if strcmpi(subext, '.tar')
                outputFileNames = biotracs.core.utils.uncompress(outputFileNames{1}, iWorkingDir, 'tar');
            end
        case 'tar'
            outputFileNames = untar( iFile, iWorkingDir );
        case 'zip'
            outputFileNames = unzip( iFile, iWorkingDir );
        otherwise
            error( strcat('Format "', iFormat ,'" is not supported') );
    end
end