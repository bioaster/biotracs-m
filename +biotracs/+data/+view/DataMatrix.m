%"""
%biotracs.data.view.DataMatrix
%DataMatrix view
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.data.model.DataMatrix
%"""

classdef DataMatrix < biotracs.data.view.DataTable
    
    properties(SetAccess = protected)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Plot a spectrum in a 2D graph
        %> @param[in] varargin
        % - Hold            : true to create a new figure; false otherwise
        % - SubPlot         : Give the subplot position of the graph (as in subplot() function)
        %> @return the Handle of the figure
        function h = viewPlot( this, varargin )
            %color = biotracs.core.color.Color.colormap();
            p = inputParser();
            p.addParameter('Normalize',false,@islogical);
            p.addParameter('Title','',@ischar);
            p.addParameter('ColumnIndexes',[],@(x)(isnumeric(x) && length(x) <= 2));
            p.addParameter('Range',[],@isnumeric);
            p.addParameter('Color','b',@(x)(ischar(x) || isnumeric(x)));
            p.addParameter('LineStyle','-',@ischar);
            p.addParameter('Marker','none',@ischar);
            p.addParameter('MarkerEdgeColor','auto',@(x)(ischar(x) || isnumeric(x)));
            p.addParameter('MarkerFaceColor','none',@(x)(ischar(x) || isnumeric(x)));
            p.addParameter('MarkerSize',6,@isnumeric);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            h = this.doPrepareFigure( varargin{:} );
            
            % check data
            model = this.getModel();
            [m,n] = getSize(model);
            
            if n < 2
                %error('At least two columns are required');
                x = 1:m;
                y = model.data(:,1);
                xlab = '';
                ylab = strrep(model.getColumnNames(1), '_', '-');
            elseif n >= 2
                if isempty(p.Results.ColumnIndexes)
                    if n > 2
                        disp('Warning: Only the two first columns will be plotted');
                    end
                    colIdx = [1,2];
                else
                    colIdx = p.Results.ColumnIndexes;
                    if length(colIdx) == 1
                        colIdx = [1, colIdx];
                    end
                end
                
                %@ToDO: -> choose which columns to plot ?
                x = model.data(:,colIdx(1));
                y = model.data(:,colIdx(2));
                xlab = strrep(model.getColumnNames(colIdx(1)), '_', '-');
                ylab = strrep(model.getColumnNames(colIdx(2)), '_', '-');
            end
            
            if p.Results.Normalize
                maxY = max(abs(y));
                y = y / maxY(1);
            end
            
            % plot
            isStem = ~isempty(strfind(p.Results.LineStyle, '|'));
            if isStem
                %style = strrep(p.Results.LineStyle,'|','');
                stem(x, y, ...
                    'Marker', p.Results.Marker, ...
                    'Color', p.Results.Color, ...
                    'MarkerFaceColor', p.Results.MarkerFaceColor, ...
                    'MarkerEdgeColor', p.Results.MarkerEdgeColor, ...
                    'MarkerSize', p.Results.MarkerSize ...
                    );
            else
                plot(x, y, ...
                    'LineStyle', p.Results.LineStyle, ...
                    'Color', p.Results.Color, ...
                    'Marker', p.Results.Marker, ...
                    'MarkerFaceColor', p.Results.MarkerFaceColor, ...
                    'MarkerEdgeColor', p.Results.MarkerEdgeColor, ...
                    'MarkerSize', p.Results.MarkerSize ...
                    );
            end
            
            if isempty(p.Results.Title)
                title( strrep(model.getLabel(), '_', '-') );
            else
                title( p.Results.Title );
            end
            xlabel( xlab );
            ylabel( ylab );
            set(gca,'TickDir','out');
            grid on;
        end
        
        function h = viewScatterPlot( this, varargin )
            p = inputParser();
            p.addParameter('Direction','column',@ischar);
            p.addParameter('FontSize',12,@isnumeric);
            p.addParameter('YLim',[],@isnumeric);
            p.addParameter('Title','',@ischar);
            p.addParameter('YLabel','',@ischar);
            p.addParameter('XLabel','',@ischar);
            p.addParameter('LabelLocation', 'outer', @ischar); %'outer', 'inner', 'none'
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            h = this.doPrepareFigure( varargin{:} );
            
            hold on;
            cmap = lines;
            [m,n] = getSize(this.model);
            cnames = biotracs.core.utils.formatLabelForPlot(this.model.columnNames);
            rnames = biotracs.core.utils.formatLabelForPlot(this.model.rowNames);
            if strcmp(p.Results.Direction, 'column')
                for i=1:m
                    x = 1:n;
                    x = x + (-1 + 2*rand(1,n))*0.1;
                    plot(x-0.5, this.model.data(i,:), 'LineStyle', 'none', 'Marker', 'o', 'MarkerFaceColor', cmap(i,:), 'MarkerEdgeColor', cmap(i,:), 'MarkerSize', 6);
                end
                lgd = legend( rnames );
                ax = gca;
                
                if strcmp(p.Results.LabelLocation, 'outer')
                    ax.XTickLabel = biotracs.core.utils.formatLabelForPlot( cnames );
                    ax.XTick = (1:n)-0.5;
                end
                xlim([0,n]);
            else
                for i=1:n
                    x = 1:m;
                    x = x + (-1 + 2*rand(1,m))*0.1;
                    plot(x-0.5, this.model.data(:,i), 'LineStyle', 'none', 'Marker', 'o', 'MarkerFaceColor', cmap(i,:), 'MarkerEdgeColor', cmap(i,:), 'MarkerSize', 6);
                end
                lgd = legend( cnames );
                ax = gca;
                
                if strcmp(p.Results.LabelLocation, 'outer')
                    ax.XTickLabel = biotracs.core.utils.formatLabelForPlot( rnames );
                    ax.XTick = (1:m)-0.5;
                end
                xlim([0,m]);
            end
            
            ax.XTickLabelRotation = 90;
            set(ax, 'TickDir', 'out', 'FontSize', p.Results.FontSize);
            
            if ~isempty(p.Results.YLim)
                ylim(p.Results.YLim);
            end
            
            yLim = ylim();
            if strcmp(p.Results.Direction, 'column')
                for i=1:n-1
                    plot([i,i], yLim, '-.', 'Color', [1,1,1]*0.5, 'LineWidth', 1);
                end
                if strcmp(p.Results.LabelLocation, 'inner')
                    text( (1:n)-0.25, ones(1,n)*yLim(1), cnames, 'Rotation', 90, 'FontSize', p.Results.FontSize );
                end
            else
                for i=1:m-1
                    plot([i,i], yLim, '-.', 'Color', [1,1,1]*0.5, 'LineWidth', 1);
                end
                if strcmp(p.Results.LabelLocation, 'inner')
                    text( (1:m)-0.25, ones(1,m)*yLim(1), rnames, 'Rotation', 90, 'FontSize', p.Results.FontSize );
                end
            end
            
            title(p.Results.Title);
            xlabel(p.Results.XLabel);
            ylabel(p.Results.YLabel);
            
            lgd.Box = 'off';
            lgd.Location = 'eastoutside';
            lgd.FontSize = 9;
            
            grid on;
            box on;
        end
        
        function h = viewDistributionPlot( this, varargin )
            p = inputParser();
            p.addParameter('LineStyle','b*',@ischar);
            p.addParameter('Direction','column',@(x)(ischar(x) && ismember(x,{'column','row'})));
            p.addParameter('ShowErrorBar', true, @islogical);
            p.addParameter('ShowPoints', false, @islogical);
            p.addParameter('ShowDensity', false, @islogical);
            p.addParameter('ShowNamesOnTicks', false, @islogical);
            p.addParameter('Title','',@ischar);
            p.addParameter('XLabel','',@ischar);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            h = this.doPrepareFigure( varargin{:} );
            
            dataMean = mean(this.model, 'Direction', p.Results.Direction);
            %dataSd = std(this.model, 'Direction', p.Results.Direction);
            
            if p.Results.ShowErrorBar
                if strcmp(p.Results.Direction, 'column')
                    boxplot(this.model.data, 'Widths',0.2, 'Symbol', 'r.');
                    if p.Results.ShowNamesOnTicks
                        set(gca, 'XTickLabel', this.model.columnNames, 'XTickLabelRotation', 90);
                    end
                else
                    boxplot(transpose(this.model.data), 'Widths',0.2, 'Symbol', 'r.');
                    if p.Results.ShowNamesOnTicks
                        set(gca, 'XTickLabel', this.model.rowNames, 'XTickLabelRotation', 90);
                    end
                end
                %errorbar(1:n, dataMean.data, dataSd.data, p.Results.LineStyle);
                hold on
            else
                n = length(dataMean.data);
                plot(1:n, dataMean.data, p.Results.LineStyle);
                hold on
            end
            
            if p.Results.ShowPoints
                [m,n] = getSize(this.model);
                if strcmp(p.Results.Direction, 'column')
                    x = repmat(1:n, m, 1);
                    x = x + (-1 + 2*rand(m,n))*0.05; %rand value in [-0.05, 0.05]
                    plot(x(:), this.model.data(:), '.r');
                else
                    x = repmat(1:m, n, 1);
                    x = x + (-1 + 2*rand(n,m))*0.05; %rand value in [-0.05, 0.05]
                    d = this.model.data';
                    plot(x(:), d(:), '.r');
                end
            end
            
            if p.Results.ShowDensity
                n = length(dataMean.data);
                if strcmp(p.Results.Direction, 'column')
                    for i=1:n
                        x = this.model.data(:,i);
                        [N,edges] = histcounts(x);
                        plot(N/max(N)+i, edges(1:end-1), '-', 'Color', [1,1,1]*0.65);
                    end
                else
                    for i=1:n
                        x = this.model.data(i,:);
                        [N,edges] = histcounts(x);
                        plot(N/max(N)+i, edges(1:end-1), '-', 'Color', [1,1,1]*0.65);
                    end
                end
            end
            
            if isempty(p.Results.Title)
                title( strrep(this.model.getLabel(), '_', '-') );
            else
                title( p.Results.Title );
            end
            
            xlabel( p.Results.XLabel );
            ylabel( 'Magnitude' );
            set(gca,'TickDir','out');
            grid on;
        end
        
        function h = viewBarPlot( this, varargin )
            %color = [102, 153, 255]/255;
            color = [153, 194, 255]/255;
            
            p = inputParser();
            p.addParameter('NewFigure',true,@islogical);
            p.addParameter('SubPlot',{1,1,1},@iscell);
            p.addParameter('FaceColor', color, @(x)(ischar(x) || (isnumeric(x) && length(x) == 3)) );
            p.addParameter('EdgeColor', color, @(x)(ischar(x) || (isnumeric(x) && length(x) == 3)) );
            p.addParameter('FontSize', 12, @isnumeric );
            p.addParameter('Title','',@ischar);
            p.addParameter('Normalization','none', @ischar);
            p.addParameter('LabelFormat','long',@(x)(iscell(x) || ischar(x)));
            p.addParameter('ErrorData', [], @(x)(isnumeric(x) || isa(x,'biotracs.data.model.DataMatrix')));
            p.KeepUnmatched = true;
            p.parse(varargin{:})
            
            model = this.getModel();
            [m,n] = getSize(model);
            
            h = this.doPrepareFigure( varargin{:} );
            
            %x = 1:m;
            x = 1:n;
            %colormap( biotracs.core.color.Color.colormap() )
            
            if any(strcmpi(p.Results.Normalization, {'log','log10', 'log2'}))
                data = feval(p.Results.Normalization, model.data);
                bar( data );
            else
                data = model.data;
            end
            
            bounds = 0.5/2;
            delta = 2*bounds/m;
            cmap = biotracs.core.color.Color.colormap();
            for i=1:m
                k = bounds;
                %add 0.5*delta for centering plots
                bar( (x-k+0.5*delta)+(i-1)*delta,  data(i,:), 'BarWidth', delta, 'FaceColor', cmap(i,:) ); hold on;
            end
            
            if ~isempty(p.Results.ErrorData)
                if isa(p.Results.ErrorData,'biotracs.data.model.DataMatrix')
                    e = p.Results.ErrorData.getData();
                else
                    e = p.Results.ErrorData;
                end
                
                if any(strcmpi(p.Results.Normalization, {'log','log10', 'log2'}))
                    e = bas(feval(p.Results.Normalization, e));
                end
                
                for i=1:m
                    k = bounds;
                    %add 0.5*delta for centering plots
                    errorbar( (x-k+0.5*delta)+(i-1)*delta, data(i,:), e(i,:), 'LineStyle', 'none', 'Color', [0,0,0], 'CapSize', 2 );
                end
            end
            
            xlim([x(1)-1, x(end)+1]);
            
            if ~isempty(p.Results.Title)
                title( p.Results.Title );
            end
            
            ylabel( 'Magnitude' );
            ax = gca;
            ax.XTickLabel = biotracs.core.utils.formatLabelForPlot( model.getColumnNames(), 'LabelFormat', p.Results.LabelFormat );
            ax.XTick = x;
            ax.XTickLabelRotation = 90;
            set(ax, 'TickDir', 'out', 'FontSize', p.Results.FontSize);
            grid on;
            
        end
        
        function h = viewHistogram( this, varargin )
            p = inputParser();
            p.addParameter('Direction','column',@ischar);
            p.addParameter('Title','',@ischar);
            p.addParameter('LineStyle','bar',@ischar);
            p.addParameter('NbBins',[],@isnumeric);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            h = this.doPrepareFigure( varargin{:} );
            
            % check data
            model = this.getModel();
            [m,n] = getSize(model);
            
            if strcmpi(p.Results.Direction, 'column')
                y = model.data(:,1);
                if n >= 2
                    disp('Warning: Only the first column is used');
                end
            else
                y = model.data(1,:);
                if m >= 2
                    disp('Warning: Only the first row is used');
                end
            end
            
            if strcmpi(p.Results.LineStyle, 'bar')
                if isempty(p.Results.NbBins)
                    h = histogram(y,'Normalization','probability');
                else
                    h = histogram(y, p.Results.NbBins,'Normalization','probability');
                end
            elseif strcmpi(p.Results.LineStyle, 'line')
                if isempty(p.Results.NbBins)
                    [N,edges] = histcounts(y,'Normalization','probability');
                else
                    [N,edges] = histcounts(y, p.Results.NbBins,'Normalization','probability');
                end
                plot(edges(1:end-1),N,'b-');
            else
                error('Invalid style. Valid styles are ''bar'' or ''line''');
            end
            %xlabel(xlab);
            ylabel('Probability')
        end
        
        
        function h =  viewGroupedBoxPlot( this, varargin )  
            p = inputParser();
            p.addParameter('InputFilePath','',@ischar);
            p.addParameter('OutputFilePath','',@ischar);
            p.addParameter('ConditionNameColor','',@ischar);
            p.addParameter('ConditionNameGroup', '', @ischar);
            p.addParameter('Colors', 'NA', @ischar);

            p.KeepUnmatched = true;
            p.parse(varargin{:}); 
            h = [];
            model = this.getModel();
            inputFilePath = model.getRepository();
            if ~isfolder(p.Results.OutputFilePath)
                mkdir(p.Results.OutputFilePath);
            end
            
            rExectubale = biotracs.core.env.Env.vars('RExecutableFilePath');
            rScript =  biotracs.core.env.Env.vars('BoxPlotFilePath');
            cmd = ['"', rExectubale, '"', ' --vanilla "' , rScript , '"'];

            system([cmd, ' -i "', inputFilePath, '" -o "' ,p.Results.OutputFilePath, ...
                '" -n "', p.Results.ConditionNameColor, '" -g "', p.Results.ConditionNameGroup, ...
                '" -c "', p.Results.Colors,'"']);

        end
        
        
        function h = viewBoxPlot( this, varargin )
            p = inputParser();
            p.addParameter('Title','',@ischar);
            p.addParameter('MedianStyle','target',@ischar);
            p.addParameter('Notch','on',@ischar);
            p.addParameter('PlotStyle', 'traditional, @ischar');
            p.addParameter('Whisker', 1.5, @isnumeric);
            p.addParameter('TickLabel', {},@iscell);
            p.addParameter('LabelOrientation', 'inline', @ischar);
            p.addParameter('XLabel','',@ischar);
            p.addParameter('YLabel','',@ischar);
            p.addParameter('Direction', 'column', @ischar);
            p.addParameter('Color' , 'rgbm', @ischar);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            h = this.doPrepareFigure( varargin{:} );
            
            % check data
            model = this.getModel();
            %             [~,n] = getSize(model);
            if strcmp(p.Results.Direction, 'column')
                h = boxplot(model.data, ...
                    'Labels', p.Results.TickLabel, ...
                    'LabelOrientation', p.Results.LabelOrientation, ...
                    'Color', p.Results.Color ...
                    );
            else
                dataTransposed = transpose(model.data);
                h = boxplot(dataTransposed,...
                    'Labels', p.Results.TickLabel, ...
                    'LabelOrientation', p.Results.LabelOrientation, ...
                    'Color', p.Results.Color ...
                    );
            end
            xlabel(p.Results.XLabel);
            ylabel(p.Results.YLabel);
        end
        
        
        function h = viewHeatMap( this, varargin )
            p = inputParser();
            p.addParameter('Title','',@ischar);
            p.addParameter('RowLabels', {}, @iscell);
            p.addParameter('ColumnLabels', {}, @iscell);
            p.addParameter('RowLabelFormat', {}, @iscell);
            p.addParameter('SortRowNames', false, @islogical);
            p.addParameter('ColumnLabelFormat', {}, @iscell);
            p.addParameter('Transformation', {'none'}, @(x)(any(ismember(x,{'none','log','log2'}))));
            p.addParameter('MissingDataColor', [1,1,1]*0.15, @isnumeric);
            p.addParameter('CellLabelFormat', '%1.2f', @ischare);
            
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            h = this.doPrepareFigure(varargin{:});
            
            % check data
            model = this.getModel();
            y = model.data();
            if strcmp(p.Results.Transformation,'log2')
                y = log2(y);
            elseif strcmp(p.Results.Transformation,'log')
                y = log(y);
            end
            
            if  isempty(p.Results.RowLabels) && isempty(p.Results.ColumnLabels)
                colNames = model.columnNames;
                rowNames = model.rowNames;
                if ~isempty( p.Results.RowLabelFormat )
                    rowNames = biotracs.core.utils.formatLabelForPlot( rowNames, 'LabelFormat', p.Results.RowLabelFormat );
                end
                if ~isempty( p.Results.ColumnLabelFormat )
                    colNames = biotracs.core.utils.formatLabelForPlot( colNames, 'LabelFormat', p.Results.ColumnLabelFormat );
                end
                
                %unify labels is necessary
                n = length(colNames);
                if length(unique(colNames)) < n
                    for i=1:n
                        colNames{i} = strcat(colNames{i},'-',num2str(i));
                    end
                end
                
                n = length(rowNames);
                if length(unique(rowNames)) < n
                    for i=1:n
                        rowNames{i} = strcat(rowNames{i},'-',num2str(i));
                    end
                end
                
                if p.Results.SortRowNames
                    [rowNames, idx] = sort(rowNames);
                    y = y(idx,:);
                end
                
                heatmap(colNames, rowNames, y, 'MissingDataColor', p.Results.MissingDataColor, 'CellLabelFormat', p.Results.CellLabelFormat);
            else
                heatmap(p.Results.ColumnLabels,p.Results.RowLabels, y, 'MissingDataColor', p.Results.MissingDataColor, 'CellLabelFormat', p.Results.CellLabelFormat);
            end
        end
        
        
        function  h = viewSparsityPlot ( this, varargin )
            p = inputParser();
            p.addParameter('Title','',@ischar);
            p.addParameter('Xlabel', '', @ischar);
            p.addParameter('Ylabel', '', @ischar);
            p.addParameter('TickLabels', {}, @iscellstr);
            p.addParameter('MarkerSize', 1 , @isnumeric );
            p.addParameter('SparsityLevels', 1 , @isnumeric );
            p.addParameter('SparsityLevelNames', {} , @iscellstr );
            p.addParameter('MatrixOrder',true,@islogical);
            p.addParameter('ColorMap',biotracs.core.color.Color.colormap(),@isnumeric);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            h = this.doPrepareFigure(varargin{:});
            
            % check data
            model = this.getModel();
            if isempty(find(model.data, 1))
                return;
            end
            
            areNumericTickLabels = false;
            currentSize = p.Results.MarkerSize;
            for i=1:length(p.Results.SparsityLevels)
                [x,y,areNumericTickLabels,tickValues] = s2xy(i);
                plot(x,y, 'Marker', 'o', 'LineStyle', 'none', 'MarkerSize', currentSize, 'Color', p.Results.ColorMap(i,:));
                currentSize = currentSize + 2;
                hold on;
            end
            
            ax = gca;
            nbChildren = length(ax.Children);
            if isempty( p.Results.SparsityLevelNames )
                c = num2cell(p.Results.SparsityLevels);
                c = cellfun(@num2str, c, 'UniformOutput', false);
                if ~isempty(c)
                    legend(c{1:nbChildren});
                end
            else
                legend( p.Results.SparsityLevelNames(1:nbChildren) );
            end
            
            if ~isempty(p.Results.TickLabels) && ~areNumericTickLabels
                lbl = biotracs.core.utils.formatLabelForPlot( p.Results.TickLabels, varargin{:});
                set(ax, 'XTickLabel', lbl);
                set(ax, 'YTickLabel', lbl);
            end
            
            [m,n] = size(model.data);
            if areNumericTickLabels
                xlim([tickValues(1),tickValues(m)]);
                ylim([tickValues(1),tickValues(n)]);
            else
                [m,n] = size(model.data);
                xlim([0,m+1]);
                ylim([0,n+1]);
            end
            
            if p.Results.MatrixOrder
                set(gca,'YDir','reverse', 'XAxisLocation', 'top');
            end
            
            xlabel(p.Results.Xlabel);
            ylabel(p.Results.Ylabel);
            
            function [x,y,areNumericTickLabels,tickValues] = s2xy(i)
                [x,y] = find(model.data >= p.Results.SparsityLevels(i));
                if isempty(p.Results.TickLabels)
                    tickValues = str2double(model.getColumnNames());
                else
                    tickValues = str2double(p.Results.TickLabels);
                end
                areNumericTickLabels = ~any(isnan(tickValues));
                if areNumericTickLabels
                    x = tickValues(x);
                    y = tickValues(y);
                end
            end
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
    end
    
    % -------------------------------------------------------
    % Static methods
    % -------------------------------------------------------
    
    methods(Static)
        
    end
end
