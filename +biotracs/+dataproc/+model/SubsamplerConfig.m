%"""
%biotracs.dataproc.model.SubsamplerConfig
%Configuration of Subsampler process.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.dataproc.model.Subsampler
%"""

classdef SubsamplerConfig < biotracs.core.mvc.model.ProcessConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = SubsamplerConfig()
            this@biotracs.core.mvc.model.ProcessConfig();
            this.createParam( 'Direction', 'row', ...
                'Constraint', biotracs.core.constraint.IsInSet({'column','row'}), ...
                'Description', 'To know if rows (samples) or columns (variables) must be filtered. Default value is ''row''.' );
            this.createParam( 'SubsamplingRatio', [], ...
                'Constraint', biotracs.core.constraint.IsBetween([0,1], 'StrictLowerBound', true, 'StrictUpperBound', true), ...
                'Description', 'The SubsamplingRatio = size(final data after subsampling)/size(initial data). The size is computed in the given Direction.');
            this.createParam( 'GroupingSchema', {}, ...
                'Constraint', biotracs.core.constraint.IsText(), ...
                'Description', 'If provided, the subsampling is performed while preserving the relative group sizes along this GroupingSchema');
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
    end
    
end
