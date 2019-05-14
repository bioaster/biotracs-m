classdef ParameterTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    methods (Test)
        
        function testDefaultConstructor(testCase)
            param = biotracs.core.mvc.model.Parameter('pi', 3.14);
            testCase.verifyClass(param, 'biotracs.core.mvc.model.Parameter');
            testCase.verifyEqual(param.getValue(), 3.14);
            testCase.verifyEqual(param.isHydratable(), true);
            testCase.verifyEqual(param.getConstraint(), []);
        end
        
        
        function testBoundary(testCase)
            param = biotracs.core.mvc.model.Parameter('pi', 3.14);

            c0 = biotracs.core.constraint.IsBetween( [0, 10] );
            c1 = biotracs.core.constraint.IsBetween( [0, 2] );
            
            param.setConstraint( c0 );
            testCase.verifyEqual(param.getConstraint(), c0);
            testCase.verifyEqual(param.areConstraintsValidated(), true);
            
            param.setConstraint( c1 );
            testCase.verifyEqual(param.areConstraintsValidated(), false);
        end
        
        function testStrictBoundaryOnUpperBound(testCase)
            param = biotracs.core.mvc.model.Parameter('pi', 3.14);

            c0 = biotracs.core.constraint.IsBetween( [0, 3.14] );
            c1 = biotracs.core.constraint.IsBetween( [0, 3.14], 'StrictLowerBound', false, 'StrictUpperBound', true );
            
            param.setConstraint( c0 );
            testCase.verifyEqual(param.areConstraintsValidated(), true);
          
            param.setConstraint( c1 );
            testCase.verifyEqual(param.areConstraintsValidated(), false);
        end
        
        function testStrictBoundaryOnLowerBound(testCase)
            param = biotracs.core.mvc.model.Parameter('pi', 3.14);

            c0 = biotracs.core.constraint.IsBetween( [3.14, 5] );
            c1 = biotracs.core.constraint.IsBetween( [3.14, 5], 'StrictLowerBound', true, 'StrictUpperBound', false );
            
            param.setConstraint( c0 );
            testCase.verifyEqual(param.areConstraintsValidated(), true);
          
            param.setConstraint( c1 );
            testCase.verifyEqual(param.areConstraintsValidated(), false);
        end
        
        function testIsGreaterThan(testCase)
            param = biotracs.core.mvc.model.Parameter('pi', 3.14);

            c0 = biotracs.core.constraint.IsGreaterThan( 3.14 );
            c1 = biotracs.core.constraint.IsGreaterThan( 3.14, 'Strict', true );   %strict
            
            param.setConstraint( c0 );
            testCase.verifyEqual(param.areConstraintsValidated(), true);
          
            param.setConstraint( c1 );
            testCase.verifyEqual(param.areConstraintsValidated(), false);
        end
        
        function testIsLessThan(testCase)
            param = biotracs.core.mvc.model.Parameter('pi', 3.14);

            c0 = biotracs.core.constraint.IsGreaterThan( 3.14 );
            c1 = biotracs.core.constraint.IsGreaterThan( 3.14, 'Strict', true );   %strict
            
            param.setConstraint( c0 );
            testCase.verifyEqual(param.areConstraintsValidated(), true);
          
            param.setConstraint( c1 );
            testCase.verifyEqual(param.areConstraintsValidated(), false);
        end
        
        function testIsBoolean(testCase)
            param = biotracs.core.mvc.model.Parameter('pi', 3.14);

            c0 = biotracs.core.constraint.IsBoolean();
            
            param.setConstraint( c0 );
            testCase.verifyEqual(param.areConstraintsValidated(), false);
          
            param.setValue( false );
            testCase.verifyEqual(param.areConstraintsValidated(), true);
        end
        
        
        function testIsText(testCase)
            param = biotracs.core.mvc.model.Parameter('pi', 3.14);

            c0 = biotracs.core.constraint.IsText();
            
            param.setConstraint( c0 );
            testCase.verifyEqual(param.areConstraintsValidated(), false);
          
            param.setValue( 'Ceci est un text' );
            testCase.verifyEqual(param.areConstraintsValidated(), true);
        end
        
        function testIsInSet(testCase)
            param = biotracs.core.mvc.model.Parameter('pi', 3.14);

            c0 = biotracs.core.constraint.IsInSet({'val1', 3, 'val3', pi});
            
            param.setConstraint( c0 );
            testCase.verifyEqual(param.areConstraintsValidated(), false);
            
            param.setValue( pi );
            testCase.verifyEqual(param.areConstraintsValidated(), true);
        end

    end
    
end