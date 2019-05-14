%"""
%biotracs.core.docu.model.Docu
%Documentation model. Used to store BioTracs code source documentation.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.docu.view.Docu, biotracs.core.docu.model.DocuSet, biotracs.core.docu.model.DocuGenerator
%"""

classdef Docu < biotracs.core.mvc.model.Resource
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Docu( iFilePath, iMeta )
            this@biotracs.core.mvc.model.Resource();

            if nargin == 1
                [~, ~, ext] = fileparts(iFilePath);
                if ~strcmpi(ext, '.m') 
                    error('Only .m files are valid files for documentation');
                end
                namespace = biotracs.core.docu.model.Docu.parseNamespaceFromPath( iFilePath );
                iMeta = meta.class.fromName( namespace );

                if isempty(iMeta)
                    error('Cannot read class meta. Please ensure that the meta are provided or the filePath refer to a valid MATLAB class');
                end
            end
            
            this.meta.filePath                  = iFilePath;
            this.meta.className                 = iMeta.Name;
            this.meta.isAbstract                = iMeta.Abstract;
            this.meta.isSealed                  = iMeta.Sealed;
            this.meta.isHandle                  = iMeta.HandleCompatible;
            this.meta.description               = iMeta.Description;
            this.meta.methodList                = this.doSortMethodList( iMeta );
            this.meta.propertyList              = iMeta.PropertyList; %this.doSortPropertyList( iMeta );
            this.meta.eventList                 = this.doSortEventList( iMeta );
            this.meta.package                   = iMeta.ContainingPackage;
            this.meta.directSuperClassNames     = arrayfun(@(x)(x.Name), iMeta.SuperclassList, 'UniformOutput', false, 'ErrorHandler',@(x)([]));
            this.meta.superClassNames           = myGetSupClassesNames( iMeta );
            %this.meta.isUnitTestClass           = ismember('matlab.unittest.TestCase', this.meta.superClassNames);
            this.meta.unitTestFilePath          = '';
            
            %read file content
            fileID = -1;
            try
                fileID = fopen(iFilePath);
                A = fread(fileID,'*char')';
                fclose(fileID);
                this.meta.code = A;
            catch
                this.meta.code = 'Code source not parsed';
                if fileID > 0
                    fclose(fileID);
                end
            end
            
            function c = myGetSupClassesNames(x)
                c = arrayfun(@(y)(y.Name), x.SuperclassList, 'UniformOutput', false, 'ErrorHandler',@(y)([]));
                for i=1:length( c )
                    c = [ c; myGetSupClassesNames( x.SuperclassList(i) ) ];
                end
            end
            
            this.bindView( biotracs.core.docu.view.Docu() );
        end

        function parts = getClassNameParts( this, whichPart )
            if nargin == 1, whichPart = ''; end
            parts = strsplit(this.meta.className, '.' );
            switch whichPart
                case 'head'
                    parts = parts{end};
                case 'foot'
                    parts = parts{1};
                otherwise
            end    
        end

        function p = getEventList( this )
            p = this.meta.eventList;
        end
        
        function p = getPackage( this )
            p = this.meta.package;
        end
        
        function [params] = getParameterList( this )
            params = struct([]);
            isParametrable = ismember('biotracs.core.ability.Parametrable', this.meta.superClassNames);
            if ~this.meta.isAbstract && isParametrable
                o = feval( this.meta.className );
                params = o.getParamsAsStruct();
            end
        end
        
        function [ configClass ] = getConfigrationClass( this )
            configClass = '';
            isConfigurable = ismember('biotracs.core.ability.Configurable', this.meta.superClassNames);
            if ~isConfigurable
               return; 
            end
            
            if this.meta.isAbstract
                defaultConfigClass = [this.meta.className,'Config'];
                if exist( defaultConfigClass, 'class' ) == 8
                    configClass = defaultConfigClass;
                end
            else
                try
                    o = feval( this.meta.className );
                    configClass = o.getConfig().className;
                catch
                    
                end
            end
        end
        
        function p = getPropertyList( this, iAccess, iDefiningClassName )
            if nargin == 1
                p = this.meta.propertyList;
            elseif nargin == 2
                if isempty(iAccess), iAccess = '.*'; end
                idx = arrayfun( @(x)( ischar(x.Access) && regexp(x.Access,iAccess,'once') ), this.meta.methodList);
                p = this.meta.propertyList(idx);
            else
                if isempty(iAccess), iAccess = '.*'; end
                if isempty(iDefiningClassName), iDefiningClassName = '.*'; end
                idx = arrayfun( @(x)( ischar(x.Access) && regexp(x.Access,iAccess,'once') && any(regexp(x.DefiningClass.Name,iDefiningClassName,'once')) ), this.meta.methodList);
                p = this.meta.propertyList(idx);
            end
        end
        
        function m = getMethodList( this, iAccess, iDefiningClassName )
            if nargin == 1
                m = this.meta.methodList;
            elseif nargin == 2
                if isempty(iAccess), iAccess = '.*'; end
                idx = arrayfun( @(x)( ischar(x.Access) && strcmpi(x.Access,iAccess) ), this.meta.methodList);
                m = this.meta.methodList(idx);
            else
                if isempty(iAccess), iAccess = '.*'; end
                if isempty(iDefiningClassName), iDefiningClassName = '.*'; end
                idx = arrayfun( @(x)( ischar(x.Access) && regexp(x.Access,iAccess,'once') && any(regexp(x.DefiningClass.Name,iDefiningClassName, 'once')) ), this.meta.methodList);
                m = this.meta.methodList(idx);
            end
        end
        
        function s = getSuperClasses( this )
             s = this.meta.superClassNames;
        end
         
        function [c] = getSourceCode( this, iFormat )
            c = this.meta.code;
            if nargin == 2 && iFormat
                ar = {
                    ' ', '&nbsp;';
                    '\t', '&nbsp;&nbsp;&nbsp;';
                    '(%.*)', '<span class="code-comment">$1</span>';
                    '([^a-zA-Z0-9_])(methods|function|end|classdef|for|while|if|else|properties|events|switch|case|otherwise|break|continue|return|try|catch|global|persistent)([^a-zA-Z0-9_])', '$1<span class="code-keyword">$2</span>$3';
                    '(''[^''\r\n]*'')', '<span class="code-string">$1</span>';
                    };
                c = regexprep(c, ar(:,1), ar(:,2), 'lineanchors', 'dotexceptnewline');
                c = regexprep(c, '\n|\r\n', '<br>');
            end
        end
        
        %-- I --
        
        function [ tf ] = isUnitTestClass( this )
            tf = ismember('matlab.unittest.TestCase', this.meta.superClassNames);
        end
        
        function [ tf ] = isProcessConfigClass( this )
            tf = ismember('biotracs.core.mvc.model.ProcessConfig', this.meta.superClassNames);
        end
        
        function [ tf ] = isConfigurableClass( this )
            tf = ismember('biotracs.core.ability.Configurable', this.meta.superClassNames);
        end
        
        function [ tf ] = isParametrableClass( this )
            tf = ismember('biotracs.core.ability.Parametrable', this.meta.superClassNames);
        end
        
        %-- S --
        
        function setUnitTestFilePath( this, iFilePath )
            this.meta.unitTestFilePath = iFilePath;
        end
        
    end
    
    methods(Static)
        
        function namespace = parseNamespaceFromPath( iPath )
            tab = strsplit( fullfile(iPath), filesep );
            namespace = '';
            plusIsFound = false;
            for i=2:length(tab)
                token = tab{i};
                if strcmp(token(1), '+')
                    namespace = strcat(namespace,'.',token(2:end));
                    plusIsFound = true;
                else
                    if plusIsFound || i == length(tab)
                        namespace = strcat(namespace,'.',token);
                    end
                end
            end
            namespace = regexprep(namespace, '^(\.)|(\.m)$', '');
        end
        
    end
    
    methods(Access = protected)

        function sortedMethodList = doSortMethodList( this, meta )
            methodNames = arrayfun( @(x)(x.Name), meta.MethodList, 'UniformOutput', false );
            definingClasses = arrayfun( @(x)(x.DefiningClass.Name), meta.MethodList, 'UniformOutput', false );
            idx = strcmp(definingClasses, this.meta.className);
            definingClasses(idx) = {''};
            [~, idx] = sortrows( [methodNames, definingClasses], [2,1] );
            sortedMethodList = meta.MethodList(idx);
        end
        
        function sortedPropertyList = doSortPropertyList( ~, meta )
            propertyNames = arrayfun( @(x)(x.Name), meta.PropertyList, 'UniformOutput', false );
            [~, idx] = sort(propertyNames);
            sortedPropertyList = meta.PropertyList(idx);
        end
        
        function sortedEventList = doSortEventList( ~, meta )
            eventNames = arrayfun( @(x)(x.Name), meta.EventList, 'UniformOutput', false );
            [~, idx] = sort(eventNames);
            sortedEventList = meta.EventList(idx);
        end
        
    end
    
end

