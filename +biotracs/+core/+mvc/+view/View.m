%"""
%biotracs.core.mvc.view.View
%Defines the View object.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.mvc.model.Model, biotracs.core.mvc.controller.Controller
%"""

classdef (Abstract) View < biotracs.core.helper.Helper

    properties( SetAccess = protected, Dependent = true )
        model;
    end
    
    methods
        
        % Constructor
        %> @param[in] iModelToView [optional] Model to view
        function this = View( varargin )
            this@biotracs.core.helper.Helper( varargin{:} );
        end
        
        %-- G --
        
        function oModel = get.model(this)
            oModel = this.getHelpable();
        end
        
        function oModel = getModel(this)
            oModel = this.getHelpable();
        end
        
        %-- S --
        
        function this = setModel( this, iModel )
            if ~isa(iModel, 'biotracs.core.mvc.model.BaseObject')
                error('Invalid model, A ''biotracs.core.mvc.model.BaseObject'' is required')
            end
            this.setHelpable(iModel);
        end
        
        function this = setHelpable( this, iHelpable )
            this.setHelpable@biotracs.core.helper.Helper(iHelpable);
        end

    end
    
end

