%"""
%biotracs.dataproc.model.DataFilterConfig
%Configuration of DataFilter process
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.dataproc.model.DataFilter
%"""

classdef DataFilterConfig < biotracs.core.mvc.model.ProcessConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataFilterConfig()
            this@biotracs.core.mvc.model.ProcessConfig();
            this.createParam( 'Direction', 'column', ...
                'Constraint', biotracs.core.constraint.IsInSet({'column','row'}), ...
                'Description', 'To know if rows (samples) or columns (varaibles) must be filtered. Default value is ''column''.' );
            this.createParam( 'MinAverage', -Inf, ...
                'Constraint', biotracs.core.constraint.IsNumeric(), ...
                'Description', 'Depending on the ''Direction'', rows or columns of which the average values are strictly less than this value are discarded. Default is -Inf, i.e. this filter has no effect.');
            this.createParam( 'MinValue', -Inf, ...
                'Constraint', biotracs.core.constraint.IsNumeric(), ...
                'Description', 'Depending on the ''Direction'', rows or columns of which all the individual values (e.g. a limit of quantitiation) are strictly less than this value are discarded. Default is -Inf, i.e. this filter has no effect.');
            this.createParam( 'MinStandardDeviation', -1, ...
                'Constraint', biotracs.core.constraint.IsNumeric(), ...
                'Description', 'Depending on the ''Direction'', rows or columns of which the standard deviations are strictly less than this value are discarded. Set 0 to remove all rows or columns that are strictly constant. If a negative value is given, this filter will have no effect. Default is -1.');
            this.createParam( 'ListOfNamesToIgnore', {}, ...
                'Constraint', biotracs.core.constraint.IsText('IsScalar', false), ...
                'Description', 'Names of columns or rows to ignore');
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
    end
    
end
