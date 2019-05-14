%"""
%biotracs.core.docu.view.Docu
%Documentation view.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.docu.model.Docu
%"""

classdef Docu < biotracs.core.mvc.view.Resource
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
		htmlDoc = biotracs.core.html.Doc.empty()
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Docu( )
            this@biotracs.core.mvc.view.Resource();
        end
        
        
        %-- R --
        
        function oHtmlDoc = renderHtml( this, varargin )
            p = inputParser();
			p.addParameter('WorkingDirectory', '', @ischar)
			p.parse(varargin{:});
            
            model = this.model;
            oHtmlDoc = biotracs.core.html.Doc();
            
            % title
            oHtmlDoc.setTitle(['Documentation - ', model.meta.className]);
            oHtmlDoc.setBodyTitle(model.meta.className);
            oHtmlDoc.setDescription(['Documentation for class ', model.meta.className]);
            oHtmlDoc.setKeywords([biotracs.core.env.Env.name(),', Documentation, ', model.meta.className, ' class']);
            
            h = biotracs.core.html.Heading(1, model.getClassNameParts('head'));
            oHtmlDoc.appendBookmark( biotracs.core.html.Bookmark.fromHeading(h) );
            oHtmlDoc.append(h);
            oHtmlDoc.appendItalic(model.meta.className);
            if this.model.meta.isAbstract
                oHtmlDoc.appendSpace();
                oHtmlDoc.appendBadge('Abstract').setStyle('dark');
            end
            oHtmlDoc.appendText('&nbsp;&nbsp;');
            oHtmlDoc.appendLink('#code-source-section', '<code>[Source]</code>');
            oHtmlDoc.appendLine();
            
            % markdown
            markdownTab = this.doExtractCodeMarkdown();
            if isempty(markdownTab)
                div = biotracs.core.html.Div();
            else
                div = biotracs.core.html.Div( markdownTab{1} );
            end
            div.addClass('markdown');
            oHtmlDoc.append(div);
            oHtmlDoc.appendLine();
            
            
            if ~model.isUnitTestClass()             
                % inheritance
                h = biotracs.core.html.Heading(2,'Inheritance');
                oHtmlDoc.appendBookmark( biotracs.core.html.Bookmark.fromHeading(h) );
                oHtmlDoc.append(h);
                grid = biotracs.core.html.Grid(1,2);
                grid.getAt(1,1)...
                    .setText('Super classes')...
                    .setAttributes(struct('class','col col-auto'));
                if isempty(model.meta.superClassNames)
                    div = biotracs.core.html.Div('<code>None</code>');
                else
                    div = biotracs.core.html.Div();
                    superClass = sort(unique(model.meta.superClassNames));
                    for i=1:length(superClass)
                        %div.appendCode( superClass{i} );
                        isDirectSuperClass = ismember(superClass{i}, model.meta.directSuperClassNames);
                        isHandle = ismember(superClass{i}, 'handle');
                        if isDirectSuperClass
                            div.appendCode( superClass{i} );
                            div.appendSpace();
                            div.appendBadge('MOTHER').setStyle(biotracs.core.html.Badge.STYLE_SUCCESS);
                            div.appendLineBreak();
                        elseif isHandle
                            div.appendCode( superClass{i} );
                            div.appendSpace();
                            div.appendBadge('MATLAB').setStyle(biotracs.core.html.Badge.STYLE_WARNING);
                            div.appendLineBreak();
                        elseif ~model.isUnitTestClass()
                            code = biotracs.core.html.Code(['<span class="link" data-href="',superClass{i},'.html">',superClass{i},'</span>']);
                            div.append( code );
                            div.appendLineBreak();
                        end
                    end
                end
                grid.getAt(1,2)...
                    .append(div);
                oHtmlDoc.append(grid);
                oHtmlDoc.appendLine();
                
                % configuration
                this.doRenderAndAppendHtmlOfConfiguration( oHtmlDoc );

                % param lists
                this.doRenderAndAppendHtmlOfParameters( oHtmlDoc );
                
                % property lists
                oHtmlDoc.appendParagraphBreak();
                this.doRenderAndAppendHtmlOfProperties( oHtmlDoc );
                
                % method lists
                oHtmlDoc.appendParagraphBreak();
                h = biotracs.core.html.Heading(2,'Methods');
                oHtmlDoc.appendBookmark( biotracs.core.html.Bookmark.fromHeading(h) );
                oHtmlDoc.append(h);
                oHtmlDoc.appendLine();
                
                this.doRenderAndAppendHtmlOfMethods( oHtmlDoc, 'Public' );
                oHtmlDoc.appendParagraphBreak();
                this.doRenderAndAppendHtmlOfMethods( oHtmlDoc, 'Protected' );
                oHtmlDoc.appendParagraphBreak();
                this.doRenderAndAppendHtmlOfMethods( oHtmlDoc, 'Private' );
                oHtmlDoc.appendParagraphBreak();
            end
            
            % source code
            oHtmlDoc.appendText('<span id="code-source-section"></span>');
            this.doRenderAndAppendHtmlOfSourceCode( oHtmlDoc );
            
            % generate and view html
			if ~this.model.getProcess().isNil() && isempty( p.Results.WorkingDirectory )
				wd = this.model.getProcess()...
					.getConfig()...
					.getParamValue('WorkingDirectory');
			else
				wd = fullfile(p.Results.WorkingDirectory);
			end
			
			if isempty(wd)
				wd = biotracs.core.env.Env.tempFolderPath();
			end
		
			if ~isfolder(wd) && ~mkdir(wd)
				error('BIOTRACS:Docu:DiskAccessRestriction', 'The working dorectory does not exist and cannot be created. Please check disk access rights');
			end
            
            oHtmlDoc.setBaseDirectory( wd );
            oHtmlDoc.setFileName( model.meta.className );
			oHtmlDoc.generateHtml();
			this.htmlDoc = oHtmlDoc;
        end
        
        %-- V --
        
        function this = viewHtml( this, varargin )
			if ~isempty(this.htmlDoc)
				this.renderHtml( varargin{:} );
			end
            this.htmlDoc.show('-browser');
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function link = doRenderHtmlOfClassLink( ~, iClassName, iText )
            href = [iClassName,'.html'];
            if nargin < 4
                iText = iClassName;
            end
            link = biotracs.core.html.Link(href, iText);
        end
        
        function link = doRenderHtmlOfMethodLink( ~, iClassName, iMethodName, iText )
            href = [iClassName,'.html#', iMethodName];
            if nargin < 5
                iText = iMethodName;
            end
            link = biotracs.core.html.Link(href, iText);
        end
        
        function doRenderAndAppendHtmlOfConfiguration( this, iHtmlDoc )
            isConfigurable = ismember('biotracs.core.ability.Configurable', this.model.meta.superClassNames);
            if ~isConfigurable
                return;
            end

            h = biotracs.core.html.Heading(2,'Configuration');
            iHtmlDoc.append( biotracs.core.html.Bookmark.fromHeading(h) );
            iHtmlDoc.append(h);
            iHtmlDoc.appendLine();
            
            div = biotracs.core.html.Div();
            configClassName = this.model.getConfigrationClass();
            if this.model.meta.isAbstract
                if isempty(configClassName)   
                    div.appendSpan( 'Abstract class with no default configuration class' );
                else 
                    div.appendSpan('Configuration ');
                    div.appendLink( [configClassName, '.html'], ['<code>',configClassName,'</code>'] );
                    if strcmp(configClassName, [this.model.meta.className, 'Config'])
                        div.appendLineBreak();
                        div.appendNotice('This configuration is dynamically loaded by the system when the object is created. It may not be part of the the specifications of this class (see <code>paramData</code> property)')...
                            .setStyle('info');
                    end
                end  
            else
                div.appendSpan('Configuration ');
                div.appendLink( [configClassName, '.html'], ['<code>',configClassName,'</code>'] );
                if strcmp(configClassName, [this.model.meta.className, 'Config'])
                    div.appendLineBreak();
                    div.appendNotice('This configuration is dynamically loaded by the system when the object is created. It may not be part of the the specifications of this class (see <code>paramData</code> property)')...
                        .setStyle('info');
                end
            end
            iHtmlDoc.appendDiv(div);
            iHtmlDoc.appendParagraphBreak();
        end
        
        function doRenderAndAppendHtmlOfParameters( this, iHtmlDoc )
            isParametrable = ismember('biotracs.core.ability.Parametrable', this.model.meta.superClassNames);
            if ~isParametrable
                return;
            end
            
            [params] = this.model.getParameterList();
            
            h = biotracs.core.html.Heading(2,'Parameters');
            iHtmlDoc.append( biotracs.core.html.Bookmark.fromHeading(h) );
            iHtmlDoc.append(h);
            iHtmlDoc.appendLine();

            if isempty(params)
                iHtmlDoc.appendDiv('No parameters defined (see also <code>paramData</code> property)');
            else
                accordion = doRenderAccordionOfParam( this, params, '<code>Parameters (Defined by paramData property)</code>' );
                iHtmlDoc.append(accordion);
            end
        end
        
        function accordion = doRenderAccordionOfParam( this, params, name )
            identSpace = 2;
            accordion = biotracs.core.html.Accordion();
            accordion.removeClass('accordion-bar')...
                    .addClass('accordion-plus');
            item = biotracs.core.html.AccordionItem(name);
                    
            keys = fieldnames(params);
            for i=1:length(keys)
                key = keys{i};
                val = params.(key);
                
                if isstruct(val)
                    %subAccordion = biotracs.core.html.Accordion();
                    %subItem = biotracs.core.html.AccordionItem(key);
                    div = biotracs.core.html.Div();
                    div.append( this.doRenderAccordionOfParam(val, key) );
                    div.addClass('code');
                    div.addAttributes( struct('style',['margin-left: ',num2str(identSpace),'rem']) );
                    %subItem.append(div);
                    %subAccordion.append(subItem);
                    item.append(div);
                else
                    val = biotracs.core.utils.stringify(val);
                    html = [key,': ' val];
                    code = biotracs.core.html.Code(html);
                    code.addAttributes( struct('style',['margin-left: ',num2str(identSpace),'rem']) );
                    item.append(code);
                    item.appendLineBreak();
                end
                                
            end
                        
            accordion.append(item);
        end
        
        function doRenderAndAppendHtmlOfProperties( this, iHtmlDoc )
            propertyList = this.model.getPropertyList();
            
            h = biotracs.core.html.Heading(2,'Properties');
            iHtmlDoc.append( biotracs.core.html.Bookmark.fromHeading(h) );
            iHtmlDoc.append(h);
            iHtmlDoc.appendLine();
            if isempty(propertyList)
                return;
            end

            currentClassName = this.model.meta.className;
            superClassNames = arrayfun( @(x)(x.DefiningClass.Name), propertyList, 'UniformOutput', false );
            isInherited = arrayfun( @(x)(~strcmpi(x, currentClassName)), superClassNames );
            
            % write non-inherited propeties
            card = biotracs.core.html.Card();
            card.setHeader('<code class="text-secondary">Non inherited</code>');
            idx = find(~isInherited);
            for i = 1:length(idx)
                j = idx(i);
                acc = myWriteHtmlOfProperty(j);
                card.append(acc);
            end
            iHtmlDoc.append(card);
            iHtmlDoc.appendLineBreak();
            
            % write inherited properties
            idx = find(isInherited);
            [~, sortIdx] = sort(superClassNames(idx));
            currentSuperClassName = '';
            for i = 1:length(idx)
                j = idx(sortIdx(i));
                isNewParent = ~strcmpi(currentSuperClassName, superClassNames{j});
                if isNewParent
                    currentSuperClassName = superClassNames{j};
                    card = biotracs.core.html.Card();
                    card.setHeader(['<code class="text-secondary">Inherited from <a href="',currentSuperClassName,'.html">',currentSuperClassName,'</a></code>']);
                    iHtmlDoc.append(card);
                    iHtmlDoc.appendLineBreak();
                end
                acc = myWriteHtmlOfProperty(j);
                card.append(acc);
            end
            
            function accordion = myWriteHtmlOfProperty( i )
                accordion = biotracs.core.html.Accordion();
                accordion.addClass('accordion-none');
                accordion.removeClass('accordion-bar');
                
                prop = propertyList(i);
                item = biotracs.core.html.AccordionItem( ['<code>',prop.Name,'</code>'] );
                if prop.HasDefault
                    defaultVal = biotracs.core.utils.stringify(prop.DefaultValue);
                else
                    defaultVal = 'none';
                end
                item.setText([...
                    '<ul>',...
                    '<li><code>DefaultValue: ', defaultVal, '</code></li>',...
                    '<li><code>GetAccess: ',biotracs.core.utils.stringify(prop.GetAccess), '</code></li>',...
                    '<li><code>SetAccess: ',biotracs.core.utils.stringify(prop.SetAccess), '</code></li>',...
                    '</ul>',...
                    ]);
                accordion.append(item);
            end
        end
        
        function doRenderAndAppendHtmlOfMethods( this, iHtmlDoc, iAccess )
            methodList = this.model.getMethodList( lower(iAccess) );
            
            h = biotracs.core.html.Heading(3, [iAccess, ' methods']);
            iHtmlDoc.append( biotracs.core.html.Bookmark.fromHeading(h) );
            iHtmlDoc.append(h);
            iHtmlDoc.appendLine();
            if isempty(methodList)
                iHtmlDoc.appendDiv( 'No methods defined' );
                return;
            end
            lastSuperClass = '';
            n = length( methodList );
            for i=1:n
                method = methodList(i);
                currentSuperClass = method.DefiningClass.Name;
                isNewSuperClass = ~strcmp(currentSuperClass, lastSuperClass);
                isInherited = ~strcmp(currentSuperClass, this.model.meta.className);
                if isNewSuperClass
                    card = biotracs.core.html.Card();
                    iHtmlDoc.append(card);
                    iHtmlDoc.appendVerticalSpace('8px');
                    iHtmlDoc.appendLineBreak();
                    if isInherited
                        card.setHeader(['<code class="text-secondary">Inherited from <a href="',currentSuperClass,'.html">',currentSuperClass,'</a></code>']);
                    else
                        card.setHeader('<code class="text-secondary">Methods</code>');
                    end
                    lastSuperClass = currentSuperClass;
                end
                methodSignature = [...
                    '<code class="d-block" style="margin-bottom: 3px">', ...
                    method.Name, ...
                    ' (',strjoin(method.InputNames,', '),')</code>'...
                    ];
                card.appendDiv( methodSignature );
            end
        end
        
        function doRenderAndAppendHtmlOfSourceCode( this, iHtmlDoc )
            h = biotracs.core.html.Heading(2,'Source code');
            iHtmlDoc.appendBookmark( biotracs.core.html.Bookmark.fromHeading(h) );
            iHtmlDoc.append(h);
            iHtmlDoc.appendLine();
            
%             if ~isempty(this.meta.licenseText)
%                 iHtmlDoc.appendDiv(this.meta.licenseText).addClass('license-text');
%             end
%             
%             if ~isempty(this.meta.licenseUrl)
%                 iHtmlDoc.appendLink(this.meta.licenseUrl)
%             end
            
            iHtmlDoc.appendLineBreak();
            accordion = biotracs.core.html.Accordion();
            item = biotracs.core.html.AccordionItem('<span class="badge badge-info">Show or Hide source code</span>');
            code = this.model.getSourceCode(true);
            card = biotracs.core.html.Card(['<div class="code-box">',code,'</div>']);
            item.append(card);
            accordion.append(item);
            iHtmlDoc.append(accordion);
        end
        
        function tab = doExtractCodeMarkdown( this )
            code = this.model.getSourceCode();
            tab = regexp(code, '%"""(.*)%?"""', 'match');
            tab = regexprep(tab, {'^(\s)*%', '"""'}, {'', ''}, 'lineanchors');
            tab = regexprep(tab, '(\n|\r\n)$', '');
        end
    end
    
end

