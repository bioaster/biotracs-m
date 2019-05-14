classdef ProjectTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)
        function testDefaultConstructor(testCase)
            import biotracs.core.mvc.model.*;
            Proj = Project();
            testCase.verifyClass(Proj, 'biotracs.core.mvc.model.Project');
            testCase.verifyEqual(Proj.label, 'biotracs.core.mvc.model.Project');
            testCase.verifyEqual(Proj.getClassName(), 'biotracs.core.mvc.model.Project');
        end
        
        function testConstructorWithAttributes(testCase)
            import biotracs.core.mvc.model.*;
            Proj = Project();
            Proj.setLabel('MyProject' );
            testCase.verifyClass(Proj, 'biotracs.core.mvc.model.Project');
            testCase.verifyEqual(Proj.label, 'MyProject');
            testCase.verifyEqual(Proj.getClassName(), 'biotracs.core.mvc.model.Project');
        end
    end
end
