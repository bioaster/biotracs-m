%"""
%biotracs.core.utils.formatLabelForPlot
%Format texts for plot labels. 
%* `iLabels` is a cell of string `{'key1:value11_key2:value12_key:3:value13_...', 'key1:value21_key2:value22_key:3:value23_...', ...}`
%* varargin: `LabelFormat` can be a regular expression or can be equal to `'long'` (default value)
%** If  `LabelFormat={'key2:([^_]*)'}`, contents in the brackets after `key2` strings will be captured (without the `_` character), i.e. the resulting labels will be `{'value12', 'value22', ...}`
%** If  `LabelFormat='long'` no formatting is applied
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%"""

function oLabels = formatLabelForPlot( iLabels, varargin )
    p = inputParser();
    p.addParameter('LabelFormat','long',@(x)(iscell(x) || ischar(x)));
    p.addParameter('NameSeparator','_', @ischar);
    p.addParameter('MaxLabelLength', Inf, @isnumeric);
    p.KeepUnmatched = true;
    p.parse(varargin{:});

    if ischar(iLabels)
        isChar = true;
        iLabels = { iLabels };
    elseif iscellstr(iLabels)
        isChar = false;
    else
        error('Invalid argument, a cellstr or a string is required');
    end

    if iscell(p.Results.LabelFormat)
        format = p.Results.LabelFormat{1};
    else
        format = p.Results.LabelFormat;
    end

    if strcmpi(format, 'groups')
        warning('Option ''groups'' is deprecated. Use ''pattern'' instead')
    end
    
    n = length(iLabels);
    oLabels = cell(1,n);
    for i=1:n
        if isempty(p.Results.LabelFormat)
            oLabels{i} = [ '  ', iLabels{i} ];
        elseif strcmpi(p.Results.LabelFormat, 'none')
            oLabels{i} = '';
        else
            useRetroCompatibility = iscell(p.Results.LabelFormat) ...
                && strcmp(p.Results.LabelFormat{1}, 'pattern') ...
                && iscellstr( p.Results.LabelFormat{2});
            
            if useRetroCompatibility
                pattern = p.Results.LabelFormat{2};
            elseif ischar(p.Results.LabelFormat)
                pattern = { p.Results.LabelFormat };
            elseif iscellstr( p.Results.LabelFormat )
                pattern = p.Results.LabelFormat;
            else
                error('Invalid LabelFormat');
            end
                
            if iscellstr(pattern)
                nbTokens = length(pattern);
                tokenList = repmat({''},1,nbTokens);
                for j=1:length(pattern)
                    tokenList{j} = regexprep(iLabels{i}, ['.*',pattern{j},'.*'], '$1');
                end
                oLabels{i} = '';
            elseif ischar(pattern)
                tab = regexp(iLabels{i}, pattern, 'tokens');
                oLabels{i} = '';
                nbTokens = length(tab{1});
                tokenList = repmat({''},1,nbTokens);
                for j=1:nbTokens
                    tokenList{j} = tab{1}{j};
                end
            else
                error('Invalid label format. The pattern must be a string');
            end
            
            oLabels{i} = strjoin(tokenList, '-');
        end
    end

    if isChar
        oLabels = oLabels{1};
    end

	oLabels = strrep(oLabels, '_', '-');
    n = p.Results.MaxLabelLength;
    if ~isempty(n) && ~isinf(n)
        oLabels = cellfun( @(x)(biotracs.core.utils.ellipsis(x,n)), oLabels, 'UniformOutput', false );
    end
end
