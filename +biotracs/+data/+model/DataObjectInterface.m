%"""
%biotracs.data.model.DataObjectInterface
%DataObject interface
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.data.model.DataObject
%"""

classdef (Abstract) DataObjectInterface < handle
    
    properties(SetAccess = protected)
    end
    
    properties(SetAccess = protected)
    end
    
    properties(Dependent = true)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataObjectInterface()
        end
        
        %-- G --
    end
    
    % -------------------------------------------------------
    % Abstract interfaces
    % -------------------------------------------------------
    
    methods( Abstract )
        
        getData( this );
        this = setData( this, iData );
        
    end

end
