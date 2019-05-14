%"""
%biotracs.dataproc.model.DataSplitter
%DataSplitter process is an Iterator allows splitting a DataTable using column/row names patterns. DataTable parts are sequentially sent to next processes.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.dataproc.model.DataSplitterConfig, biotracs.core.adapter.model.Iterator, biotracs.data.model.DataTable, biotracs.data.model.DataMatrix, biotracs.data.model.DataSet
%"""

classdef DataSplitter < biotracs.core.adapter.model.Iterator
    
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
        function this = DataSplitter()
            this@biotracs.core.adapter.model.Iterator();
            
            % define input and output specs
            this.addInputSpecs({...
                struct(...
                'name', 'DataTable',...
                'class', 'biotracs.data.model.DataTable' ...
                )...
                });
            
            % define input and output specs
            this.addOutputSpecs({...
                struct(...
                'name', 'DataTable',...
                'class', 'biotracs.data.model.DataTable' ...
                )...
                });
        end
        
    end
    
    % -------------------------------------------------------
    % Private methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function doBeforeRun( this )
            this.doBeforeRun@biotracs.core.adapter.model.Iterator();
            listOfNames = this.config.getParamValue('ListOfNames');
            if isempty(listOfNames)
                this.setIsPhantom( true );
            end
        end
        
        function doRun( this )
            dataTable = this.getInputPortData('DataTable');
            if dataTable.hasEmptyData()
               return; 
            end
            [selectedDataTable] = this.doSelect(dataTable);
            this.setOutputPortData('DataTable', selectedDataTable);
        end
        
        function [selectedDataTable] = doSelect (this, dataTable)
            choice = this.config.getParamValue('SelectOrRemove');
            direction = this.config.getParamValue('Direction');
            listOfNames = this.config.getParamValue('ListOfNames');
            
            [m,n] = getSize(dataTable);
            if strcmp(choice, 'remove')
                if strcmp(direction, 'row')
                    selectedDataTable = dataTable.removeByRowName(listOfNames);
                    m2 = getSize(selectedDataTable,1);
                    this.logger.writeLog('\t > %d rows removed (%d remaining rows)', m-m2, m2);
                elseif strcmp(direction, 'column')
                    selectedDataTable = dataTable.removeByColumnName(listOfNames);
                    n2 = getSize(selectedDataTable,2);
                    this.logger.writeLog('\t > %d columns removed (%d remaining columns)', n-n2, n2);
                end
            end
            
            if strcmp(choice, 'select')
                if strcmp(direction, 'row')
                    selectedDataTable = dataTable.selectByRowName(listOfNames);
                    m2 = getSize(selectedDataTable,1);
                    this.logger.writeLog('\t > %d rows selected (%d rows removed)', m2, m-m2);
                elseif strcmp(direction, 'column')
                    selectedDataTable = dataTable.selectByColumnName(listOfNames);
                    n2 = getSize(selectedDataTable,2);
                    this.logger.writeLog('\t > %d columns selected (%d column removed)', n2, n-n2);
                end
            end
            selectedDataTable.discardProcess();
        end
    end
end
