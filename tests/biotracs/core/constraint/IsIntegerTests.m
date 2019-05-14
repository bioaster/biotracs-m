classdef IsIntegerTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)

        function testMain(testCase)
           c = biotracs.core.constraint.IsInteger();
           
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
        end
        
    end
    
end
