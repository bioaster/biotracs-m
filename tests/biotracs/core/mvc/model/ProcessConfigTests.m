classdef ProcessConfigTests < matlab.unittest.TestCase

    methods (Test)
        function testDefaultConstructor(testCase)
            config = biotracs.core.mvc.model.ProcessConfig();
            testCase.verifyClass(config, 'biotracs.core.mvc.model.ProcessConfig');
            testCase.verifyEqual(config.description, '');
            testCase.verifyEqual(config.getClassName(), 'biotracs.core.mvc.model.ProcessConfig');
        end
   
    end
    
end
