classdef IsTextTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)

        function testMain(testCase)
           c = biotracs.core.constraint.IsText();
           
           testCase.verifyFalse( c.isValid(1) );
           testCase.verifyFalse( c.isValid(-1.2) );
           testCase.verifyFalse( c.isValid(pi) );
           testCase.verifyFalse( c.isValid([1, pi]) );
           testCase.verifyFalse( c.isValid(true) );
           testCase.verifyTrue( c.isValid('NY') );
           testCase.verifyFalse( c.isValid(['NY';'US']) );
           testCase.verifyFalse( c.isValid({1,2}) );
           testCase.verifyFalse( c.isValid({'Yes','No'}) );
           testCase.verifyTrue( c.isValid({}) );
           testCase.verifyTrue( c.isValid([]) );
           testCase.verifyTrue( c.isValid('') );
        end
    
        
        function testIsTextNonScalar(testCase)
           c = biotracs.core.constraint.IsText('IsScalar', false);
           
           testCase.verifyFalse( c.isValid(1) );
           testCase.verifyFalse( c.isValid(-1.2) );
           testCase.verifyFalse( c.isValid(pi) );
           testCase.verifyFalse( c.isValid([1, pi]) );
           testCase.verifyFalse( c.isValid(true) );
           testCase.verifyFalse( c.isValid('NY') );
           testCase.verifyFalse( c.isValid(['NY';'US']) );
           testCase.verifyFalse( c.isValid({1,2}) );
           testCase.verifyTrue( c.isValid({'Yes','No'}) );
           testCase.verifyTrue( c.isValid({}) );
           testCase.verifyTrue( c.isValid([]) );
           testCase.verifyTrue( c.isValid('') );
        end
        
    end
    
end
