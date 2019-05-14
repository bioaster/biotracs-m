classdef IsGreaterThanTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)

        function testMain(testCase) 
           c = biotracs.core.constraint.IsGreaterThan( 0, 'Strict', false);
           
           testCase.verifyTrue( c.isValid(1) );
           testCase.verifyTrue( c.isValid(0) );
           testCase.verifyFalse( c.isValid(-1.2) );
           testCase.verifyTrue( c.isValid(pi) );
           testCase.verifyFalse( c.isValid([1, pi]) );
           testCase.verifyFalse( c.isValid(true) );
           testCase.verifyFalse( c.isValid('NY') );
           testCase.verifyFalse( c.isValid({1,2}) );
        end
    
    end
    
end
