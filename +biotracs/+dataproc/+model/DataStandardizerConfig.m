%"""
%biotracs.dataproc.model.DataStandardizerConfig
%Configuration of DataStandardizer process.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.dataproc.model.DataStandardizer
%"""

classdef DataStandardizerConfig < biotracs.core.mvc.model.ProcessConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end

    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataStandardizerConfig()
            this@biotracs.core.mvc.model.ProcessConfig();
            this.createParam( 'Center', true,  'Constraint', biotracs.core.constraint.IsBoolean() );
            this.createParam( 'Scale', 'uv', 'Constraint', biotracs.core.constraint.IsInSet({'uv','pareto','none'}) );
            this.createParam( 'Direction', 'column', 'Constraint', biotracs.core.constraint.IsInSet({'row','column'}) );
        end
        
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
    end

end
