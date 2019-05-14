%"""
%biotracs.data.model.DataMatrixInterface
%DataMatrix interface
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.data.model.DataMatrix
%"""

classdef (Abstract) DataMatrixInterface < biotracs.data.model.DataTableInterface
    
    properties(SetAccess = protected)
    end
    
    properties(Dependent = true)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataMatrixInterface()
            this@biotracs.data.model.DataTableInterface();
        end
        
    end
    
    
    % -------------------------------------------------------
    % Abstract interfaces
    % -------------------------------------------------------
    
    methods( Abstract )

    end
    
end
