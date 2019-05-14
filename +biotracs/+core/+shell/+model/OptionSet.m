%"""
%biotracs.core.model.shell.OptionSet
%Defines the OptionSet object that is a collection of shell options used to build shell commands
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.model.shell.Shell, biotracs.core.model.shell.Option
%"""

classdef OptionSet < biotracs.core.container.Set
    properties
        config;
    end
    
    methods
        
        function this = OptionSet( iShellConfig )
            this@biotracs.core.container.Set(0, 'biotracs.core.shell.model.Option');
            if ~isa( iShellConfig, 'biotracs.core.shell.model.ShellConfig' )
                error('A biotracs.core.shell.model.ShellConfig is required');
            end
            this.config = iShellConfig;
        end
       
        function oStr = formatAsString( this, varargin )
            oStr = '';
            optStruct = this.formatAsStruct( varargin{:} );
            names = fieldnames(optStruct);
            for i=1:length(names)
                oStr = [oStr, ' ', optStruct.(names{i}).command];
            end
            oStr = strtrim(oStr);
        end

        function oOptStruct = formatAsStruct( this, varargin )
            p = inputParser();
            p.addParameter('OptionsToUse', {}, @iscellstr);
            p.parse( varargin{:} );
                        
            specNames = this.getElementNames();
            n = this.getLength();
            oOptStruct = struct();
            for i=1:n
                specName = specNames{i};
                hasToSkipOption = ~isempty(p.Results.OptionsToUse) && ~any(ismember( p.Results.OptionsToUse, specName ));
                if hasToSkipOption, continue; end
                
                optionValue = this.config.getParamValue(specName);
                if ~isempty(optionValue)
                    option = this.get(specName);
                    oOptStruct.(specName).name = option.getName();
                    oOptStruct.(specName).value = option.formatValueAsString(optionValue);
                    oOptStruct.(specName).command = option.formatAsString(optionValue);
                else
                    option = this.get(specName);
                    oOptStruct.(specName).name = option.getName();
                    oOptStruct.(specName).value = option.formatValueAsString('');
                    oOptStruct.(specName).command = option.formatAsString('');
                end
            end
        end
    end
    
end

