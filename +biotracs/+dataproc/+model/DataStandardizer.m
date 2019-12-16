%"""
%biotracs.dataproc.model.DataStandardizer
%DataStandardizer process allows standardizing DataMatrix rows or columns using centering/scaling standardization
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.dataproc.model.DataStandardizerConfig, biotracs.dataproc.model.DataNormalizer
%"""

classdef DataStandardizer < biotracs.core.mvc.model.Process
    
    properties(Constant)
    end
 
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataStandardizer()
            %#function biotracs.dataproc.model.DataStandardizerConfig biotracs.data.model.DataMatrix
            
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
                    'name', 'DataMatrix',...
                    'class', 'biotracs.data.model.DataMatrix' ...
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
            inputData = this.getInputPortData('DataMatrix');
            dataValues = inputData.data;

            if isempty(dataValues)
                error('SPECTRA:DataProc:DataStandardizer', 'No input data found');
            end
            
            dataValues = biotracs.math.centerscale( ...
                dataValues, [], ...
                'Center' , this.config.getParamValue('Center'), ...
                'Scale', this.config.getParamValue('Scale'), ...
                'Direction', this.config.getParamValue('Direction') ...
            );
        
            stdData = this.getOutputPortData('DataMatrix');
            stdData.setData(dataValues);
            if strcmpi( this.config.getParamValue('Direction'), 'row' )
                stdData.setRowNames( inputData.getRowNames() );
            else
                stdData.setColumnNames( inputData.getColumnNames() );
            end
        end
        
    end

end
