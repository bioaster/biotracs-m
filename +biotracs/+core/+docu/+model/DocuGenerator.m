%"""
%biotracs.core.docu.model.DocuGenerator
%Documentation generator. Process that generate DocuSet from source codes.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.docu.model.DocuGeneratorConfig, biotracs.core.docu.model.Docu, biotracs.core.docu.model.DocuSet
%"""

classdef DocuGenerator < biotracs.core.mvc.model.Process

    properties(SetAccess = protected)
    end

    properties(Access = protected)
    end
    
    methods
        
        % Constructor
        function this = DocuGenerator()
            this@biotracs.core.mvc.model.Process() 
            
            % define input and output specs
            this.addInputSpecs({...
                struct(...
                    'name', 'DataFileSet',...
                    'class', 'biotracs.data.model.DataFileSet' ...
                )...
            });
        
            % define input and output specs
            this.addOutputSpecs({...
                struct(...
                    'name', 'DocuSet',...
                    'class', 'biotracs.core.docu.model.DocuSet' ...
                )...
            });
        end
        
    end
    
    methods( Access = protected )

        function doRun( this )
            dataFileSet = this.getInputPortData('DataFileSet');
            docuSet = biotracs.core.docu.model.DocuSet.fromDataFileSet(dataFileSet);
            this.setOutputPortData('DocuSet', docuSet);
        end
        
    end
end

