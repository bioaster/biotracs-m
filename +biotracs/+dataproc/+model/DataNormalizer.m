%"""
%biotracs.dataproc.model.DataNormalizer
%DataNormalizer process allows normalizing DataMatrix along rows or columns using `quantile` or `snv` normalization. To learn more about snv normalization, please see http://wiki.eigenvector.com/index.php?title=Advanced_Preprocessing:_Sample_Normalization
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.dataproc.model.DataNormalizerConfig, biotracs.dataproc.model.DataStandardizer
%"""

classdef DataNormalizer < biotracs.core.mvc.model.Process
    
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
        function this = DataNormalizer()
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
        
        function doRun( this )
            dataSet = this.getInputPortData('DataMatrix');
            
            method = this.config.getParamValue('Method');
            direction = this.config.getParamValue('Direction');
            
            if strcmp(direction,'column')
                k = 1;
            else
                k = 2;
            end
                
            if strcmp(method, 'quantile')
                if strcmp(direction,'column')
                    normalizedData = quantilenorm( dataSet.data );
                else
                    normalizedData = quantilenorm( transpose(dataSet.data) );
                    normalizedData = transpose(normalizedData);
                end
            elseif strcmp(method, 'snv')
                %http://wiki.eigenvector.com/index.php?title=Advanced_Preprocessing:_Sample_Normalization
                %Avoid over-normalization using the pre-computed factor delta = min_non_zero_std * 1e-3
                meanData = mean(dataSet.data,k);
                stdData = std(dataSet.data,0,k);
                idxOfZeros = (stdData == 0);
                if any(idxOfZeros)
                    %delta = min( stdData(~idxOfZeros) ) * 1e-3;
                    %stdData = stdData + delta;  
                end
                
                %normalize
                normalizedData =  biotracs.math.centerscale( ...
                    dataSet.data, {meanData, stdData}, ...
                    'Center', true, ...
                    'Scale', 'uv', ...
                    'Direction', direction ...
                    );
            else
                errro('Wrong method');
            end
            
            normalizedDataSet = dataSet.copy();
            normalizedDataSet.setData( normalizedData, false );
            this.setOutputPortData('DataMatrix', normalizedDataSet);
        end
    end
end