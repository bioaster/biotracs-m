classdef IsBooleanTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)

        function testMain(testCase)
           c = biotracs.core.constraint.IsBoolean();
           
           testCase.verifyFalse( c.isValid(1) );
           testCase.verifyFalse( c.isValid(-1.2) );
           testCase.verifyFalse( c.isValid(pi) );
           testCase.verifyFalse( c.isValid([1, pi]) );
           testCase.verifyTrue( c.isValid(true) );
           testCase.verifyFalse( c.isValid([true, false]) );
           testCase.verifyFalse( c.isValid('NY') );
           testCase.verifyFalse( c.isValid({1,2}) );
        end
        
    end
    
end
