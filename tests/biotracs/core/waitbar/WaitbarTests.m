classdef WaitbarTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    methods (Test)
        
        function testTextWaitbar(testCase)
            w = biotracs.core.waitbar.Waitbar();
            w.show();
            for i=0:0.1:1
                w.show(i);
                pause(0.1);
            end
            
            
            w = biotracs.core.waitbar.Waitbar('Name', 'Saving data');
            %w.show();
            for i=0:0.1:1
                w.show(i);
                pause(0.05);
            end
        end
        
        
        function testGraphicWaitbar(testCase)
            w = biotracs.core.waitbar.Waitbar('Style','graphic');
            w.show();
            for i=0:0.1:1
                w.show(i);
                pause(0.1);
            end
            
            
            w = biotracs.core.waitbar.Waitbar('Style','graphic', 'Name', 'Saving data');
            w.show();
            for i=0:0.1:1
                w.show(i);
                pause(0.05);
            end
        end
        
    end
    
end
