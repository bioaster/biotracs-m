%"""
%biotracs.core.mvc.view.BaseObject
%BaseObject view object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.mvc.model.BaseObject
%"""

classdef BaseObject <  biotracs.core.mvc.view.View
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function this = BaseObject( varargin )
            this@biotracs.core.mvc.view.View( varargin{:} );
        end
    end
    
    methods(Access = protected)
        
        function h = doPrepareFigure( ~, varargin )
            p = inputParser();
            p.addParameter('NewFigure',true,@islogical);
            p.addParameter('SubPlot',{1,1,1},@iscell);
            p.KeepUnmatched = true;
            p.parse(varargin{:});

            if p.Results.NewFigure
                h = figure();
                if ~isempty(p.Results.SubPlot)
                    subplot(p.Results.SubPlot{1}, p.Results.SubPlot{2}, p.Results.SubPlot{3});
                end
            else
                h = gcf; hold on;
                if ~isempty(p.Results.SubPlot)
                    subplot(p.Results.SubPlot{1}, p.Results.SubPlot{2}, p.Results.SubPlot{3});
                end
            end
        end

    end
end

