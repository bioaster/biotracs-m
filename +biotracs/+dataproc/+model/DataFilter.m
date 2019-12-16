%"""
%biotracs.dataproc.model.DataFilter
%DataFilter process to filter DataMatrix
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.dataproc.model.DataFilterConfig
%"""

classdef DataFilter < biotracs.core.mvc.model.Process
    
    properties(Constant)
    end
    
    properties(Dependent)
    end
    
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataFilter()
            %#function biotracs.dataproc.model.DataFilterConfig biotracs.data.model.DataMatrix
            
            this@biotracs.core.mvc.model.Process();
            
            % define input and output specs
            this.addInputSpecs({...
                struct(...
                'name', 'DataMatrix',...
                'class', 'biotracs.data.model.DataMatrix' ...
                )...
                });
            
            % define input and output specs
            this.addOutputSpecs({...
                struct(...
                'name', 'DataMatrix',...
                'class', 'biotracs.data.model.DataMatrix' ...
                )...
                });
        end
        
    end
    
    % -------------------------------------------------------
    % Private methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function doBeforeRun( this )
            this.doBeforeRun@biotracs.core.mvc.model.Process();
            %this.isPhantom = this.config.getParamValue('MinAverage') == -Inf && ...
            %    this.config.getParamValue('MinStandardDeviation') < 0
        end
        
        function doRun( this )
            dataMatrix = this.getInputPortData('DataMatrix');
            data = dataMatrix.getData();
            minAverage = this.config.getParamValue('MinAverage');
            minStd = this.config.getParamValue('MinStandardDeviation');
            minValue = this.config.getParamValue('MinValue');
            isRowDirection = strcmp(this.config.getParamValue('Direction'), 'row');
            names = this.config.getParamValue('ListOfNamesToIgnore');
            
            if isRowDirection
                totalSize = size(data,1);
                dataMean = mean(data,2)';
                dataStd = std(data,0,2)';
                %dataMatrix.rowNames'
                ignoredIndexes = dataMatrix.getRowIndexesByName(names);
            else
                totalSize = size(data,2);
                dataMean = mean(data,1);
                dataStd = std(data,0,1);
                %dataMatrix.columnNames'
                ignoredIndexes = dataMatrix.getColumnIndexesByName(names);
            end

            selectedIndexes = true(1, totalSize);
            
            %filter 1
            if minAverage > -Inf
                if any(isnan(dataMean))
                    error('SPECTRA:DataFilter:NanValuesInData', 'Please remove missing values from your data')
                end
                
                idx = (dataMean > minAverage);
                selectedIndexes = selectedIndexes & idx;
                biotracs.core.env.Env.writeLog('\t > %d entries removed using min-average fitering', sum(~idx));
            end
            
            %filter 2
            if minStd >= 0
                if any(isnan(dataStd))
                    error('SPECTRA:DataFilter:NanValuesInData', 'Please remove missing values from your data')
                end
                
                idx = (dataStd > minStd);
                selectedIndexes = selectedIndexes & idx;
                biotracs.core.env.Env.writeLog('\t > %d entries removed using standard-deviation fitering', sum(~idx));
            end
            
            %filter 3
            if minValue > -Inf
                if isRowDirection
                    idx = any(data > minValue, 2)';
                    selectedIndexes = selectedIndexes & idx;
                else
                    idx = any(data > minValue, 1);
                    selectedIndexes = selectedIndexes & idx;
                end
                biotracs.core.env.Env.writeLog('\t > %d entries removed using minimal-value fitering', sum(~idx));
            end
  
            sizeOfSelectedData  = sum(selectedIndexes);
            sizeOfRemovedData = totalSize - sizeOfSelectedData;
            percOfRemovedData = 100 * sizeOfRemovedData/totalSize;

            selectedIndexes(ignoredIndexes) = true;     %do not remove ignored entries 
            if strcmp(this.config.getParamValue('Direction'), 'row')
                filteredDataMatrix = dataMatrix.selectByRowIndexes(selectedIndexes);
                biotracs.core.env.Env.writeLog('\t > a total of %d rows removed over %d rows (data is reduced by %1.0f%%)', sizeOfRemovedData, totalSize, percOfRemovedData);
            else
                filteredDataMatrix = dataMatrix.selectByColumnIndexes(selectedIndexes);
                biotracs.core.env.Env.writeLog('\t > a total of %d columns removed over %d columns (data is reduced by %1.0f%%)', sizeOfRemovedData, totalSize, percOfRemovedData);
            end
            
            this.setOutputPortData('DataMatrix', filteredDataMatrix);
        end

    end
end
