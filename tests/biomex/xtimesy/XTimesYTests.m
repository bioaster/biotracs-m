classdef XTimesYTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)

        function testXtimesY(testCase)
            z = biomex.xtimesy.xtimesy(3, [1 2 3; 1 2 4]);
            
            testCase.verifyEqual(z, [1 2 3; 1 2 4] * 3);
        end
        
    end
    
end
