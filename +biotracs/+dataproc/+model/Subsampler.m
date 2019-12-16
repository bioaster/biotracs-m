%"""
%biotracs.dataproc.model.Subsampler
%Subsampler process allows selecting a subpart of a DataMatrix (along columns or rows) according the sub-sampling ratio. Only first columns/rows are selected.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.dataproc.model.SubsamplerConfig, biotracs.data.model.DataMatrix
%"""

classdef Subsampler < biotracs.core.mvc.model.Process
    
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
        function this = Subsampler()
            %#function biotracs.dataproc.model.SubsamplerConfig biotracs.data.model.DataMatrix
            
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
			iSubsamplingDeactived = isempty(this.config.getParamValue('SubsamplingRatio'))...
                || this.config.getParamValue('SubsamplingRatio') == 0;
				
            this.setIsPhantom( iSubsamplingDeactived );
        end
        
        function doRun( this )
            dataMatrix = this.getInputPortData('DataMatrix');
            direction = this.config.getParamValue('Direction');
            grpSchema = this.config.getParamValue('GroupingSchema');
            ratio = this.config.getParamValue('SubsamplingRatio');
            
            if strcmp(direction,'row')
                labels = dataMatrix.getRowNames();
                m = dataMatrix.getNbRows();
            else
                labels = dataMatrix.getColumnNames();
                m = dataMatrix.getColumnRows();
            end
            
            if ~isempty(grpSchema)
                grpStrat = biotracs.data.helper.GroupStrategy(labels, {grpSchema});
                [logIdx, sliceNames] = grpStrat.getSlicesIndexes();
                selectedIdx = [];
                for i=1:length(sliceNames)
                    idx = find(logIdx(:,i))';
                    selectedIdx = [selectedIdx,  randSubselect(idx)];
                end
                selectedIdx = sort(selectedIdx);
            else
                idx = 1:m;
                selectedIdx = randSubselect(idx);
            end
            
            if strcmp(direction,'row')
                subsampledDataMatrix = dataMatrix.selectByRowIndexes(selectedIdx);
            else
                subsampledDataMatrix = dataMatrix.selectByColumnIndexes(selectedIdx);
            end
            
            this.setOutputPortData('DataMatrix', subsampledDataMatrix);
            
            function selectedIdx = randSubselect(idx)
                n = length(idx);
                selectedIdx = idx(randperm(n));
                selectedIdx = sort(selectedIdx(1:fix(n*ratio)));
            end
        end

    end
end
