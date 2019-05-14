%"""
%biotracs.core.utils.getfield
%Get a field value in s struct 
%* `iStruct` in which to search for
%* `iSearchedField` to look for
%* `iDefaultValueValue` to return if the field does not exist
%* Return the value of the field or the default value if it does not exists
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%"""

function oValue = getfield( iStruct, iSearchedField, iDefaultValue )
    if isa(iStruct,'struct')
        if isfield(iStruct, iSearchedField)
            oValue = iStruct.(iSearchedField);
        elseif nargin == 3
            oValue = iDefaultValue;
        else
            error('The field does not exist in the struture')
        end
    else
        error('Wrong argument, only structures can be parsed')
    end
end