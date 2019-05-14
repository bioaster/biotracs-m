%"""
%biotracs.core.ability.Trackable
%Base class to handle Viewable object. A Viewable is an object that can be
%viewed, i.e that is associated with a View. A Model is a Viewable.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.logger.Logger
%"""

classdef (Abstract) Viewable < biotracs.core.ability.Helpable
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
        
    end
    
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Viewable()
            this@biotracs.core.ability.Helpable();
            this.helperCallingWord = 'view';
        end
        
        %-- B --

        % Bind a view instance to this Viewable object
        %> @param[in] iView The view to bind
        %> @return this
        function this = bindView( this, iView )
            this.bindHelper( iView );
        end
        
        %-- C --

        %-- G --
        
        function oView = getView( this )
            oView = this.getHelper();
        end
        
        %-- S --
        
        function h = view( this, iMethodSuffix, varargin )
            method = [this.helperCallingWord, iMethodSuffix];
            h = feval( ...
                method, ...
                this.getView(), ...
                varargin{:} ...
            );
        
            p = inputParser();
            p.addParameter('SavePath','',@(x)(sichar(x) && ~isempty(x)));
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            if ~isempty(p.Results.SavePath)
                this.getView().save(h);
            end
        end
        
    end
    
    methods(Access = protected)

    end
    
    methods(Static)
    end
    
end
