classdef IsNumericTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)

        function testMain(testCase)
           c = biotracs.core.constraint.IsNumeric();
           
           testCase.verifyTrue( c.isValid(1) );
           testCase.verifyTrue( c.isValid(-1.2) );
           testCase.verifyTrue( c.isValid(pi) );
           testCase.verifyFalse( c.isValid([1, pi]) );
           testCase.verifyFalse( c.isValid(true) );
           testCase.verifyFalse( c.isValid('NY') );
           testCase.verifyFalse( c.isValid({1,2}) );
        end
    
        function testWithType(testCase)
           c = biotracs.core.constraint.IsNumeric('Type','integer');
           
           testCase.verifyTrue( c.isValid(1) );
           testCase.verifyTrue( c.isValid(3.00) );
           testCase.verifyTrue( c.isValid(-4.00) );
           testCase.verifyFalse( c.isValid([-4.00, 3]) );
           testCase.verifyFalse( c.isValid(-1.2) );
           testCase.verifyFalse( c.isValid(pi) );
           testCase.verifyFalse( c.isValid([1, pi]) );
           testCase.verifyFalse( c.isValid(true) );
           testCase.verifyFalse( c.isValid([true, false]) );
           testCase.verifyFalse( c.isValid('NY') );
           testCase.verifyFalse( c.isValid({1,2}) );
           
           testCase.verifyEqual(c.summary(), 'biotracs.core.constraint.IsNumeric({"isScalar":true,"type":"integer"})');
        end
        
        function testWithTypeAndNotScalar(testCase)
           c = biotracs.core.constraint.IsNumeric('Type','integer', 'IsScalar', false);
           
           testCase.verifyTrue( c.isValid(1) );
           testCase.verifyTrue( c.isValid(3.00) );
           testCase.verifyTrue( c.isValid(-4.00) );
           testCase.verifyTrue( c.isValid([-4.00, 3]) );
           
           testCase.verifyFalse( c.isValid([-4.00, 3.5]) );
           testCase.verifyFalse( c.isValid(-1.2) );
           testCase.verifyFalse( c.isValid(pi) );
           testCase.verifyFalse( c.isValid([1, pi]) );
           testCase.verifyFalse( c.isValid(true) );
           testCase.verifyFalse( c.isValid([true, false]) );
           testCase.verifyFalse( c.isValid('NY') );
           testCase.verifyFalse( c.isValid({1,2}) );
           
           testCase.verifyEqual(c.summary(), 'biotracs.core.constraint.IsNumeric({"isScalar":false,"type":"integer"})');
        end
        
    end
    
end
