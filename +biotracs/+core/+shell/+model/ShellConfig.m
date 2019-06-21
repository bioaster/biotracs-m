%"""
%biotracs.core.model.shell.ShellConfig
%Defines the configuration of the Shell object.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.model.shell.Shell, biotracs.core.model.shell.Option, biotracs.core.model.shell.OptionSet
%"""

classdef ShellConfig < biotracs.core.mvc.model.ProcessConfig
    
    properties
        optionSet;
        configFileExtension = '.xml';
    end
    
    methods
        
        function this = ShellConfig( )
            this@biotracs.core.mvc.model.ProcessConfig();
            this.createParam('InputFilePath', '', 'Access', biotracs.core.mvc.model.Parameter.PRIVATE_ACCESS, 'Constraint', biotracs.core.constraint.IsInputPath());
            this.createParam('OutputFilePath', '', 'Access', biotracs.core.mvc.model.Parameter.PRIVATE_ACCESS, 'Constraint', biotracs.core.constraint.IsOutputPath());
            this.createParam('ExecutableFilePath', '', 'Access', biotracs.core.mvc.model.Parameter.PROTECTED_ACCESS, 'Constraint', biotracs.core.constraint.IsInputPath());
            this.createParam('UseShellConfigFile', false, 'Constraint', biotracs.core.constraint.IsBoolean());
            this.createParam('ShellConfigFilePath', '', 'Access', biotracs.core.mvc.model.Parameter.PRIVATE_ACCESS, 'Constraint', biotracs.core.constraint.IsOutputPath());
			this.createParam('OutputFileExtension', '', 'Access', biotracs.core.mvc.model.Parameter.PUBLIC_ACCESS, 'Constraint', biotracs.core.constraint.IsFileExtension(), 'Description', 'The extension of the output files. Default: empty string. Use key words ?inherit? to inherite extension from the input file(s).');
            this.createParam('SkipWhenInputFileDoesNotExist', false, 'Constraint', biotracs.core.constraint.IsBoolean());
            this.optionSet = biotracs.core.shell.model.OptionSet( this );
        end
             
        %-- E --
        
%         function exportParams(this, iFilePath, varargin)
%             p = inputParser();
%             p.addParameter('Mode', 'default', @(x)(ischar(x) && any(strcmpi({'shell','default'},x))));
%             p.KeepUnmatched = true;
%             p.parse( varargin{:} );
%             switch lower(p.Results.Mode)
%                 case {'shell'}
%                     this.doExportShellParams(iFilePath, varargin{:});
%                 otherwise
%                     this.exportParams@biotracs.core.mvc.model.ProcessConfig(iFilePath, varargin{:});
%             end
%         end
        
        %-- F --
        
        function oStr = formatOptionsAsString( this, varargin )
            oStr = this.optionSet.formatAsString( varargin{:} );            
        end

        function oStruct = formatOptionsAsStruct( this, varargin )
            oStruct = this.optionSet.formatAsStruct( varargin{:} );
        end

        %-- G --
        
        function [ txtStr ] = getParamsAsText( this, varargin )
            p = inputParser();
            p.addParameter('Mode', 'Default', @(x)(ischar(x) && any(strcmpi({'Shell','Default'},x))));
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            switch lower(p.Results.Mode)
                case {'shell'}
                    [ txtStr ] = this.getShellParamsAsText( varargin{:}  );
                otherwise
                    [ txtStr ] = this.getParamsAsText@biotracs.core.mvc.model.ProcessConfig( varargin{:} );
            end
        end
        
        function [ docNode, paramNode ] = getParamsAsXml( this, varargin )
            p = inputParser();
            p.addParameter('Mode', 'Default', @(x)(ischar(x) && any(strcmpi({'Shell','Default'},x))));
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            switch lower(p.Results.Mode)
                case {'shell'}
                    [ docNode, paramNode ] = this.getShellParamsAsXml( varargin{:}  );
                otherwise
                    [ docNode, paramNode ] = this.getParamsAsXml@biotracs.core.mvc.model.ProcessConfig();
            end
        end
        
        % To overload if required
        function [ txtStr ] = getShellParamsAsText( varargin )
            error('Not implemented for this class');
        end
        
        % To overload if required
        function [ docNode, paramNode ] = getShellParamsAsXml( varargin )
            error('Not implemented for this class');
        end
        
    end
    
    methods(Access = protected)
        
        %> @param[in] iRange 2Array
        %> @param[in] iSep Separator, e.g.: space, ',', '-', ...
        %> @param[in] iEncapsulators Encapsulators, e.g. {'[', ']'}
        %> @return Formated string, e.g.: formatRange([1,10],'-',{'[',']'}) = '[1-10]'
        function strRange = doFormatRange( ~, iRange, iSep, iEncapsulators )
             if nargin < 3, iSep = ' '; end
             if nargin < 4, iEncapsulators = {'',''}; end
             if iscolomun(iRange), iRange = iRange'; end
             if length(iRange) ~= 2, error('Range must be an interval'); end
             strRange = regexprep(num2str(iRange),'\s+',iSep);
             strRange = sprintf('%s%s%s',iEncapsulators{1}, strRange, iEncapsulators{2});
         end
         
         %> @param[in] iValue True of False
         %> @return 'true' if @a iValue is true or 'false' otherwise
         function str = doFormatBoolean( ~, iValue )
             if iValue
                 str = 'true';
             else
                 str = 'false';
             end
         end
         
         
         function doExportShellParams(~,~)
         end
         
    end
    
end

