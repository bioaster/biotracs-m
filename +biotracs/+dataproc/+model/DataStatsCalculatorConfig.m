%"""
%biotracs.dataproc.model.StatsCalculatorConfig
%Configuration of DataStatsCalculator process
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.dataproc.model.DataStatsCalculator
%"""


classdef DataStatsCalculatorConfig < biotracs.core.mvc.model.ProcessConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end

    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataStatsCalculatorConfig()
            this@biotracs.core.mvc.model.ProcessConfig();
            this.createParam(...
                'Direction', 'column', ...
                'Constraint', biotracs.core.constraint.IsInSet({'row','column'}) ...
            );
        end
        
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
    end

end
