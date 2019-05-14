%"""
%biotracs.dataproc.model.DataMergerConfig
%Configuration of DataMerger process
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.dataproc.model.DataMerger
%"""

classdef DataMergerConfig < biotracs.core.mvc.model.ProcessConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataMergerConfig()
            this@biotracs.core.mvc.model.ProcessConfig();
            this.createParam( 'Direction', 'row', ...
                'Constraint', biotracs.core.constraint.IsInSet({'column','row'}), ...
                'Description', 'To know if rows (samples) or columns (varaibles) must be merged.' );
            this.createParam( 'Force', false, ...
                'Constraint', biotracs.core.constraint.IsBoolean(), ...
                'Description', 'Merging is only possible if each column (or row) name of each DataTable has a cossponding column (or row) name in the orther DataTable, whatever its position. If Force = true, a column (or row) with no corresponding column (or row) in the others DataTable are discard to force merging.' );
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
    end
    
end
