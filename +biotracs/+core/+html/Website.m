%"""
%biotracs.core.html.Website
%Website object manipulating and creating a website. A website is composed on several Doc elements and a SiteMap
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.html.Doc, biotracs.core.html.SiteMap
%"""

classdef Website < handle
    
    properties(SetAccess = protected)
        docs;               % Set of biotracs.core.html.Doc elements
        baseDirectory;      % Base directory of the website
        %navDoc;  
        %siteMap;
    end

    methods
        
        function this = Website()
            this@handle();
            this.docs = biotracs.core.container.Set(0,'biotracs.core.html.Doc');
            this.appendDoc(biotracs.core.html.Doc(), 'index');
            this.doInitSiteMap();
        end
        
        %-- A --

        function this = appendDoc( this, iDoc, iFileName )
            if nargin == 2
                this.docs.add(iDoc, iDoc.getFileName());
            else
                this.docs.add(iDoc, iFileName);
                iDoc.setFileName(iFileName);
            end
        end
        
        %-- G --
        
        function indexDoc = getIndexDoc( this )
            indexDoc = this.docs.get('index');
        end

%         function doc = getNavDoc( this )
%             doc = this.navDoc;
%         end

        function siteMapDoc = getSiteMapDoc( this )
            siteMapDoc = this.docs.get('site-map');
        end
       

        function docs = getDocs( this )
            docs = this.docs;
        end
        
        function indexDoc = getDoc( this, iName )
            indexDoc = this.docs.get(iName);
        end
        
        function indexDoc = getDocAt( this, iIndex )
            indexDoc = this.docs.getAt(iIndex);
        end
        
        function n = getLength( this )
            n = getLength(this.docs);
        end

        function generateHtml( this )
            if isfolder(this.baseDirectory)
                rmdir(this.baseDirectory, 's');
            end
            
            if isempty( this.baseDirectory )
                error('BIOTRACS:Html:Doc:BaseDirectoryUndefined', 'The base directory is not defined');
            end
            this.doSetBaseDirectoryToAllPages();
            
            % generate HTML of the navigation map page
            % this.getSiteMapDoc().generateHtml();

            % generate HTML of pages
            n = getLength(this.docs);
            w = biotracs.core.waitbar.Waitbar('Name', 'Writting HTML files');
            for i=1:n
                pageDoc = this.docs.getAt(i);
                fileName = pageDoc.getFileName();
                %if any(strcmpi(fileName, {'index','nav-map'}))
                if any(strcmpi(fileName, {'index'}))
                    continue;
                end
                
                w.show(i/n);
                this.doAppendSiteMapLinkToDoc( pageDoc );
                pageDoc.generateHtml();
            end

            % generate HTML of the index pages
            indexDoc = this.getIndexDoc();   
            this.doAppendSiteMapLinkToDoc( indexDoc );
            indexDoc.generateHtml();
        end
        
        %-- S --

        function setTitle( this, iTitle )
            this.docs.get('index').setTitle(iTitle);
        end
        
        function setBodyTitle( this, iBodyTitle )
            this.docs.get('index').setBodyTitle(iBodyTitle);
        end
        
        function setDescription( this, iDescription )
            this.docs.get('index').setDescription(iDescription);
        end
        
        function setKeywords( this, iKeywords )
            this.docs.get('index').setKeywords(iKeywords);
        end
        
        function this = setBaseDirectory( this, iDir )
            if ~ischar(iDir)
                error('BIOTRACS:Html:Doc:InvalidArgument', 'The base directory must be a string');
            end
            this.baseDirectory = fullfile(iDir);
            n = getLength(this.docs);
            for i=1:n
               this.docs.getAt(i).setBaseDirectory( this.baseDirectory );
            end            
        end
        
        function this = show( this, iOption )
            if nargin == 1
                web( this.getIndexDoc().getFilePath(), '-browser' );
            else
                web( this.getIndexDoc().getFilePath(), iOption );
            end
        end

        function this = summary( this, varargin )
            disp(this);
            this.docs.summary( varargin{:} );
        end
        
    end
    
    methods(Access = protected)
        
        function doInitSiteMap( this )
            siteMapDoc = biotracs.core.html.Doc();
            siteMapDoc.setTitle('Site map navigator');
            siteMapDoc.setBodyTitle('Site map navigator');
            siteMapDoc.setDescription('Welcome to the navigation map. Click on the links to browse the site');
            
            siteMapDoc.append(biotracs.core.html.SiteMap(),'site-map');
            this.appendDoc(siteMapDoc, 'site-map');
        end
        
        function doAppendSiteMapLinkToDoc( ~, iDoc )
            iDoc.appendParagraphBreak();
            h = biotracs.core.html.Heading( 1, 'Site map' );
            iDoc.appendBookmark( biotracs.core.html.Bookmark.fromHeading(h) );
            card = iDoc.appendCard();
            card.appendLink( 'site-map.html', '<span class="lean">Site map</table>');
        end
        
        function this = doSetBaseDirectoryToAllPages( this )
            n = getLength(this.docs);
            for i=1:n
               this.docs.getAt(i).setBaseDirectory( this.baseDirectory );
            end            
        end
        
    end
    
end

