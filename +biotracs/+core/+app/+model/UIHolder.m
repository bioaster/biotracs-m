%"""
%biotracs.core.app.model.UIHolder
%Base graphical user interface holder. A UIHolder is Gui that is able to
%contain Control objects
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See biotracs.core.app.view.Text
%"""

classdef(Abstract) UIHolder < biotracs.core.app.model.Gui
    
    properties(SetAccess = protected)
        draggingObject;
        mousePosition;
    end
    
    methods
        
        function this = UIHolder( varargin )
            this@biotracs.core.app.model.Gui( varargin{:} );
            %this.bindView( biotracs.core.app.view.UIHolder() );
            if isempty(this.position)
                scrsz = get(groot,'ScreenSize');
                this.position = [scrsz(3)/4 scrsz(4)/4 scrsz(3)/2 scrsz(4)/2];
            end
            
            if isempty(this.units)
                this.units = 'pixels';
            end
        end
        
        %-- C --
        
        function ui = createPanel( this, varargin )
            p = inputParser();
            p.addParameter('Name', 'MyPanel', @ischar);
            p.addParameter('Position', [], @isnumeric);
            p.KeepUnmatched = true;
            p.parse( varargin{:} )
            
            ui = biotracs.core.app.model.Panel( ...
                'Parent', this, ...
                'Position', p.Results.Position );
        end
        function ui = createButtonGroup( this, varargin )
            p = inputParser();
            p.addParameter('Name', 'MyButtonGroup', @ischar);
            p.addParameter('Position', [], @isnumeric);
            p.KeepUnmatched = true;
            p.parse( varargin{:} )
            
            ui = biotracs.core.app.model.ButtonGroup( ...
                'Parent', this, ...
                'Position', p.Results.Position );
        end
        function ui = createButton( this, varargin )
            p = inputParser();
            p.addParameter('Name', 'MyButton', @ischar);
            p.addParameter('Position', [], @isnumeric);
            p.addParameter('String', 'MyUserText', @ischar);
            p.addParameter('OnClick', @(x,s,e)([]), @(x)isa(x,'function_handle'));
            p.KeepUnmatched = true;
            p.parse( varargin{:} )
            
            ui = biotracs.core.app.model.Button( ...
                'Parent', this, ...
                'Position', p.Results.Position, ...
                'String', p.Results.String, ...
                'OnClick', p.Results.OnClick);
        end
        
        function ui = createPopup( this, varargin )
            p = inputParser();
            p.addParameter('Name', 'MyButton', @ischar);
            p.addParameter('Position', [], @isnumeric);
            p.addParameter('String', 'MyUserText', @ischar);
            p.KeepUnmatched = true;
            p.parse( varargin{:} )
            
            ui = biotracs.core.app.model.Popup( ...
                'Parent', this, ...
                'Position', p.Results.Position, ...
                'String', p.Results.String);
        end
        
        function ui = createText( this, varargin )
            p = inputParser();
            p.addParameter('Name', 'MyText', @ischar);
            p.addParameter('Position', [], @isnumeric);
            p.addParameter('String', 'MyUserText', @ischar);
            p.KeepUnmatched = true;
            p.parse( varargin{:} )
            
            ui = biotracs.core.app.model.Text( ...
                'Parent', this, ...
                'Position', p.Results.Position, ...
                'String', p.Results.String);
        end
        
        function ui = createInput( this, varargin )
            p = inputParser();
            p.addParameter('Name', 'EditText', @ischar);
            p.addParameter('Position', [], @isnumeric);
            p.addParameter('String', 'MyUserInput', @ischar);
            p.addParameter('Max', 2, @isnumeric);
            p.KeepUnmatched = true;
            p.parse( varargin{:} )
            
            ui = biotracs.core.app.model.Input( ...
                'Parent', this, ...
                'Position', p.Results.Position, ...
                'String', p.Results.String,...
                'Max', p.Results.Max);
        end
        
        function ui = createRadio( this, varargin )
            p = inputParser();
            p.addParameter('Name', 'RadioButton', @ischar);
            p.addParameter('Position', [], @isnumeric);
            p.addParameter('String', 'MyUserText', @ischar);
            
            p.KeepUnmatched = true;
            p.parse( varargin{:} )
            
            ui = biotracs.core.app.model.Radio( ...
                'Parent', this, ...
                'Position', p.Results.Position, ...
                'String', p.Results.String);
        end
        
        function ui = createDropDownMenu( this, varargin )
            p = inputParser();
            p.addParameter('Name', 'DropDownMenu', @ischar);
            p.addParameter('Position', [], @isnumeric);
            p.addParameter('String', 'MyUserText', @ischar);
            
            p.KeepUnmatched = true;
            p.parse( varargin{:} )
            
            ui = biotracs.core.app.model.DropDownMenu( ...
                'Parent', this, ...
                'Position', p.Results.Position, ...
                'String', p.Results.String);
        end
        
        function ui = createCheckBox( this, varargin )
            p = inputParser();
            p.addParameter('Name', 'CheckBox', @ischar);
            p.addParameter('Position', [], @isnumeric);
            p.addParameter('String', 'MyUserText', @ischar);
            
            p.KeepUnmatched = true;
            p.parse( varargin{:} )
            
            ui = biotracs.core.app.model.CheckBox( ...
                'Parent', this, ...
                'Position', p.Results.Position, ...
                'String', p.Results.String);
        end
        
        function ui = createListBox( this, varargin )
            p = inputParser();
            p.addParameter('Name', 'ListBox', @ischar);
            p.addParameter('Position', [], @isnumeric);
            p.addParameter('String', 'MyUserText', @ischar);
            
            p.KeepUnmatched = true;
            p.parse( varargin{:} )
            
            ui = biotracs.core.app.model.ListBox( ...
                'Parent', this, ...
                'Position', p.Results.Position, ...
                'String', p.Results.String);
        end
        
        %-- H --
        
        function h = height( this )
            h = this.position(4);
        end
        
        %-- L --
        
        function l = left( this )
            l = this.position(1);
        end
        
        %-- O --
        
        %-- R --
        
        function b = bottom( this )
            b = this.position(2);
        end
        
        %-- W --
        
        function w = width( this )
            w = this.position(3);
        end
        
    end
    
end