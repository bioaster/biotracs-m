%"""
%biotracs.dataproc.model.DataNormalizerConfig
%Configuration of DataNormalizer process.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.dataproc.model.DataNormalizer
%"""

classdef DataNormalizerConfig < biotracs.core.mvc.model.ProcessConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataNormalizerConfig()
			this@biotracs.core.mvc.model.ProcessConfig();
            this.createParam( 'Method', 'snv',  'Constraint', biotracs.core.constraint.IsInSet({'quantile', 'snv'}), 'Description', 'Normalization method. snv is stantard normal variate normalization, i.e. center and reduce data. Default = snv' );            
            this.createParam( 'Direction', 'column',  'Constraint', biotracs.core.constraint.IsInSet({'row', 'column'}), 'Description', 'Set row (or column) to normalize along row or column respectively. Default = column.' );            
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
    end
    
end
