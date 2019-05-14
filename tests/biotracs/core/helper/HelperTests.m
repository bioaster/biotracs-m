classdef HelperTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)
        function testDefaultConstructor(testCase)
            d = MyFakeTestHelpable();
            d.bindHelper( MyFakeTestHelper() );
            
            [o1, o2] = d.getHelper().computeBlabla( 8 );
            
            testCase.verifyEqual( o1, 'yes' );
            testCase.verifyEqual( o2, 8 );
            testCase.verifyEqual( d.getHelper().getHelpable(), d );
        end
      
    end
    
end
