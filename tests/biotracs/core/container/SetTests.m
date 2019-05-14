classdef SetTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)

        function testConstructor(testCase)
            s = biotracs.core.container.Set();
            testCase.verifyEqual( s.getLength, 0 );
            
            s.add( {1,2,3} );
            s.add( double(pi) );
            
            testCase.verifyEqual( s.getLength, 2 );
            testCase.verifyEqual( s.getAt(1), {1,2,3} );
            testCase.verifyEqual( s.getAt(2), double(pi) );
            
            s.setAt( 1, biotracs.core.container.Set() );
            testCase.verifyEqual( s.getAt(1), biotracs.core.container.Set() );
        end
        
        function testCopyConstructor(testCase)
            s = biotracs.core.container.Set();            
            s.add( {1,2,3} );
            s.add( double(pi) );
            subset = biotracs.core.container.Set();
            s.add( subset );
            
            subsetCopy = biotracs.core.container.Set( subset );
            sCopy = biotracs.core.container.Set(s);
            
            testCase.verifyEqual( sCopy, s );
            testCase.verifyTrue( sCopy ~= s );              %not shallow copy
            testCase.verifyEqual( sCopy.getLength, 3 );
            testCase.verifyEqual( sCopy.getAt(1), {1,2,3} );
            testCase.verifyEqual( sCopy.getAt(2), double(pi) );
            testCase.verifyEqual( sCopy.getAt(3), subset );
            testCase.verifyTrue( sCopy.getAt(3) ~= subset );  %Deep copy on subelements
            
            %changed copyied object and check that the original do not change
            testCase.verifyEqual( subset, subsetCopy );
            testCase.verifyTrue( subset ~= subsetCopy );
            subset.add('nothing').add('all');
            testCase.verifyNotEqual( subset, subsetCopy );
            
            % sCopy did not change because subsets are NOT shallow copies
            testCase.verifyNotEqual( sCopy, s );
            testCase.verifyEqual( s.getAt(3), subset );
            testCase.verifyNotEqual( sCopy.getAt(3), subset );
        end
        
        function testSingleClassNameOfElements(testCase)
            s = biotracs.core.container.Set(0, 'biotracs.core.container.Set');
            testCase.verifyEqual( s.getLength, 0 );
            
            s.add( biotracs.core.container.Set );
            try
                s.add( {1,2,3} );
            catch err
                testCase.verifyEqual( err.identifier, 'BIOTRACS:Set:ElementNotAllowed' );
            end
            
            testCase.verifyEqual( s.getLength, 1 );
            testCase.verifyEqual( s.getAt(1), biotracs.core.container.Set );
            
            try
                s.setAt( 2, {1,2,3} );
                error('An error was expected');
            catch err
                testCase.verifyEqual( err.identifier, 'BIOTRACS:Set:ElementNotAllowed' );
            end
            
            try
                s.setAt( 2, biotracs.core.container.Set );
                error('An error was expected');
            catch err
                testCase.verifyEqual( err.identifier(), 'BIOTRACS:Set:IndexOutOfRange' );
            end
            
        end
        
        function testSeveralClassNameOfElements(testCase)
            s = biotracs.core.container.Set(0, {'biotracs.core.container.Set', 'cell'});
            testCase.verifyEqual( s.getLength, 0 );
            
            s.add( biotracs.core.container.Set );
            s.add( {1,2,3} );
            try
                s.add( [1,2,3] );
            catch err
                testCase.verifyEqual( err.identifier, 'BIOTRACS:Set:ElementNotAllowed' );
            end
        end
        
        function testSetterGetterByName(testCase)
            s = biotracs.core.container.Set();
            s.set('Data', {1,2,3});
            s.add(123);
            
            testCase.verifyEqual( s.getLength, 2 );
            testCase.verifyEqual( s.getAt(1), {1,2,3} );
            testCase.verifyEqual( s.getAt(1), s.get('Data') );
            testCase.verifyEqual( s.getAt(2), 123 );
            
            s.add('Paris', 'City');
            testCase.verifyEqual( s.getLength, 3 );
            testCase.verifyEqual( s.getAt(3), 'Paris' );
            testCase.verifyEqual( s.get('City'), 'Paris' );
            
            s.set('Data', []);
            testCase.verifyEqual( s.getLength, 3 );
            testCase.verifyEqual( s.get('Data'), [] );
            
            try
                s.add( 'Data', {1} );
            catch err
                testCase.verifyEqual( err.identifier(), 'BIOTRACS:Set:InvalidArguments' );
            end
            
            try
                s.add( {1}, 'Data' );
            catch err
                testCase.verifyEqual( err.identifier(), 'BIOTRACS:Set:Duplicate' );
            end
            
            try
                s.setElementName( 1, 'Data' );
            catch err
                testCase.verifyEqual( err.identifier(), 'BIOTRACS:Set:Duplicate' );
            end
            
            s.setElementName( 1, 'NewData' );
            testCase.verifyEqual( s.getElementName(1), 'NewData' );
        end
        
        function testCopy( testCase )
            s1 = biotracs.core.container.Set();
            s1.set('Data', {1,2,3});
            s1.add(123);
            
            s2 = s1.copy();
            testCase.verifyEqual( s1, s2 );
        end
        
        function testConcat( testCase )
            s1 = biotracs.core.container.Set();
            s1.set('Data', {1,2,3});
            s1.add(123);
            
            testCase.verifyEqual( s1.getLength, 2 );
            testCase.verifyEqual( s1.getAt(1), {1,2,3} );
            
            
            s2 = biotracs.core.container.Set();
            s2.set('Data2', {'abc',2,3});
            s2.add(pi);
            s2.add(3*pi);
            testCase.verifyEqual( s2.getLength, 3 );
            
            s3 = concat(s1,s2);
            testCase.verifyEqual( s3.getLength, 5 );
            testCase.verifyEqual( s3.getAt(1), {1,2,3} );
            testCase.verifyEqual( s3.getAt(5), 3*pi );
            testCase.verifyEqual( s3.getAt(3), {'abc',2,3} );
            testCase.verifyEqual( s3.getElementNames(), [s1.getElementNames(), s2.getElementNames()] );
            testCase.verifyEqual( s3.getElements(), [s1.getElements(), s2.getElements()] );
            
            s5 = concat(s3, biotracs.core.container.Set());
            testCase.verifyEqual( s5, s3 );
            
            s6 = concat(biotracs.core.container.Set() ,s3);
            testCase.verifyEqual( s6, s3 );
            
            s3 = biotracs.core.container.Set();
            s2.set('Beijin', {'abc',2,3});
            s2.add(pi);
            s2.add(3*pi);
            s7 = concat(s1,s2,s3);
            s7.summary
            testCase.verifyEqual( s7.getLength, 8 );
        end
        
        
        function testRemove( testCase )
            s = biotracs.core.container.Set();
            s.set('Name1', {1,2,3});
            s.add(123,'Name2');
            s.add('Paris','Name3');
            
            
            testCase.verifyEqual( s.getLength(), 3 );
            testCase.verifyEqual( s.getAt(1), {1,2,3} );
            testCase.verifyEqual( s.getAt(2), 123 );
            
            s.remove('Name2');
            testCase.verifyEqual( s.getLength(), 2 );
            testCase.verifyEqual( s.getAt(1), {1,2,3} );
            testCase.verifyEqual( s.getAt(2), 'Paris' );
            testCase.verifyEqual( s.getElementIndexByName('Name3'), 2 );
        end
        
        function testAddListOfElementsWithCell( testCase )
            s = biotracs.core.container.Set();
            s.addElements(...
                'Name1', {1,2,3}, ...
                'Name2', 123, ...
                'Name3','Paris');
            
            testCase.verifyEqual( s.getLength(), 3 );
            testCase.verifyEqual( s.getAt(1), {1,2,3} );
            testCase.verifyEqual( s.getAt(2), 123 );
            testCase.verifyEqual( s.get('Name3'), 'Paris' );
        end
        
    end
    
end
