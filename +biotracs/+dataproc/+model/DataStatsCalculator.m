%"""
%biotracs.dataproc.model.DataStatsCalculator
%DataStatsCalculator process allows computing basic stats on a DataMatrix (mean, standard deviation)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.dataproc.model.DataStatsCalculatorConfig
%"""

classdef DataStatsCalculator < biotracs.core.mvc.model.Process
    
    properties(Constant)
    end
 
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataStatsCalculator()
            %#function biotracs.dataproc.model.DataStatsCalculatorConfig biotracs.data.model.DataMatrix biotracs.core.mvc.model.ResourceSet
            
            this@biotracs.core.mvc.model.Process();
            
            %define input and output specs
            this.setInputSpecs({...
                struct(...
                    'name', 'DataMatrix',...
                    'class', 'biotracs.data.model.DataMatrix' ...
                )...
            });
        
            this.setOutputSpecs({...
                struct(...
                    'name', 'Statistics',...
                    'class', 'biotracs.core.mvc.model.ResourceSet' ...
                )...
            });
        end

        %-- G --

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function doRun( this )
            dataMatrix = this.getInputPortData('DataMatrix');
            if hasEmptyData(dataMatrix)
                error('Input data is empty');
            end
            direction = this.config.getParamValue('Direction');
            m = mean(dataMatrix, 'Direction', direction);
            sd = std(dataMatrix, 'Direction', direction);
            cv = varcoef(dataMatrix, 'Direction', direction);
            if strcmp(direction, 'column')
                statMatrix = vertcat( m, sd, cv );
            else
                statMatrix = horzcat( m, sd, cv );
            end 
            result = this.getOutputPortData('Statistics');
            result.set('StatsMatrix', statMatrix);
        end
        
    end

end
