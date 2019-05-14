%"""
%biotracs.core.docu.model.DocuGeneratorConfig
%Configuration of DocuGenerator
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.docu.model.DocuGenerator
%"""

classdef DocuGeneratorConfig < biotracs.core.mvc.model.ProcessConfig

    properties(SetAccess = protected)
        
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        function this = DocuGeneratorConfig()
            this@biotracs.core.mvc.model.ProcessConfig();
            this.createParam( 'LicenseUrl', '', 'Constraint', biotracs.core.constraint.IsText() );
            this.createParam( 'LicenseText', '', 'Constraint', biotracs.core.constraint.IsText() );
        end
    end
    
    methods( Access = protected )

    end
end

