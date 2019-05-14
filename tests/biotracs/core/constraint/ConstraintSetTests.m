classdef ConstraintSetTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)

        function testMain(testCase)
           c1 = biotracs.core.constraint.IsInteger();
           c2 = biotracs.core.constraint.IsPositive();
           
           c = biotracs.core.constraint.ConstraintSet();
           c.addElements('c1', c1, 'c2', c2);
           
           testCase.verifyTrue( c.isValid(1) );
           testCase.verifyTrue( c.isValid(3.00) );
           
           testCase.verifyFalse( c.isValid([4.00, 3]) );
           
           testCase.verifyFalse( c.isValid(-4.00) );
           testCase.verifyFalse( c.isValid([-4.00, 3]) );
           testCase.verifyFalse( c.isValid(-1.2) );
           testCase.verifyFalse( c.isValid(pi) );
           testCase.verifyFalse( c.isValid([1, pi]) );
           testCase.verifyFalse( c.isValid(true) );
           testCase.verifyFalse( c.isValid([true, false]) );
           testCase.verifyFalse( c.isValid('NY') );
           testCase.verifyFalse( c.isValid({1,2}) );
           
           
           testCase.verifyFalse( c.isEqualTo({1,2}) );
           testCase.verifyFalse( c.isEqualTo(c1) );
           testCase.verifyFalse( c.isEqualTo(c2) );
           testCase.verifyTrue( c.isEqualTo(c.copy()) );
           
           c3 = biotracs.core.constraint.ConstraintSet();
           c3.addElements('c2', c2, 'c1', c1);
           testCase.verifyTrue( c.isEqualTo(c3) );
           testCase.verifyFalse( c.isEqualTo(c3, true) );
           %testCase.verifyEqual(c.summary(), 'biotracs.core.constraint.IsInteger() AND biotracs.core.constraint.IsBetween(lb = 0, ub = Inf, isLbStrict = 0, isUbStrict = 0)');
        end
     
    end
    
end
