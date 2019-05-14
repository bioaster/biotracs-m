%"""
%biotracs.dataproc.model.ResponseDataCreatorConfig
%Configuration of ResponseDataCreator process
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.dataproc.model.ResponseDataCreator
%"""

classdef ResponseDataCreatorConfig < biotracs.core.mvc.model.ProcessConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = ResponseDataCreatorConfig( )
            this@biotracs.core.mvc.model.ProcessConfig( );
            this.createParam( ...
                'ResponseNames', [],  ...
                'Constraint', biotracs.core.constraint.IsText('IsScalar', false), ...
                'Description', 'The names of the columns of the input DataSet that must be tagged as response variables. Regular expression are used allowed. Restriction: Parameter ''ResponseNames'' cannot be used with parameter ''CreateBooleanReponses''' ...
                );
            this.createParam( ...
                'StrictRegExp', true,  ...
                'Constraint', biotracs.core.constraint.IsBoolean(), ...
                'Description', 'If True, the entire names of the columns are assessed in the regular expressions. Default = True.' ...
                );
            this.createParam( ...
                'CreateBooleanReponses', false,  ...
                'Constraint', biotracs.core.constraint.IsBoolean(), ...
                'Description', 'If True, the RowNamePattenrs are used to generate dummy boolean response variables that are concatenated at the end of the input DataSet. Dummy response variables may be used for discriminant analysis. Restriction: Parameter ''CreateBooleanReponses'' cannot be used with parameter ''ResponseNames''' ...
                );
            this.createParam( ...
                'RowNamePatterns', {},  ...
                'Constraint', biotracs.core.constraint.IsText('IsScalar', false), ...
                'Description', 'If provided, these RowNamePatterns will be used to generate dummy boolean response;' ...
                );
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
    end
    
end
