%"""
%biotracs.core.model.shell.Option
%Sell options used to build shell commands
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.model.shell.Shell, biotracs.core.model.shell.OptionSet
%"""

classdef Option < handle
    
    properties(SetAccess = protected)
        spec = '';
        formatFunction;
        removeConditionValue;
        protectValueWithQuotes = false;
    end
    
    methods
        
        function this = Option( iSpec, varargin )
            this@handle();            
            if ~isempty(iSpec) && ~ischar(iSpec)
                error('Option spec must be a string')
            end
            
            p = inputParser();
            p.addParameter('FormatFunction', [], @(x)(isa(x,'function_handle')));
            p.addParameter('RemoveWhenMatch', []);
            p.addParameter('ProtectValueWithQuotes', false);
            p.parse( varargin{:} );
            this.formatFunction  = p.Results.FormatFunction;
            this.removeConditionValue = p.Results.RemoveWhenMatch;
            this.protectValueWithQuotes = p.Results.ProtectValueWithQuotes;
            
            this.spec = iSpec;
        end
        
        %> Apply the spec to format a shell option with a given value
        %> if spec = '-out "%s"' and value = 'text', the returned string is '-out "text"'
        %> if spec = '--out "%f"' and value = 1.2, the returned string is '--out "1.2"'
        function oStr = formatAsString( this, iValue )
            if isequal(iValue,this.removeConditionValue)
                oStr = ''; return;
            end

            if isempty(this.formatFunction)
                val = iValue;
            else
                val = this.formatFunction(iValue);
            end

            if ischar(val)
                isQuoted = biotracs.core.utils.isQuoted(val);
                
                hasToRemoveExtraQuotes = isQuoted && this.protectValueWithQuotes;
                if hasToRemoveExtraQuotes
                    val = regexprep(val, '^\s*"(.*)"\s*$','$1');
                end
            end
            
            if this.protectValueWithQuotes
                properSpec = regexprep(this.spec, '([^"]*)"?(%(\d+(\.\d+)?)?[a-zA-Z])"?([^"]*)', '$1"$2"$3');
            else
                properSpec = this.spec;
            end
            
            oStr = sprintf( properSpec, val );
        end
        
        %> Use the spec to format a value
        %> if spec = '-out "%f"' and value = 1.23, the returned string is string '1.23'
        %> if spec = '--out "%1.1f"' and value = 1.23, the returned string is '1.2'
        function oStr = formatValueAsString( this, iValue )
            %tab = regexp(this.spec, '(%(\d+(\.\d+)?)?[a-zA-Z])', 'tokens');
            pattern = regexprep(this.spec, '.*(%(\d+(\.\d+)?)?[a-zA-Z]).*', '$1');
            if isempty(this.formatFunction)
                oStr = sprintf( pattern, iValue );
            else
                oStr = sprintf( pattern, this.formatFunction(iValue) );
            end
        end

        %-- G --
        
        %> Parser @a spec and return the name of the option
        %> if spec = '-out "text"', the name of the option will be 'out'
        %> if spec = '--out "text"', the name of the option will be 'out'
        function oName = getName( this )
            oName = regexprep( this.spec, '\-+([^\s]*)\s+.*', '$1' );
        end
        
%         %> Parser @a spec and return the name of the option
%         %> if spec = '-out "text"', the name of the option will be 'out'
%         %> if spec = '--out "text"', the name of the option will be 'out'
%         function oName = getValuePattern( this )
%             oName = regexprep( this.spec, '\-+([^\s]*)\s+.*', '$1' );
%         end
        
    end
    
    
    methods(Static)

    end
end

