%"""
%biotracs.core.adapter.model.ViewExporter
%A ViewExporter is an Exporter used to export View redering on the disk
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2018
%* See: biotracs.core.mvc.model.View
%"""

classdef ViewExporter < biotracs.core.adapter.model.FileExporter
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function this = ViewExporter()
            this@biotracs.core.adapter.model.FileExporter();
            this.config.createParam('ViewNames', {}, 'Constraint', biotracs.core.constraint.IsText('IsScalar', false));
            this.config.createParam('ViewLabels', {}, 'Constraint', biotracs.core.constraint.IsText('IsScalar', false));
            this.config.createParam('ViewParameters', {}); 
            this.config.createParam('Resolution', 300, 'Constraint', biotracs.core.constraint.IsInteger(), 'Description', 'Only used for jpg and tif');            
            this.config.updateParamValue('FileExtension', '.jpg');
        end
    end
    
    
    methods(Access = protected)

        function doRun( this )
            viewNames               = this.config.getParamValue('ViewNames');
            viewLabels              = this.config.getParamValue('ViewLabels');
            nbViews = length(viewNames);
            if nbViews == 0
                error('BIOTRACS:ViewExporter:NoViewNamesProvided', 'Please give which the names of the views to generate');
            end
                    
            inputResource = this.getInputPortData('Resource');
            logStr                  = {};
            listOfOutputFilePaths   = {};
            
            wd                      = this.config.getParamValue('WorkingDirectory');
            viewParameters          = this.config.getParamValue('ViewParameters');
            %format                  = this.config.getParamValue('Format');
            resolution              = this.config.getParamValue('Resolution');
            
            if strcmpi(class(inputResource), 'biotracs.core.mvc.model.ResourceSet')
                list = inputResource.getElements();
                try
                    showView( list );
                catch err
                    error('BIOTRACS:ViewExporter:ViewError', 'An error occurred when creating view\n%s', err.message);
                end
            else
                %try
                    showView( {inputResource} );
                %catch err
                %    error('BIOTRACS:ViewExporter:ViewError', 'An error occurred when creating view\n%s', err.message);
                %end
            end

            this.config.updateParamValue('OutputFilePaths', listOfOutputFilePaths);
            this.logger.writeLog( '%s', sprintf('%s\n',logStr{:}));

            function showView( resourceList )
                logStr = {};
                ext = ['.', regexprep(this.config.getParamValue('FileExtension'), '^(\.)+', '')];
                n = length(resourceList);
                listOfOutputFilePaths = cell(1,n);
                for i=1:n
                    resource =  resourceList{i};
                    for j=1:nbViews
                        viewName = viewNames{j};
                        if length(viewParameters) >= j
                            viewParam = viewParameters{j};
                        else
                            viewParam = {};
                        end
                        
                        if length(viewLabels) >= j
                            viewLabel = biotracs.core.utils.slugify(viewLabels{j});
                        else
                            viewLabel = '';
                        end
                        
                        if ~iscell(viewParam)
                            error('BIOTRACS:ViewExporter:InvaliViewParameters', 'Each element in ViewParameters must be a cell');
                        end
                        
                        viewDir = fullfile(wd,viewName);
                        if ~isfolder(viewDir) && ~mkdir(viewDir)
                            error('BIOTRACS:ViewExporter:DiskAccessRestriction', 'Cannot create the view directory');
                        end
                        
                        if ~isempty(regexpi(viewName, 'html$'))
                            resource.view(viewName, viewParam{:}, 'WorkingDirectory', fullfile(viewDir,viewLabel));  %generate HTML
                            this.logger.writeLog('%s', 'The HTML view is already written on disk');
                        else
                            h = resource.view(viewName, viewParam{:});
                            if isempty(h)
                                % nothing
                            elseif iscell(h) && (isa(h{1}, 'matlab.ui.Figure') || isa(h{1}, 'clustergram'))
                                for k=1:length(h)
                                    fileName = [resource.getLabel(),num2str(k),ext];
                                    biotracs.core.fig.helper.Figure.save( fullfile(viewDir, viewLabel, fileName), 'Resolution', resolution, 'FigureHandle', h{k}, 'CloseAfterSaving', true );
                                end
                            elseif isstruct(h) && (isa(h.handles{1}, 'matlab.ui.Figure') || isa(h.handles{1}, 'clustergram'))
                                for k=1:length(h.handles)
                                    fileName = [resource.getLabel(), biotracs.core.utils.slugify(h.names{k}) ,ext];
                                    biotracs.core.fig.helper.Figure.save( fullfile(viewDir, viewLabel, fileName), 'Resolution', resolution, 'FigureHandle', h.handles{k}, 'CloseAfterSaving', true );
                                end
                            elseif isa(h(1), 'matlab.ui.Figure') ||  isa(h(1), 'clustergram')
                                for k=1:length(h)
                                    fileName = [resource.getLabel(),num2str(k),ext];
                                    biotracs.core.fig.helper.Figure.save( fullfile(viewDir, viewLabel, fileName), 'Resolution', resolution, 'FigureHandle', h(k), 'CloseAfterSaving', true );
                                end
                            end
                        end
                    end
                    oPath = fullfile(viewDir,  resource.getLabel());
                    listOfOutputFilePaths{i} = oPath;
                    logStr = [logStr, {['Export ', oPath]}];
                end
                
                logStr = [logStr, {['Export ', wd]}];
            end
            
            
        end
        
    end
end
