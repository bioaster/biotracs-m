%"""
%biotracs.core.ability.PropListable
%Base mixin class that allows converting the propeties of a class as a {key,
%value} structure easily printable as json for instance.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.mvc.model.Workflow, biotracs.core.mvc.model.Process
%"""

classdef (Abstract) PropListable < handle
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods

        function c = getPropertiesAsList( this, iRecursive )
            if nargin == 1, iRecursive = false; end
            c = this.doGetProperties( iRecursive, 'cell' );
        end
        
        function s = getPropertiesAsStruct( this, iRecursive )
            if nargin == 1, iRecursive = false; end
            s = this.doGetProperties( iRecursive, 'struct' );
        end
        
        function s = getPropertiesAsJson( this, iRecursive )
            if nargin == 1, iRecursive = false; end
            s = this.doGetProperties( iRecursive, 'struct' );
            s = jsonencode(s);
        end
        
    end

    
    methods(Access = protected)
        
       function c = doGetProperties( this, iRecursive, iFormat )
            if nargin <= 1, iRecursive = false; end
            if nargin <= 2, iFormat = 'cell'; end
            
            p = properties(this);
            
            if strcmp(iFormat,'cell')
                c = cell(0,2);
            else
                c = struct();
            end
            
            for i = 1:length(p)
                propName = p{i};
                propVal = this.(p{i});
                
                if iRecursive
                    if iscell(propVal)
                        sz = size(propVal);
                        val = cell(sz);
                        for j = 1:sz(1)
                            for k = 1:sz(2)
                                if isa(propVal{j,k}, 'biotracs.core.ability.PropListable')
                                    val{j,k} = propVal{j,k}.doGetProperties( iRecursive, iFormat );
                                else
                                    val{j,k} = propVal{j,k};
                                end
                            end
                        end                        
                    elseif isa(propVal, 'biotracs.core.ability.PropListable')
                        val = propVal.doGetProperties( iRecursive, iFormat );
                    else
                        val = propVal;
                    end
                else
                    val = propVal;
                end
                
                
                if isa(val, 'function_handle')
                    val = func2str(val);
                end
                    
                %set value
                if strcmp(iFormat,'cell')
                    c(i,:) = { propName, val };
                else
                    c.(propName) = val;
                end
                
            end
       end 
        
    end
end
