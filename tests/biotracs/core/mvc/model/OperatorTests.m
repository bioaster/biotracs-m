classdef OperatorTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)
        function testDefaultConstructor(testCase)
            import biotracs.core.mvc.model.*;
            Op = Operator();
            testCase.verifyClass(Op, 'biotracs.core.mvc.model.Operator');
            testCase.verifyEqual(Op.firstName, '');
            testCase.verifyEqual(Op.lastName, '');
            testCase.verifyEqual(Op.email, '');
            testCase.verifyEqual(Op.profession, '');
        end
        
        
        function testConstructorWithAttributes(testCase)
            import biotracs.core.mvc.model.*;
            Op = Operator( 'John', 'Smith', 'js@bioaster.org', {'biochemist'} );
            testCase.verifyClass(Op, 'biotracs.core.mvc.model.Operator');
            testCase.verifyEqual(Op.firstName, 'John');
            testCase.verifyEqual(Op.lastName, 'Smith');
            testCase.verifyEqual(Op.email, 'js@bioaster.org');
            testCase.verifyEqual(Op.profession, {'biochemist'});
        end
        
    end
    
end
