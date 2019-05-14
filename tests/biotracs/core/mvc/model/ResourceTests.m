classdef ResourceTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)
        function testDefaultConstructor(testCase)
            import biotracs.core.mvc.model.*;
            resource = Resource();
            testCase.verifyClass(resource, 'biotracs.core.mvc.model.Resource');
            testCase.verifyEqual(resource.label, 'biotracs.core.mvc.model.Resource');
            testCase.verifyEqual(resource.description, '');
            testCase.verifyEqual(resource.process, biotracs.core.mvc.model.Process().empty());
        end
        
    end
    
end
