%"""
%biotracs.core.mvc.model.Model
%Defines the Model object. A model is associated to a View object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.mvc.view.View, biotracs.core.mvc.controller.Controller
%"""

classdef Model < biotracs.core.ability.Viewable
    
    properties (Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Model( varargin )
            this@biotracs.core.ability.Viewable( varargin{:} );
        end

        function tf = isEqualTo( this, iResource, isStrict ) %#ok<STOUT,INUSD>
            error('BIOTRACS:Model:NotPossible', 'comparison of non-specialized models is not yet possible');
        end
        
    end
    
    methods(Access = protected)
           
    end
    
end

