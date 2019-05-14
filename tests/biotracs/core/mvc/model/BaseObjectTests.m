classdef BaseObjectTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)
        function testDefaultConstructor(testCase)
            import biotracs.core.mvc.model.*;
            BO = BaseObject();
            testCase.verifyClass(BO, 'biotracs.core.mvc.model.BaseObject');
            testCase.verifyEqual(BO.label, 'biotracs.core.mvc.model.BaseObject');
            testCase.verifyEqual(BO.description, '');
            testCase.verifyEqual(BO.getClassName(), 'biotracs.core.mvc.model.BaseObject');
        end

        function testAccessors(testCase)
            import biotracs.core.mvc.model.*;
            BO = BaseObject();
			BO.setLabel('bo')...
				.setDescription('This is a test');
            testCase.verifyClass(BO, 'biotracs.core.mvc.model.BaseObject');
            testCase.verifyEqual(BO.label, 'bo');
            testCase.verifyEqual(BO.description, 'This is a test');
            testCase.verifyEqual(BO.getClassName(), 'biotracs.core.mvc.model.BaseObject');
        end
        

    end
    
end
