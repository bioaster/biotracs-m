%"""
%biotracs.core.docu.view.DocuSet
%Documentation set view.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.docu.model.DocuSet
%"""

classdef DocuSet < biotracs.core.mvc.view.ResourceSet
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
        website = biotracs.core.html.Website.empty();
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DocuSet( )
          this@biotracs.core.mvc.view.ResourceSet();
        end

        %-- A --
        
        function apprendSection( this, title, content )
            h = biotracs.core.html.Heading(1, title);
            indexDoc = this.website.getIndexDoc();
            indexDoc.appendBookmark( biotracs.core.html.Bookmark.fromHeading(h) );
            card = biotracs.core.html.Div();
            card.append(h);
            if ischar(content)
                c = biotracs.core.html.Div(content);
            elseif iscellstr(content)
                c = biotracs.core.html.List(content);
            end
            
            card.append(c);
            card.appendParagraphBreak();
            indexDoc.append(card);
        end
        

        %-- R --

        function website = renderHtml( this, varargin ) 
			p = inputParser();
			p.addParameter('WorkingDirectory', '', @ischar)
			p.parse(varargin{:});
				
            this.website = biotracs.core.html.Website();
            model = this.model;
            n = getLength(model);
            w = biotracs.core.waitbar.Waitbar('Name', 'Rendering HTML');
            w.show();
            for i=1:n
                docu = model.getAt(i); 
                if ~docu.isUnitTestClass()
                    htmlDoc = docu.getView().renderHtml( varargin{:} );
                    this.website.appendDoc( htmlDoc );
                end
                w.show(i/n);
            end
            
            % title
            this.website.setTitle(this.model.meta.title);
            this.website.setBodyTitle(this.model.meta.title);
            this.website.setDescription(this.model.meta.description);
            this.website.setKeywords(this.model.meta.keywords);
            
            % build the site map
            this.doBuildSiteMapHtml();

            % generate and view html
			wd = '';
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
				error('BIOTRACS:DocuSet:DiskAccessRestriction', 'The working dorectory does not exist and cannot be created. Please check disk access rights');
			end
			
            this.website.setBaseDirectory( wd );
            this.doBuildHomePageHtml( );
            this.website.generateHtml();
        end
        
        %-- V --
        
        function this = viewHtml( this, varargin )
            if isempty(this.website)
                this.renderHtml(varargin{:});
            end
            this.website.show('-browser');
        end
        
    end
    
    methods(Access = protected)
        
        function doBuildSiteMapHtml( this )
            model = this.model;
            n = getLength(model);
            
            siteMapDoc = this.website.getSiteMapDoc();
            siteMapDoc.setTitle('Documentation map navigator');
            siteMapDoc.setBodyTitle('Documentation map navigator');
            siteMapDoc.setDescription('Welcome to the navigation map. Click on the links to browse the documentation');
            
            siteMap = siteMapDoc.get('site-map');
            siteMap.setText('<code><strong>Documentation map</strong></code>');
            for i=1:n
                docu = model.getAt(i);
                if docu.isProcessConfigClass() || docu.isUnitTestClass()
                    continue;
                end
                populateSiteMap( siteMap, docu.meta.className );
            end
            
            function populateSiteMap( iSiteMapNode, iClassName )
                tokens = strsplit(iClassName, '.');
                currentNode = iSiteMapNode;
                
                %populate with all tokens
                for j=1:length(tokens)
                    nodeText = tokens{j};
                    if ~currentNode.hasElement( nodeText )
                        node = biotracs.core.html.SiteMap();
                        if j == length(tokens)
                            nodeHtml = ['<code class="link" data-href="',iClassName,'.html">',nodeText,'</code>'];
                        else
                            nodeHtml = ['<code>',nodeText,'</code>'];
                        end
                        node.setText( nodeHtml );
                        currentNode.append( node, nodeText );
                    else
                        node = currentNode.get( nodeText );
                    end
                    currentNode = node;
                end
            end
            
        end

%         function doLicense( this )
%             doc.setTitle('Documentation map navigator');
%             doc.setBodyTitle('Documentation map navigator');
%             doc.setDescription('Welcome to the navigation map. Click on the links to browse the documentation');
%         end
        
        function doBuildHomePageHtml( this )
            indexDoc = this.website.getIndexDoc();
            card = biotracs.core.html.Div();
            
            card.append( ...
                biotracs.core.html.Div([...
                '<span class="lead">BIOTRACS is a object-oriented computational architecture designed to ensure ', ...
                'workflow traceability, scalability and sharing.', ...
                '<br><br>BIOTRACS is designed in the MATLAB envrionment and allows wrapping programms ', ...
                'from other languages (Python, R, Bash scripts, ...) and from standalone applications.', ...
                'Quickly prototype your ideas or build your entire applications BIOAPPS with biotracs.', ...
                '<br><br>With BIOTRACS simply think about processes not code!</span>']));
            
            card.appendParagraphBreak();
            indexDoc.append(card);
            
			this.apprendSection(...
                'BIOTRACS architecture and core library', ...
                {...
                'Customizable base data types: <code>DataTable</code>, <code>DataMatrix</code>, <code>...</code>', ...
                'Modules to parse and export data: <code>BaseParser</code>, <code>TableParser</code>,, <code>...</code>', ...
                'A MVC architecture to model, control and visualize pipelines and results with industrial and R&amp;D requirements', ...
                'Parallele computing capabilities', ...
                });
				
            this.apprendSection(...
                'BIOCODE library', ...
                {...
                'Customizable base data types bioinformatics: <code>FeatureSet</code>, <code>SignalSet</code>, <code>...</code>', ...
                'Plug-and-play base modules to manipulate data: <code>DataFilter</code>, <code>DataMerger</code>, <code>DataNormalizer</code>, <code>...</code>', ...
                'Modules to parse and export data: <code>SbmlParser</code>,  <code>SignalParser</code>, <code>...</code>', ...
                });
            
            this.apprendSection(...
                'BIOAPPS', ...
                {...
                'Prototype your ideas and build BIOAPPS (BIOCODE applications) that fit your R&amp;D use-cases', ...
                'Implement, customize BIOAPPS and share them with other scientists', ...
                'Some BIOAPPS are already available for sharing: <code>Data annotation</code>, <code>LC-MS data processing</code>, <code>AutoML</code>, <code>...</code>' ...
                });
            
            this.apprendSection(...
                'Metabolomics and Proteomics', ...
                {...
                'LC-MS and NMR data analysis: <code>Peak picking</code> and <code>alignment</code>, <code>Feature grouping</code>, <code>Spectrum binning</code>, <code>Spectrum resampling</code>, <code>...</code>', ...
                'Fast parsing or large data: <code>MzXMLParser</code>, <code>FidParser</code>', ...
                'Preprocessing of raw data: QC analysis, Analyitical drift correction of LC-MS data', ...
                'Visualization: <code>QcDriftPlot</code>, <code>FeatureCountPlot</code>, <code>QcCvPlot</code>', ...
                'BIOAPPS for LC-MS data annotation and preprocessing and identification (wrapping of <code>ProteoWizard</code>, <code>OpenMS</code>, <code>LipiMatch</code>, <code>Sirus</code>, <code>MetFrag</code>, <code>XTandem!</code>, <code>Mascot</code> software in ready-to-use BIOAPPS)' ...
                });
            
            this.apprendSection(...
                'Statistics', ...
                {...
                'Automatic machine learning (AutoML) using unsupervised and supervised analysis (<code>PCA</code>, <code>Regression</code>, <code>Dicriminant analysis</code>, <code>Clustering</code>, <code>Regularization</code>, <code>...</code>)', ...
                'Differential analysis processes', ...
                'Machine learning models visualization (<code>ScorePlot</code>, <code>DiffPlot</code>, <code>PredictionPlot</code>)', ...
                'Model visualisation: <code>ScorePlot</code>, <code>PredictionPlot</code>, <code>DiffPlot</code>, <code>...</code>'
                });

            this.apprendSection(...
                'Success stories', ...
                {...
                'Met-SAMoA: The computational pipeline of the Met-SAMoA&copy; platform, designed by BIOASTER, is mounted on BIOCODE', ...
                'Several industrial projects were successfully delivered using BIOAPPS'
                });
            
            this.apprendSection(...
                'Roadmap', ...
                {...
                'Graphical user interfaces (GUI) to provide user-friendly interfaces to manipulate pipeline and data while reducing code implementation and risks human errors', ...
                'Implementation of <code>Sessions</code> to start, stop, restart and store pipelines', ...
                'Accelerate automatic machine learning using C++ libraries (with MEX interfaces)' ...
                });
            
        end

    end
    
end

