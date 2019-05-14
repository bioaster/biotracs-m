%"""
%biotracs.core.mvc.model.Session
%Defines the Session object. A Session stored a set of variables that are used by the Controller
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.mvc.controller.Controller
%"""


classdef Session < biotracs.core.container.Set & biotracs.core.mvc.model.BaseObject
    
    properties(Access = protected)
    end

    methods
        
        function this = Session( varargin )
            this@biotracs.core.mvc.model.BaseObject();
            this@biotracs.core.container.Set( varargin{:} );
        end
        
        %-- I --
        
        function tf = isEqualTo( this, iSession, iIsStrict )
            if nargin < 3
                iIsStrict = false;
            end
            tf = this.isEqualTo@biotracs.core.container.Set( iSession, iIsStrict );
        end
        
    end
   
    methods(Access = protected)
        
        function this = doCopy( this, varargin )
            this.doCopy@biotracs.core.mvc.model.BaseObject( varargin{:} );
            this.doCopy@biotracs.core.container.Set( varargin{:} );
        end
        
        %-- A --
        
    end
    
end

