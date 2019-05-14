%"""
%biotracs.core.app.model.Choice
%Graphical clickable user choice button (exclusive choices)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See biotracs.core.app.view.Choice
%"""

classdef Choice < biotracs.core.app.model.Panel
    
    properties(SetAccess = protected)
        choice;
        change;
    end
    
    events
    end
    
    methods
        
        
        function this = Choice( varargin )
            this@biotracs.core.app.model.Panel( varargin{:} );
            this.bindView( biotracs.core.app.view.Panel() );
        end
        
        function choice = radioButton (varargin)
            choice.bindView( biotracs.core.app.view.Choice() );
            
            p = inputParser();
            p.addParameter('Style', 'radiobutton');
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            %
            if isempty(choice.position)
                choice.position = [ 10, 10, 100, 50 ];
            end
            %
            
        end
        
        function choice = dropDownMenu (varargin)
            choice.bindView( biotracs.core.app.view.Choice() );
            
            p = inputParser();
            p.addParameter('Style', 'popupmenu');
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            %
            if isempty(choice.position)
                choice.position = [ 10, 10, 100, 50 ];
            end 
            
        end

    end
    
end