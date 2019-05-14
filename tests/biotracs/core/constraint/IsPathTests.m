classdef IsPathTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)

        function testMain(testCase)
           c = biotracs.core.constraint.IsPath();
           
           testCase.verifyFalse( c.isValid(1) );
           testCase.verifyFalse( c.isValid(-1.2) );
           testCase.verifyFalse( c.isValid(pi) );
           testCase.verifyFalse( c.isValid([1, pi]) );
           testCase.verifyFalse( c.isValid(true) );
           
           testCase.verifyTrue( c.isValid('C:/path/file.ext') );
           testCase.verifyTrue( c.isValid('C:/path/../path/./') );
           testCase.verifyTrue( c.isValid('C:/path') );
           testCase.verifyTrue( c.isValid('C:/') );
           testCase.verifyTrue( c.isValid('C:') );
           testCase.verifyTrue( c.isValid('/path') );
           
           testCase.verifyTrue( c.isValid('\\path\file.ext') );
           testCase.verifyTrue( c.isValid('\\path\\\\file.ext') );
           testCase.verifyTrue( c.isValid('\path\') );
           
           %testCase.verifyEqual(c.summary(), 'biotracs.core.constraint.IsPath()');
        end
    
    end
    
end
