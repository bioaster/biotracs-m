%"""
%biotracs.dataproc.model.DataSelectorConfig
%Configuration of DataSelector process
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.dataproc.model.DataSelector
%"""

classdef DataSelectorConfig < biotracs.core.mvc.model.ProcessConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataSelectorConfig()
            this@biotracs.core.mvc.model.ProcessConfig();
            this.createParam( 'SelectOrRemove', 'select', ...
                'Constraint', biotracs.core.constraint.IsInSet({'select', 'remove'}), ...
                'Description', 'Which kind of selection on the Data, select or remove' );
            this.createParam( 'Direction', 'row', ...
                'Constraint', biotracs.core.constraint.IsInSet({'row', 'column'}), ...
                'Description', 'Directions of selection of the Data, rows or columns');
            this.createParam( 'ListOfNames', {}, ...
                'Constraint', biotracs.core.constraint.IsText('IsScalar', false), ...
                'Description', 'Names of the columns or rows to select or remove' ...
                );
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
    end
    
end
