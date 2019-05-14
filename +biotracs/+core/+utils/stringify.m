function [ str ] = stringify( val )

    if ischar( val )
        str = val;
    elseif isnumeric( val )
        if isempty(val) 
            str = '[]'; 
            return 
        end
        
        if isscalar(val)
            str = num2str(val);
        else
            str = '';
            sz = size(val);
            for i=1:sz(1)
                s = sprintf('%g,',val(i,:));
                s(end) = [];
                if isempty(str)
                    str = s;
                else
                    str = strcat(str,';',s);
                end
            end
            str = strcat('[', str, ']');
        end
    elseif islogical( val )
        if val
            str = 'true';
        else
            str = 'false';
        end
    elseif iscell( val )
        if isempty(val) 
            str = '{}'; 
            return
        end
        
        str = '';
        sz = size(val);
        for i=1:sz(1)
            c = cell(1,sz(2));
            for j=1:sz(2)
                c{j} = biotracs.core.utils.stringify(val{i,j});
            end
            if isempty(str)
                str = strjoin(c, ',');
            else
                strjoin(c, ',')
                str = strcat(str, ';', strjoin(c, ',') );
            end
        end
        str = strcat('{', str, '}');
    elseif isa(val, 'function_handle')
        str = func2str(val);
    else
        str = class(val);
    end

end

