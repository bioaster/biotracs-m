%"""
%biotracs.dataproc.model.DataXSelector
%DataXSelector process allows selecting the X input data in a DataSet. Generally used before machine learning block that do not require Y output data (for unsupervised analysis)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.data.model.DataSet, biotracs.dataproc.model.Subsampler
%"""

classdef DataXSelector < biotracs.core.mvc.model.Process
    
    properties(Constant)
    end
    
    properties(Dependent)
    end
    
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataXSelector()
            this@biotracs.core.mvc.model.Process();
            
            % define input and output specs
            this.addInputSpecs({...
                struct(...
                'name', 'DataSet',...
                'class', 'biotracs.data.model.DataSet' ...
                )...
                });
            
            % define input and output specs
            this.addOutputSpecs({...
                struct(...
                'name', 'DataSet',...
                'class', 'biotracs.data.model.DataSet' ...
                )...
                });
        end
        
    end
    
    % -------------------------------------------------------
    % Private methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function doBeforeRun( this )
            this.doBeforeRun@biotracs.core.mvc.model.Process();
            dataSet = this.getInputPortData('DataSet');
            this.setIsPhantom( ~dataSet.hasResponses() || dataSet.hasEmptyData() );
        end
        
        function doRun( this )
            dataSet = this.getInputPortData('DataSet');
            this.setOutputPortData('DataSet', dataSet.selectXSet());
        end
    end
    
end
