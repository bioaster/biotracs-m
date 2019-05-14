%"""
%biotracs.data.view.DataSet
%DataSet view
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.data.model.DataSet
%"""

classdef DataSet < biotracs.data.view.DataMatrix
    
    properties(SetAccess = protected)      
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        function  h = viewFeatureGroupingPlot ( this, varargin )
            p = inputParser();
            %p.addParameter('TickLabels', [], @ischar);
            p.addParameter('SignalIndex', 1, @isnumeric);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            signalIndex = p.Results.SignalIndex(1);
            reducedDataSet = this.getModel();
            reducedTickValues = reducedDataSet.getVariablePositions();
            isSorted = issorted(reducedTickValues);
            if ~isSorted
                [ ~, idx ] = sort( reducedTickValues );
                reducedDataSet = reducedDataSet.selectByColumnIndexes(idx);
                reducedTickValues = reducedDataSet.getVariablePositions();
            end
   
            h = [];
            
            if ~reducedDataSet.hasSibling('RedundancyMatrix')
                biotracs.core.env.Env.writeLog('%s', 'The resource must have a RedundancyMatrix has sibling');
                return;
            end
            
            redundancyMatrix = reducedDataSet.getSibling('RedundancyMatrix');  
            if ~redundancyMatrix.isNil() && ~hasEmptyData(redundancyMatrix)
                originalDataSet = reducedDataSet.getProcess()...
                               .getInputPortData('DataSet');
                originalTickValues = originalDataSet.getVariablePositions();
                isSorted = issorted(originalTickValues);
                if ~isSorted
                    [ ~, idx ] = sort( originalTickValues );
                    originalDataSet = originalDataSet.selectByColumnIndexes(idx);
                    originalTickValues = originalDataSet.getVariablePositions();
                end
   
                
                maxLevel = (max(max(redundancyMatrix.data)));
                h = figure();
                
                ax1 = subplot('Position',[0.1, 0.7, 0.8, 0.25]);
                box on; 

                plot( originalTickValues, originalDataSet.data(signalIndex,:) ); hold on
                line = ax1.Children(1);
                line.Tag = 'OriginalDataSet';
                    
                %Plot the ReducedDataSet
                if ~hasEmptyData(reducedDataSet)
                    plot( reducedTickValues, reducedDataSet.data(signalIndex,:), '.' );
                    line = ax1.Children(1);
                    line.Tag = 'ReducedDataSet';
                end
                
                titleStr = biotracs.core.utils.formatLabelForPlot( originalDataSet.getRowName(signalIndex), varargin{:});
                title( titleStr );
                
                %Plot the RedundancyMatrix
                ax2 = subplot('Position',[0.1, 0.1, 0.8, 0.50]); 
                linkaxes([ax1,ax2],'x');
                redundancyMatrix.view(...
                    'SparsityPlot', ...
                    'SparsityLevels', 1:maxLevel, ...
                    'NewFigure', false, ...
                    'TickLabels', arrayfun( @num2str, originalTickValues, 'UniformOutput', false ), ...
                    'SubPlot', {} );
                box on;     
                
                
                %Add labels to lines
                dcmObj = datacursormode(h);
                set(dcmObj,'UpdateFcn',@onClick);
            else
                biotracs.core.env.Env.writeLog('%s','The resource must have a non empty RedundancyMatrix sibling. Please ensure that the resource is generated using biotracs.dataproc.model.FeatureGrouper.');
            end
            
            isHilighted = false;
            function txt = onClick(~,event)
                x = event.Position(1);
                y = event.Position(2);
                tagName = get(event.Target,'Tag');
                
                pos = {['X: ', num2str(x)], ['Y: ', num2str(y)] };
                if isempty( tagName )
                    txt = pos;
                else
                    txt = [{ tagName }, pos ];
                    if strcmp(tagName, 'ReducedDataSet')
                        [idx] = find(reducedTickValues == x, 1);
                        t = reducedDataSet.getColumnTag(idx);
                        ifIdx = t.IsofeatureIndexes;
                        ifValues = originalTickValues(ifIdx);
                        
                        %ifValues = str2double(t.IsofeatureNames);
                        %ifNames = t.IsofeatureNames;
                        %ifGroup = t.IsofeatureGroupIndex;
                        
                        %Remove previous hilightedLine
                        if isHilighted
                            hLine = ax1.Children(1);
                            delete(hLine);
                            isHilighted = false;
                        end
                        
                        axes(ax1); hold on;
                        plot( ifValues, originalDataSet.data(signalIndex,ifIdx), 'o-k', 'LineWidth', 2 );
                        isHilighted = true;
                    end
                end
            end
        end
        
    end
    
end
