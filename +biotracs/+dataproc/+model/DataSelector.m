%"""
%biotracs.dataproc.model.DataSelector
%DataSelector process allows selecting part of DataTable using to column/row names patterns or column/row indexes specifications
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.dataproc.model.DataSelectorConfig, biotracs.data.model.DataTable, biotracs.data.model.DataMatrix, biotracs.data.model.DataSet
%"""

classdef DataSelector < biotracs.core.mvc.model.Process
    
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
        function this = DataSelector()
            %#function biotracs.dataproc.model.DataSelectorConfig biotracs.data.model.DataTable biotracs.core.mvc.model.ResourceSet biotracs.data.model.DataTable
            
            this@biotracs.core.mvc.model.Process();
            
            % define input and output specs
            this.addInputSpecs({...
                struct(...
                'name', 'DataTable',...
                'class', 'biotracs.data.model.DataTable' ...
                ),...
                struct(...
                'name', 'SelectedVariableResourceSet', ...
                'class', 'biotracs.core.mvc.model.ResourceSet', ...
                'required', false ...
                )
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
            this.doBeforeRun@biotracs.core.mvc.model.Process();
            listOfNames = this.config.getParamValue('ListOfNames');
            if isempty(listOfNames) && isEmpty(this.getInputPortData('SelectedVariableResourceSet'))
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
            selectedVariable = this.getInputPortData('SelectedVariableResourceSet');

            if ~isempty(selectedVariable.elementNames)
                n = length(selectedVariable.getElements());
                listOfNames= {};
                for i= 1:n
                    selectedTable = selectedVariable.elements{i};
                    rowNames = selectedTable.rowNames;
                    listOfNames(i,:)= rowNames;
                end
                listOfNames = reshape(listOfNames, 1, []);
            end
            
            
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
