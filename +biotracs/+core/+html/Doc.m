%"""
%biotracs.core.html.Doc
%Dov object allows manipulating and creating html doc elements
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.core.html.Body, biotracs.core.html.DomContainer
%"""

classdef Doc < biotracs.core.html.DomContainer
    
    properties(SetAccess = protected)
        title       = '';       % Title of the html page (in the meta tag)
        bodyTitle   = '';       % Title to display in the page body
        description = '';       % Description of the page
        keywords    = '';       % Keywords of the page
        baseDirectory;          % Base directory of the page
        folderName;             % Folder nale of the page (optional)
        fileName;               % File name of the page without th extension (e.g. 'index').
    end
    
    properties(Access = protected)
        isOutputFileGenerated = false;
    end
    
    
    methods
        
        function this = Doc()
            this@biotracs.core.html.DomContainer();
            this.tagName = 'html';
        end
        
        %-- G --
        
        function oTitle = getTitle( this )
            oTitle = this.title;
        end
        
        function oDescription = getDescription( this )
            oDescription = this.description;
        end
        
        function oKeywords = getKeywords( this )
            oKeywords = this.keywords;
        end
        
        function oBodyTitle = getBodyTitle( this )
            oBodyTitle = this.bodyTitle;
        end
        
        function oDir = getBaseDirectory( this )
            oDir = this.baseDirectory;
        end
        
        function oName = getFileName( this )
            oName = this.fileName;
        end
        
        function oName = getFolderName( this )
            oName = this.folderName;
        end
        
        function oPath = getFilePath( this )
            oPath = fullfile(this.baseDirectory,this.folderName,[this.fileName,'.html']);
        end
        
        function oUrl = getLocalUrl( this )
            if isempty(this.folderName)
                folder = '';
            else
                folder = [this.folderName,'/'];
            end
            oUrl = ['./',folder,this.fileName,'.html'];
        end
        
        %-- S --

        function this = setTitle( this, iTitle )
            this.title = iTitle;
            if isempty(this.bodyTitle)
                this.bodyTitle = iTitle;
            end
        end
        
        function this = setDescription( this, iDescription )
            this.description = iDescription;
        end
        
        function this = setKeywords( this, iKeywords )
            this.keywords = iKeywords;
        end
        
        function this = setBodyTitle( this, iTitle )
            this.bodyTitle = iTitle;
            if isempty(this.title)
                this.title = iTitle;
            end
        end
        
        function this = setBaseDirectory( this, iDir )
            c = biotracs.core.constraint.IsPath();
            if ~c.isValid(iDir)
                error('BIOTRACS:Html:Doc:InvalidArgument', 'The directory is not valid');
            end
            iDir = fullfile(iDir);
            this.baseDirectory = iDir;
            
            for i=1:getLength(this.children)
                child = this.children.getAt(i);
                if isa( child, 'biotracs.core.html.Doc' )
                    child.setBaseDirectory( iDir );
                end
            end
        end
        
        function this = setFileName( this, iFileName )
            %c = biotracs.core.constraint.IsPath();
            %if ~c.isValid(iFileName)
            %    error('BIOTRACS:Html:Doc:InvalidArgument', 'The file name is not valid');
            %end
			this.fileName = iFileName;
            %[~, this.fileName, ~] = fileparts(iFileName);
        end
        
        function this = setFolderName( this, iFolderName )
            c = biotracs.core.constraint.IsPath();
            if ~c.isValid(iFolderName)
                error('BIOTRACS:Html:Doc:InvalidArgument', 'The folder name is not valid');
            end
            this.folderName = iFolderName;
        end
        
        function this = show( this, iOption )
            if ~this.isOutputFileGenerated
                if isempty( this.baseDirectory )
                    error('BIOTRACS:Html:Doc:BaseDirectoryUndefined', 'The output directory is not defined');
                end
                this.doGenerateHtml();
            end     
            if nargin == 1
                web( this.getFilePath(), '-browser' );
            else
                web( this.getFilePath(), iOption );
            end
        end
        
    end
    
    methods(Access = protected)
        
        function [ html ]= doWriteNavbar( this )
            html = [...
                    '<nav class="navbar navbar-light bg-light justify-content-between">', ...
                        '<samp class="navbar-brand" href="#">[',biotracs.core.env.Env.name(),']</samp>', ...
                        '<nav class="nav nav-pills">', ...
                        '  <form id="search-form" class="form-inline" action="https://google.com/search" method="get" target="_blank">', ...
                        '     <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search" name="q">', ...
                        '     <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>', ...
                        '  </form>', ...
                        '  <button id="slidebar-toggler" class="d-block navbar-toggler" type="button" style="margin-left: 50px">', ...
                        '    <span class="navbar-toggler-icon"></span>', ...
                        '  </button>', ...
                        '</nav>', ...
                    '</nav>', ...
                    '<script type="text/javascript">', ...
                    '  $("#search-form").submit(function(){', ...
                    '    var input = $(this).find("input");', ...
                    '    if(input.val() == ""){ return false; }; ', ...
                    '    input.val( "biotracs: " + input.val() ); ', ...
                    '    return true;', ...
                    '  })', ...
                    '</script>', ...
                    '<div class="container" style="margin-bottom: 0.5rem;">', ...
                        '<div style="font-size: 3rem; font-weight: 300; margin-top: 1rem; margin-bottom: 0.5rem;">', ...
                            this.bodyTitle, ...
                        '</div>', ...
                        '<div class="lead">',...
                            this.description,...
                         '</div>',...
                     '</div>', ...
                     '<hr><br>' ...
                  ];
        end
        
        function [ html ]= doWriteToc( this, iIsSlidebar )
            if nargin == 1 || iIsSlidebar
                id = 'slidebar-container';
                css = 'slidebar';
            else
                id = 'table-of-content';
                css = 'table-of-content d-none d-md-block d-lg-block d-xl-block';
            end
            html = [...
                    '<div id="',id,'" class="',css,' mCustomScrollbar" data-mcs-theme="dark-thick">', ...
                        '<div class="navbar-brand toc-title" href="#">Table of Contents</div>', ...
                        '<nav id="',this.uid,'-toc" class="navbar navbar-light bg-light">', ...
                            '<nav class="nav nav-pills flex-column" style="font-size:13px">', ...
                            '<a class="nav-link" style="margin-left:0rem" href="#slidebar-toggler">Top</a>' ...
                   ];
            for i=1:getLength( this.children )
                child = this.children.getAt(i);
                if isa(child, 'biotracs.core.html.Bookmark')
                    if child.level > 3,  continue; end
                    indent = num2str(child.level-1)/1.5;
                    html = strcat(html, '<a class="nav-link" style="margin-left:',indent,'rem" href="#',child.uid,'">',child.text,'</a>');
                end
            end
            html = [ html, ...
                            '</nav>', ...
                        '</nav>', ...
                    '</div>' ];
        end
        
        function [ head ]= doWriteHead( this )
            head = [...
                '<head>',...
                    '<title>',this.title,'</title>',...
                    '<meta charset="utf-8"/>',...
                    '<meta name="description" content="',strrep(this.description,'"',''''),'"/>', ...
                    '<meta name="keywords" content="',strrep(this.keywords,'"',''''),'"/>',...
                    '<script src="./assets/biotracs/lib/jquery-v3.2.1/jquery-3.2.1.min.js" type="text/javascript"></script>', ...
                    '<script src="./assets/biotracs/lib/jquery.touchSwipe.min.js" type="text/javascript"></script>', ...
                    '<script src="./assets/biotracs/lib/popper.min.js" type="text/javascript"></script>', ...
                    '<script src="./assets/biotracs/lib/bootstrap-v4.0/bootstrap.min.js" type="text/javascript"></script>', ...
                    '<script src="./assets/biotracs/lib/datatables.min.js" type="text/javascript"></script>', ...
                    '<script src="./assets/biotracs/lib/jquery.mCustomScrollbar.concat.min.js" type="text/javascript"></script>', ...
                    '<script src="./assets/biotracs/lib/d3.min.js" type="text/javascript"></script>', ...
                    '<script src="./assets/biotracs/lib/showdown-v2.0/showdown.min.js" type="text/javascript"></script>', ...
                    ...
                    '<link href="./assets/biotracs/lib/bootstrap-v4.0/bootstrap.min.css" rel="stylesheet" type="text/css"/>', ...
                    '<link href="./assets/biotracs/lib/datatables.min.css" rel="stylesheet" type="text/css"/>', ...
                    '<link href="./assets/biotracs/lib/jquery.mCustomScrollbar.min.css" rel="stylesheet" type="text/css"/>', ...
                    '<link href="./assets/biotracs/lib/highlight-v9.15.6/vs.css" rel="stylesheet" type="text/css"/>', ...
                    ...
                    '<script src="./assets/biotracs/js/slidebar.js" type="text/javascript"></script>', ...
                    '<script src="./assets/biotracs/js/biotracs.js" type="text/javascript"></script>', ...
                    '<script src="./assets/biotracs/js/bioviz.js" type="text/javascript"></script>', ...
                    '<link href="./assets/biotracs/css/slidebar.css" rel="stylesheet" type="text/css"/>', ...
                    '<link href="./assets/biotracs/css/biotracs.css" rel="stylesheet" type="text/css"/>', ...
                    '<link href="./assets/biotracs/css/bioviz.css" rel="stylesheet" type="text/css"/>', ...
                '</head>'...
                ];
            
            % copy all 'assets' dir existing in dependencies directories in the web path            
            [dirname] = fileparts(this.getFilePath());
            if ~isfolder(fullfile(dirname,'assets'))
                deps = biotracs.core.env.Env.depPaths();
                for i=1:length(deps)
                    list = dir( deps{i} );
                    for j=1:length(list)
                        if strcmp(list(j).name, 'assets') && list(j).isdir
                            assestDir = fullfile(list(j).folder, list(j).name);
                            copyfile( assestDir, fullfile(dirname,'assets'), 'f' );
                        end
                    end
                end
            end
            
        end
        
        function [ oHtml ]= doGenerateIdCardHtml( this )
            attrHtml = '';
            attr = this.getAttributes();
            if ~isempty(attr)
                attrNames = fields(attr);
                for j=1:length(attrNames)
                    attrHtml = [ attrHtml, ' ', attrNames{j}, '="', attr.(attrNames{j}), '"' ];
                end
            end
            
            if isempty(this.text)
                str = this.bodyTitle;
            else
                str = this.text;
            end
            
            oHtml  = strcat(...
                ' <a href="',this.getLocalUrl(),'" ', attrHtml ,'>', ...
                    str,...
                ' </a>' ...
                );
        end
        
        function [ oHtml ]= doGenerateBodyHtml( this )
            oHtml = '';
            for i=1:getLength( this.children )
                child = this.children.getAt(i);
                if isa( child, 'biotracs.core.html.Doc' )
                    child.doGenerateHtml();
                    oHtml = strcat( oHtml, child.doGenerateIdCardHtml() );
                else
                    oHtml = strcat( oHtml, child.generateHtml() );
                end
            end
        end
        
        function [ oHtml ]= doGenerateHtml( this )
            outputDir = fullfile(this.baseDirectory, this.folderName);
            if ~isempty(outputDir)
                if ~isfolder(outputDir) && ~mkdir(outputDir)
                    error('BIOTRACS:Html:Doc:AccesRestricted', 'Cannot create the output directory');
                end
            end
            
            oHtml = [...
                '<!doctype html>',...
                '<html lang="en">',...
                     this.doWriteHead(), ...
                    '<body data-spy="scroll" data-target="#',this.uid,'-toc" data-offset="0">',...
                        this.doWriteNavbar(), ...
                        this.doWriteToc( true ),...
                        '<div class="container">', ...
                            '<div class="row">', ...
                                '<div class="col-12 col-sm-12 col-md-12">', ...
                                    this.doGenerateBodyHtml(), ...
                                '</div>', ...
                            '</div>', ...
                            '<br>',...
                            '<hr>', ...
                            '<div class="lead" style="padding:10px 0px">',...
                                'Generated using ',biotracs.core.env.Env.name(),' DocuGenerator @ ', biotracs.core.date.Date.now(),...
                            '</div>', ...
                        '</div>', ...
                        '<script>', ...
                            '$(document).ready( function(){', ...
                                '$(".table").DataTable();', ...
                                'options = {"position":"right", "toggler": "#slidebar-toggler"};', ...
                                'window.slidebar = new cogito.Slidebar( "slidebar-container", options );', ...
                                '$(window).resize(function(){', ...
                                    'window.slidebar.resize();', ...
                                    '$(".table-of-content").css({"height" : $(window).height()-20});', ...
                                '});', ...
                                '$(window).trigger("resize");', ...
                            '});', ...
                        '</script>', ...
                    '</body>',...
                '</html>',...
                ];

            outputDir = fullfile(this.baseDirectory, this.folderName);            
            if ~isempty(outputDir)
                name = this.getFileName();
                if isempty(name)
                    this.setFileName('index');
                end
                
                fid = fopen( this.getFilePath(), 'w' );
                fprintf( fid, '%s', oHtml);
                fclose(fid);
                this.isOutputFileGenerated = true;
            end
        end
        
    end
    
end

