classdef ControllerTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)
        function testDefaultConstructor(testCase)
            controller = biotracs.core.mvc.controller.Controller();
            testCase.verifyClass(controller, 'biotracs.core.mvc.controller.Controller');
        end
    end
    
end
