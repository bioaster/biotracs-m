classdef ReaderTests < matlab.unittest.TestCase

    properties (TestParameter)
    end

    methods (Test)
        
        function TestReadXML(testCase)
            %return;
            file = '../testdata/xml/toy.xml';
            
            % ---
            s = biotracs.core.xml.helper.Reader.parseFile( file, true );
            testCase.verifyEqual( s.Name, 'city' );
            testCase.verifyEqual( length(s.Children), 3 );
            testCase.verifyEqual( s.Children(1).Name, 'zone' );
            testCase.verifyEqual( s.Children(2).Name, 'zone' );
            testCase.verifyEqual( s.Children(3).Name, 'doc' );
            
            % ---
            s = biotracs.core.xml.helper.Reader.parseFile( file, false, 2:3 );
            testCase.verifyEmpty( s );
            
            % ---
            dom = biotracs.core.xml.helper.Reader.parseFile( file );
            testCase.verifyEqual( dom.Name, 'city' );
            testCase.verifyEqual( length(dom.Children), 1 );
            testCase.verifyClass( dom.Children, 'org.apache.xerces.dom.DeferredElementImpl' );
            childDom = biotracs.core.xml.helper.Reader.parseChildNodes( dom.Children );
            testCase.verifyEqual( length(childDom), 3 );
            testCase.verifyEqual( childDom(1).Name, 'zone' );
            testCase.verifyEqual( childDom(2).Name, 'zone' );
            testCase.verifyEqual( childDom(3).Name, 'doc' );
        end

    end
    
end
