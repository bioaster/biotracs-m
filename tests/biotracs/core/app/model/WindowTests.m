classdef WindowTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    methods (Test)
        
        function testWindow( testCase )
            w = biotracs.core.app.model.Window();
            
            %create button with onclick
            w.createButton('String', 'Button#1 in App', ...
                'OnClick', @testCase.onButtonClick);
            
            %create button & set position
            button2 = w.createButton('String', 'Button#2 in App');
            button2.setPosition( [ 10+50, 10+50, 100, 50 ] );
            
            %create text
            w.createText('String', 'Coucou cest moi');
            
            %create input
            w.createInput('String', '10', 'Max', 10,'Position', [ 500, 100, 100, 50 ]);
            
            %create radio
            buttongroup = w.createButtonGroup('Position', [ 500, 200, 300, 200 ]);
            buttongroup.createRadio( 'String', 'test', 'Position', [ 10+50, 10+50, 100, 50 ]);
            buttongroup.createRadio( 'String', 'test2', 'Position', [ 10+100, 10+50, 100, 50 ]);
            
            %create panel
            panel = w.createPanel('Position', [ 10+100, 50+100, 300, 200 ]);
            panel.createButton(...
                'String', 'Button#1 in Panel',...
                'Position', [ 10, 10, 100, 50 ], ...
                'OnClick', @testCase.onButtonClick);
            
            w.view('Gui');
        end
        
    end
    
    
    methods
        
        function onButtonClick( ~, source, event )
            disp('You have clicked on the button');
            source.Value
            source.String
        end
        
    end
    
end
