%"""
%biotracs.dataproc.model.ResponseDataCreator
%ResponseDataCreator process allows creating a boolean Y response (output) in a DataSet (for classification) using row names patterns.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.dataproc.model.ResponseDataCreatorConfig
%"""

classdef ResponseDataCreator < biotracs.core.mvc.model.Process
    
    properties(Constant)
    end
    
    properties(Access = private)
        indexesOfColumnsTaggedAsResponses = {};
        rowNamesPatterns = {};
    end
    
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = ResponseDataCreator()
            %#function biotracs.dataproc.model.ResponseDataCreatorConfig biotracs.data.model.DataSet
            
            this@biotracs.core.mvc.model.Process();
            
            % define input and output specs
            this.addInputSpecs({...
                struct(...
                'name', 'DataSet',...
                'class', 'biotracs.data.model.DataSet' ...
                )...
                });
            % define input and output specs
            this.addOutputSpecs({...
                struct(...
                'name', 'DataSet',...
                'class', 'biotracs.data.model.DataSet' ...
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
            if ~isempty(this.config.getParamValue('ResponseNames')) && ...
                    this.config.getParamValue('CreateBooleanReponses')
                error('SPECTRA:REsponseDataCreator:InvalidConfig', 'Only parameter ''ResponseNames'' or ''CreateBooleanReponses'' is allowed.');
            end
            
            this.indexesOfColumnsTaggedAsResponses = {};
            names = this.config.getParamValue('ResponseNames');
            dataSet = this.getInputPortData('DataSet');
            if ~isempty(names)
                if this.config.getParamValue('StrictRegExp')
                    names = strcat('(^', names, '$)');
                else
                    names = strcat('(', names, ')');
                end
                this.indexesOfColumnsTaggedAsResponses = dataSet.getColumnIndexesByName( strjoin(names,'|') );
            end

            this.rowNamesPatterns = {};
            if ~isempty( this.config.getParamValue('RowNamePatterns') )
                this.rowNamesPatterns = this.config.getParamValue('RowNamePatterns');
            else
                this.rowNamesPatterns = dataSet.getRowNamePatterns();
            end
            
            hasToCreateOrTagResponses = ...
                ~isempty(this.indexesOfColumnsTaggedAsResponses) || ...
                (this.config.getParamValue('CreateBooleanReponses') && ~isempty(this.rowNamesPatterns));
            
            this.setIsPhantom( ~hasToCreateOrTagResponses );
        end
        
        function doRun( this )
            dataSet = this.getInputPortData('DataSet');
            outputDataSet = dataSet.copy();
            %outputDataSet = dataSet.copy('IgnoreProcess', true);
            if ~isempty(this.indexesOfColumnsTaggedAsResponses)         
                outputDataSet.setOutputIndexes( this.indexesOfColumnsTaggedAsResponses );
            elseif this.config.getParamValue('CreateBooleanReponses')
                outputDataSet.setRowNamePatterns( this.rowNamesPatterns );
                outputDataSet = outputDataSet.createXYDataSet();
            end
            this.setOutputPortData('DataSet', outputDataSet);
        end
        
    end
end
